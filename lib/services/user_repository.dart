import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_fundraising_goal_chart/locator.dart';
import 'package:flutter_fundraising_goal_chart/models/fundraising_model.dart';
import 'package:flutter_fundraising_goal_chart/models/user_model.dart';
import 'package:flutter_fundraising_goal_chart/services/auth_base.dart';
import 'package:flutter_fundraising_goal_chart/services/firebase_auth_service.dart';
import 'package:flutter_fundraising_goal_chart/services/firestore_db_base.dart';
import 'package:flutter_fundraising_goal_chart/services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository with ChangeNotifier implements AuthBase, FirestoreDbBase {
  AppMode appMode = AppMode.RELEASE;

  final FirebaseAuthService firebaseAuthService =
      locator<FirebaseAuthService>();
  final FirestoreDbService firestoreDbService = locator<FirestoreDbService>();

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
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
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

  @override
  Future<UserModel?> getUserData(String userID) async {
    if (appMode == AppMode.DEBUG) {
      //TODO: I will create test data with connection
    } else {
      try {
        final user = firebaseAuthService.currentUser;
        if (user != null) {
          return await firestoreDbService.getUserData(userID);
        }
      } catch (e) {
        debugPrint(e.toString());
        return null;
      }
    }
    return null;
  }

  @override
  Future<bool?> saveUser(UserModel userModel) async {
    if (appMode == AppMode.DEBUG) {
      //TODO: I will create test data with connection
    } else {
      try {
        return await firestoreDbService.saveUser(userModel);
      } catch (e) {
        debugPrint(e.toString());
        return false;
      }
    }
    return null;
  }

  @override
  @override
  Future<bool?> signOutWithEmailAndPassword(String userID) async {
    if (appMode == AppMode.DEBUG) {
      //TODO: I will create test data with connection
    } else {
      try {
        var result =
            await firebaseAuthService.signOutWithEmailAndPassword(userID);
        return result;
      } catch (e) {
        debugPrint(e.toString());
        return false;
      }
    }
  }

  @override
  Future<bool?> updateUserProfile(
      String userID, Map<String, dynamic> updatedFields) async {
    if (appMode == AppMode.DEBUG) {
      //TODO: I will create test data with connection
    } else {
      try {
        var result =
            firestoreDbService.updateUserProfile(userID, updatedFields);
        return result;
      } catch (e) {
        debugPrint(e.toString());
        return false;
      }
    }
    return null;
  }

  @override
  Future<bool?> createFundraising(Map<String, dynamic> fundraisingModel,
      String fundraisingID, String userID) async {
    if (appMode == AppMode.DEBUG) {
      //TODO: I will create test data with connection
    } else {
      try {
        var result = firestoreDbService.createFundraising(
            fundraisingModel, fundraisingID, userID);
        return result;
      } catch (e) {
        debugPrint(e.toString());
        return null;
      }
    }
    return null;
  }

  @override
  Future<List?> fetchFundraisingCommunity(String userID) async {
    if (appMode == AppMode.DEBUG) {
      //TODO: I will create test data with connection
    } else {
      try {
        var result = await firestoreDbService.fetchFundraisingCommunity(userID);
        return result;
      } catch (e) {
        debugPrint(e.toString());
        return null;
      }
    }
    return null;
  }

  @override
  Future<bool?> saveDonation(String userID, String fundraisingID,
      String communityName, String donorName, double donationAmount) async {
    if (appMode == AppMode.DEBUG) {
      //TODO: I will create test data with connection
    } else {
      try {
        var result = await firestoreDbService.saveDonation(
            userID, fundraisingID, communityName, donorName, donationAmount);
        return result;
      } catch (e) {
        debugPrint(e.toString());
        return false;
      }
    }
  }

  @override
  Future<List<FundraisingModel>?> fetchFundraising(
    String userID,
  ) async {
    if (appMode == AppMode.DEBUG) {
      //TODO: I will create test data with connection
    } else {
      try {
        var result = await firestoreDbService.fetchFundraising(userID);
        return result;
      } catch (e) {
        debugPrint(e.toString());
        return null;
      }
    }
    return null;
  }

  @override
  Future<String?> getFundraisingIDByCommunityName(
      String userID, String communityName) async {
    if (appMode == AppMode.DEBUG) {
      //TODO: I will create test data with connection
    } else {
      try {
        var result = await firestoreDbService.getFundraisingIDByCommunityName(
            userID, communityName);
        return result;
      } catch (e) {
        debugPrint(e.toString());
        return null;
      }
    }
    return null;
  }

  @override
  Future<FundraisingModel?> getFundraiser(String userID,String fundraisingID) async{
    if (appMode == AppMode.DEBUG) {
      //TODO: I will create test data with connection
    } else {
      try {
        final user = firebaseAuthService.currentUser;
        if (user != null) {
          return await firestoreDbService.getFundraiser(userID,fundraisingID);
        }
      } catch (e) {
        debugPrint(e.toString());
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> deleteFundraising(String userID, String fundraisingID) async {
    if (appMode == AppMode.DEBUG) {
      //TODO: I will create test data with connection
    } else {
      try {
        final user = firebaseAuthService.currentUser;
        if (user != null) {
          return await firestoreDbService.deleteFundraising(userID,fundraisingID);
        }
      } catch (e) {
        debugPrint(e.toString());
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> deleteDonation(String userID, String fundraisingID) {
    // TODO: implement deleteDonation
    throw UnimplementedError();
  }
  Future<bool?> updateFundraising(String userID, String fundraisingID, Map<String, dynamic> updatedFields) async {
    if (appMode == AppMode.DEBUG) {
      //TODO: I will create test data with connection
    } else {
      try {
        final user = firebaseAuthService.currentUser;
        if (user != null) {
          return await firestoreDbService.updateFundraising(userID,fundraisingID,updatedFields);
        }
      } catch (e) {
        debugPrint(e.toString());
        return null;
      }
    }
    return null;
  }
}
