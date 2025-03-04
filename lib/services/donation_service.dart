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
          .collection('donations')
          .doc(donationModel.donationID)
          .set(donationModel.toMap());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Stream<List<DonationModel>> getDonations(String userID, String fundraisingID,
      String? communityName, int? communityCount) {
    if (communityName == 'general') {
      var query = firestore
          .collection('users')
          .doc(userID)
          .collection('fundraiser')
          .doc(fundraisingID)
          .collection('donations')
          .orderBy('timestamp', descending: true);
      return query.snapshots().map((snapshot) => snapshot.docs.map((doc) {
            var donation = DonationModel.fromMap(doc.data());
            debugPrint('Database servis: ${donation.toString()}');
            return donation;
          }).toList());
    } else {
      var query = firestore
          .collection('users')
          .doc(userID)
          .collection('fundraiser')
          .doc(fundraisingID)
          .collection('donations')
          .where('communityName', isEqualTo: communityName)
          .orderBy('timestamp', descending: true);

      //where('communityName', isEqualTo: communityName);

      debugPrint('CommunityCounti aliyoruz? ${communityCount.toString()}');

      return query.snapshots().map((snapshot) => snapshot.docs.map((doc) {
            var donation = DonationModel.fromMap(doc.data());
            debugPrint('Database servis: ${donation.toString()}');
            return donation;
          }).toList());
    }
  }

  Future<void> deleteDonation(
      DonationModel donationModel) async {
    try {
      firestore
          .collection('users')
          .doc(donationModel.userID)
          .collection('fundraiser')
          .doc(donationModel.fundraisingID)
          .collection('donations')
          .doc(donationModel.donationID)
          .delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
