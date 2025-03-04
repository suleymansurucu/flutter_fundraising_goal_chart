import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/locator.dart';
import 'package:flutter_fundraising_goal_chart/models/donation_model.dart';
import 'package:flutter_fundraising_goal_chart/services/donation_service.dart';
import 'package:flutter_fundraising_goal_chart/view_models/fundraising_view_models.dart';
import 'package:provider/provider.dart';

class DonationViewModels with ChangeNotifier {
  final DonationService donationService = locator<DonationService>();

  DonationModel? _donationModel;

  DonationModel? get donationModel => _donationModel;

  List<DonationModel> _donations = [];

  List<DonationModel> get donations => _donations;
  StreamSubscription<List<DonationModel>>? _donationSubscription;

  String? donorNameError;
  String? donorAmountError;
  double? _showRealTargetProgress = 0.0;
  double? get showRealTargetProgress => _showRealTargetProgress;

  bool validateForm(TextEditingController donorNameController,
      TextEditingController donorAmountController) {
    bool isValid = true;

    if (donorNameController.text.trim().isEmpty) {
      donorNameError = 'Donor name is required';
      isValid = false;
    } else if (donorNameController.text.trim().length < 3) {
      donorNameError = 'Donor name must be at least 3 characters';
      isValid = false;
    } else if (!RegExp(r"^[a-zA-ZğüşıöçĞÜŞİÖÇ\s]+$")
        .hasMatch(donorNameController.text.trim())) {
      donorNameError = "Donor name must contain only letters!";
      isValid = false;
    } else {
      donorNameError = null;
    }
    if (donorAmountController.text.trim().isEmpty) {
      donorAmountError = 'Donor Amount is required';
      isValid = false;
    } else {
      donorAmountError = null; // Clear error if valid
    }

    notifyListeners();
    return isValid;
  }

  void listenToDonations(String userID, String fundraisingID,
      String communityName, int communityCount) {
    // Önceki aboneliği güvenli bir şekilde iptal et
    _donationSubscription?.cancel();
    _donationSubscription = null; // Güvenliği artırmak için null atıyoruz.

    debugPrint('📢 Yeni bağışları dinlemeye başlıyoruz...');
    debugPrint('👥 Community Name: $communityName');
    debugPrint('🌍 Community Count: $communityCount');

    try {
      _donationSubscription = donationService
          .getDonations(userID, fundraisingID, communityName, communityCount)
          .listen((donationList) {
        debugPrint(
            '🔥 Bağış listesi güncellendi: ${donationList.length} adet bağış alındı.');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _donations = donationList;
          notifyListeners();
        });
      });
    } catch (e, stackTrace) {
      debugPrint('❌ Firestore dinleme hatası: $e');
      debugPrint(stackTrace.toString());
    }
  }

  @override
  void dispose() {
    _donationSubscription?.cancel();
    super.dispose();
  }

  Future<void> addDonation(DonationModel donationModel) async {
    await donationService.addDonation(donationModel);
  }

  double targetProgress(fundraisingTarget) {
    double totalDonated = _donations.fold(0, (sum, donation) {
      return sum + donation.donationAmount;
    });
    double value = (totalDonated / fundraisingTarget) * 100;
    _showRealTargetProgress = value;
    if (value > 100) {
      value = 100;
    }

    notifyListeners();
    return value;
  }

  double get totalDonated {
    double totalDonated = _donations.fold(0, (sum, donation) {
      return sum + donation.donationAmount;
    });
    return totalDonated;
  }

  Future<void> deleteDonation(DonationModel donationModel) async {
    await donationService.deleteDonation(donationModel);
  }
}
