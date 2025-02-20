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

  void listenToDonations(String userID, String fundraisingID) {
    donationService.getDonations(userID, fundraisingID).listen((donationList) {
      _donations = donationList;
      notifyListeners();
    });
  }

  Future<void> addDonation(DonationModel donationModel) async {
    await donationService.addDonation(donationModel);
  }

  double get targetProgress {
    double totalDonated = _donations.fold(0, (sum, donation) {return sum + donation.donationAmount;});
    double value=(totalDonated / 100000) * 100;
    if (value>100) {
      value=100;
    }

    return  value;
  }
}
