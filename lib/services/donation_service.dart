import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_fundraising_goal_chart/models/donation_model.dart';

class DonationService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  Future<void> addDonation(DonationModel donationModel) async {
    try {
      await firestore
          .collection('users')
          .doc(donationModel.userID)
          .collection('fundraiser')
          .doc(donationModel.fundraisingID)
          .set(donationModel.toMap());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Stream<List<DonationModel>> getDonations(String userID, String fundraisingID) {
    return firestore
        .collection('users')
        .doc(userID)
        .collection('fundraiser')
        .doc(fundraisingID)
        .collection('donations')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return DonationModel.fromMap(doc.data());
      }).toList();
    });
  }
}
