import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_fundraising_goal_chart/models/user_model.dart';
import 'package:flutter_fundraising_goal_chart/services/firestore_db_base.dart';

class FirestoreDbService implements FirestoreDbBase {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<UserModel?> getUserData(String userID) async {
    try {
      DocumentSnapshot _readUser =
          await _firebaseFirestore.doc('users/$userID').get();

      Map<String, dynamic>? _readUserInformationMap =
          _readUser.data() as Map<String, dynamic>;

      debugPrint('ben readuserdayim ${_readUserInformationMap.toString()}');

      return UserModel.fromMap(_readUserInformationMap);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<bool?> saveUser(UserModel userModel) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(userModel.userID)
          .set(userModel.toMap(), SetOptions(merge: true));
      debugPrint(userModel.toMap().toString());
      DocumentSnapshot documentSnapshot =
          await _firebaseFirestore.doc('users/${userModel.userID}').get();
      Map<String, dynamic>? _readUserMap =
          documentSnapshot.data() as Map<String, dynamic>;
      UserModel readUserModel = UserModel.fromMap(_readUserMap);
      debugPrint('save user read' + readUserModel.toString());
      readUserModel.fullName;
      readUserModel.userID;
    } catch (e) {
      print(e.toString());
      return false;
    }
    return null;
  }

  @override
  Future<bool?> updateUserProfile(
      String userID, Map<String, dynamic> updatedFields) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(userID)
          .update(updatedFields);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
