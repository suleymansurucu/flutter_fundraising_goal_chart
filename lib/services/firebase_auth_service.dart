import 'package:flutter/cupertino.dart';
import 'package:flutter_fundraising_goal_chart/models/user_model.dart';
import 'package:flutter_fundraising_goal_chart/services/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();


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
      if (userModel != null) {
        debugPrint('firebase auth service ${userModel.fullName}');
      }
      return userModel;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override

  @override
  Future<bool?> signOutWithEmailAndPassword(String userID) async {
    try {
      await firebaseAuth.signOut();
      return true;
    } catch (e) {
      debugPrint("Sign out error: ${e.toString()}");
      return false;
    }
  }
}
