import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/locator.dart';
import 'package:flutter_fundraising_goal_chart/models/donation_model.dart';
import 'package:flutter_fundraising_goal_chart/models/fundraising_model.dart';
import 'package:flutter_fundraising_goal_chart/services/donation_service.dart';

class DonationViewModels with ChangeNotifier {
  final DonationService donationService = locator<DonationService>();

  DonationModel? _donationModel;

  DonationModel? get donationModel => _donationModel;

  List<DonationModel> _donations = [];

  List<DonationModel> get donations => _donations;
  StreamSubscription<List<DonationModel>>? _donationSubscription;

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
        debugPrint('🔥 Bağış listesi güncellendi: ${donationList.length} adet bağış alındı.');
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

  double get targetProgress {
    double totalDonated = _donations.fold(0, (sum, donation) {
      return sum + donation.donationAmount;
    });
    double value = (totalDonated / 100000) * 100;
    if (value > 100) {
      value = 100;
    }
    return value;
  }

  double get totalDonated {
    double totalDonated = _donations.fold(0, (sum, donation) {
      return sum + donation.donationAmount;
    });
    return totalDonated;
  }
}
