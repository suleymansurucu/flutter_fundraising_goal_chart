import 'package:flutter/cupertino.dart';
import 'package:flutter_fundraising_goal_chart/locator.dart';
import 'package:flutter_fundraising_goal_chart/models/user_model.dart';
import 'package:flutter_fundraising_goal_chart/services/auth_base.dart';
import 'package:flutter_fundraising_goal_chart/services/firebase_auth_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository with ChangeNotifier implements AuthBase {
  AppMode appMode = AppMode.RELEASE;

  final FirebaseAuthService firebaseAuthService =
      locator<FirebaseAuthService>();

  @override
  Future<UserModel?> createWithInEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      //TODO: I will create test data with connection
    } else {
      try {
        UserModel? userModel = await firebaseAuthService
            .createWithInEmailAndPassword(email, password);
        return userModel;
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    return null;
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async{
    if (appMode == AppMode.DEBUG) {
      //TODO: I will create test data with connection
    } else {
      try {
        UserModel? userModel = await firebaseAuthService
            .signInWithEmailAndPassword(email, password);
        return userModel;
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    return null;
  }
}
