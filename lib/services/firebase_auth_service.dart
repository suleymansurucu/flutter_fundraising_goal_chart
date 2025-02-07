import 'package:flutter/cupertino.dart';
import 'package:flutter_fundraising_goal_chart/models/user_model.dart';
import 'package:flutter_fundraising_goal_chart/services/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  UserModel? userModelFromFirebase(User user) {
    return UserModel(userID: user.uid, email: user.email.toString());
  }

  @override
  Future<UserModel?> createWithInEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userModelFromFirebase(userCredential.user as User);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      UserModel? userModel = userModelFromFirebase(userCredential.user as User);
      return userModel;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
