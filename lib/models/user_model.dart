import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userID;
  final String email;
  DateTime? createdAt;
  String? fullName;

  UserModel(
      {required this.userID,
      required this.email,
      this.createdAt,
      this.fullName});

  Map<String, dynamic> toMap() {
    return {
      'userID': this.userID,
      'email': this.email,
      'fullName': fullName,
      'createdAt': this.createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userID: map['userID'] as String,
      email: map['email'] as String,
      fullName: map['fullName'] as String,
      createdAt: map['createdAt'] as DateTime,
    );
  }

  @override
  String toString() {
    return 'UserModel{userID: $userID, email: $email, fullNAme : $fullName, createdAt: $createdAt}';
  }
}
