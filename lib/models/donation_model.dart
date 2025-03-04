import 'package:cloud_firestore/cloud_firestore.dart';

class DonationModel {
  String communityName;
  double donationAmount;
  String donorName;
  String fundraisingID;
  String userID;
  Timestamp? timestamp;
  String donationID;

  DonationModel(
      {required this.communityName,
      required this.donationAmount,
      required this.donorName,
      required this.fundraisingID,
      required this.userID,
      required this.donationID,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'communityName': communityName,
      'donationAmount': donationAmount,
      'donorName': donorName,
      'fundraisingID': fundraisingID,
      'userID': userID,
      'timestamp': timestamp ?? Timestamp.now(),
      'donationID': donationID
    };
  }

  factory DonationModel.fromMap(Map<String, dynamic> map) {
    return DonationModel(
        communityName: map['communityName'] as String,
        donationAmount: map['donationAmount'] as double,
        donorName: map['donorName'] as String,
        fundraisingID: map['fundraisingID'] as String,
        userID: map['userID'] as String,
        donationID: map['donationID'] as String,
        timestamp: map['timestamp'] as Timestamp);
  }

  @override
  String toString() {
    return 'DonationModel{donationID:$donationID,communityName: $communityName, donationAmount: $donationAmount, donorName: $donorName, fundraisingID: $fundraisingID, userID: $userID}';
  }
}
