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
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseError(e);
    } catch (e) {
      throw "An unexpected error occurred. Please try again.";
    }
  }
  String _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case "invalid-email":
        return "The email address is not valid.";
      case "user-not-found":
        return "No user found with this email.";
      case "wrong-password":
        return "Incorrect password. Please try again.";
      case "user-disabled":
        return "This account has been disabled.";
      case "too-many-requests":
        return "Too many login attempts. Please try again later.";
      default:
        return "Authentication failed. Please check your credentials.";
    }
  }

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

  @override
  Future<bool?> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      debugPrint("Sign out error: ${e.toString()}");
      return false;
    }
  }

  @override
  Future<User?> checkCurrentUser() async {
    try {
      return firebaseAuth.currentUser;
    } catch (e) {
      debugPrint("Current User error: ${e.toString()}");
      return null;
    }
  }

  @override
  Future<bool?> updatePassword(String newPassword) async {
    try {
      await firebaseAuth.currentUser!.updatePassword(newPassword);
      return true;
    } catch (e) {
      debugPrint("Update error: ${e.toString()}");
      return false;
    }
  }
}
