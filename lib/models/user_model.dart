class UserModel {
  final String userID;
  final String email;
  DateTime? createdAt;
  String? fullName;
  String? communityName;
  String? addressLine1;
  String? city;
  String? state;
  String? zipCode;

  UserModel(
      {required this.userID,
      required this.email,
      this.createdAt,
      this.fullName,
      this.communityName,
      this.addressLine1,
      this.city,
      this.state,
      this.zipCode});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'fullName': fullName,
      'createdAt': createdAt,
      'communityName': communityName?.isEmpty ?? true ? '' : communityName,
      'addressLine1': addressLine1?.isEmpty ?? true ? '' : addressLine1,
      'city': city?.isEmpty ?? true ? '' : city,
      'state': state?.isEmpty ?? true ? '' : state,
      'zipCode': zipCode?.isEmpty ?? true ? '' : zipCode
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userID: map['userID'] as String,
      email: map['email'] as String,
      fullName: map['fullName'] as String,
      createdAt: map['createdAt'].toDate(),
      communityName: map['communityName'] as String? ?? '',
      addressLine1: map['addressLine1'] as String? ?? '',
      city: map['city'] as String? ?? '',
      state: map['state'] as String? ?? '',
      zipCode: map['zipCode'] as String? ?? '',
    );
  }

  @override
  String toString() {
    return 'UserModel{userID: $userID, email: $email, fullNAme : $fullName, createdAt: $createdAt, communityName: $communityName, addressLine1: $addressLine1, city : $city, state: $state, zipCode: $zipCode}';
  }
}
