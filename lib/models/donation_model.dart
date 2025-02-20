class DonationModel {
  String communityName;
  double donationAmount;
  String donorName;
  String fundraisingID;
  String userID;

  DonationModel({
    required this.communityName,
    required this.donationAmount,
    required this.donorName,
    required this.fundraisingID,
    required this.userID,
  });

  Map<String, dynamic> toMap() {
    return {
      'communityName': this.communityName,
      'donationAmount': this.donationAmount,
      'donorName': this.donorName,
      'fundraisingID': this.fundraisingID,
      'userID': this.userID,
    };
  }

  factory DonationModel.fromMap(Map<String, dynamic> map) {
    return DonationModel(
      communityName: map['communityName'] as String,
      donationAmount: map['donationAmount'] as double,
      donorName: map['donorName'] as String,
      fundraisingID: map['fundraisingID'] as String,
      userID: map['userID'] as String,
    );
  }

  @override
  String toString() {
    return 'DonationModel{communityName: $communityName, donationAmount: $donationAmount, donorName: $donorName, fundraisingID: $fundraisingID, userID: $userID}';
  }
}
