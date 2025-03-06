import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/locator.dart';
import 'package:flutter_fundraising_goal_chart/models/fundraising_model.dart';
import 'package:flutter_fundraising_goal_chart/models/user_model.dart';
import 'package:flutter_fundraising_goal_chart/services/auth_base.dart';
import 'package:flutter_fundraising_goal_chart/services/firestore_db_base.dart';
import 'package:flutter_fundraising_goal_chart/services/user_repository.dart';

enum ViewState { Busy, Idle }

class UserViewModels with ChangeNotifier implements AuthBase, FirestoreDbBase {
  final UserRepository userRepository = locator<UserRepository>();

  ViewState _viewState = ViewState.Idle;

  ViewState get state => _viewState;

  UserModel? _userModel;

  UserModel? get userModel => _userModel;
  String? _fullName;

  String? get fullName => _fullName;

  String? emailError;
  String? userNameError;
  String? passwordError;
  String? confirmPasswordError;
  String? communityNameError;
  String? addressLine1Error;
  String? cityError;
  String? stateError;
  String? zipCodeError;

  // Form doğrulama (Kayıt için)
  bool validateForm(emailController, userNameController, passwordController,
      confirmPasswordController) {
    bool isValid = true;

    if (emailController.text.isEmpty) {
      emailError = "Email cannot be empty";
      isValid = false;
    } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(emailController.text)) {
      emailError = "Enter a valid email";
      isValid = false;
    } else {
      emailError = null;
    }

    if (passwordController.text.isEmpty) {
      passwordError = "Password cannot be empty";
      isValid = false;
    } else if (passwordController.text.length < 6) {
      passwordError = "Password must be at least 6 characters long";
      isValid = false;
    } else {
      passwordError = null;
    }

    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError = "Please confirm your password";
      isValid = false;
    } else if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError = "Passwords do not match";
      isValid = false;
    } else {
      confirmPasswordError = null;
    }

    if (userNameController.text.isEmpty) {
      userNameError = "Full Name cannot be empty";
      isValid = false;
    } else {
      userNameError = null;
    }

    notifyListeners();
    return isValid;
  }

  // Form doğrulama (Giriş için)
  bool validateFormForSignIn(emailController, passwordController) {
    bool isValid = true;

    if (emailController.text.isEmpty) {
      emailError = "Email cannot be empty";
      isValid = false;
    } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(emailController.text)) {
      emailError = "Enter a valid email";
      isValid = false;
    } else {
      emailError = null;
    }

    if (passwordController.text.isEmpty) {
      passwordError = "Password cannot be empty";
      isValid = false;
    } else if (passwordController.text.length < 6) {
      passwordError = "Password must be at least 6 characters long";
      isValid = false;
    } else {
      passwordError = null;
    }

    notifyListeners();
    return isValid;
  }

  @override
  Future<UserModel?> createWithInEmailAndPassword(
      String email, String password) async {
    try {
      _setState(ViewState.Busy);
      UserModel? userModel =
          await userRepository.createWithInEmailAndPassword(email, password);
      _userModel = userModel;
      _setState(ViewState.Idle);
      return userModel;
    } catch (e) {
      _setState(ViewState.Idle);
      return null;
    }
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      _setState(ViewState.Busy);
      UserModel? userModel =
          await userRepository.signInWithEmailAndPassword(email, password);
      _userModel = userModel;
      _setState(ViewState.Idle);
      return userModel;
    } catch (e) {
      _setState(ViewState.Idle);
      return null;
    }
  }

  @override
  Future<UserModel?> getUserData(String userID) async {
    try {
      _setState(ViewState.Busy);
      UserModel? result = await userRepository.getUserData(userID);
      _userModel = result;
      print('Read de user okuyorum.');
      _setState(ViewState.Idle);
      return result;
    } catch (e) {
      _setState(ViewState.Idle);
      return null;
    }
  }

  @override
  Future<bool?> saveUser(UserModel userModel) async {
    try {
      _setState(ViewState.Busy);
      bool? result = await userRepository.saveUser(userModel);
      _setState(ViewState.Idle);
      return result;
    } catch (e) {
      _setState(ViewState.Idle);
      return false;
    }
  }

  @override
  Future<bool?> signOutWithEmailAndPassword(String userID) async {
    try {
      _setState(ViewState.Busy);
      bool? result = await userRepository.signOutWithEmailAndPassword(userID);
      if (result == true) {
        _userModel = null; // Kullanıcı durumunu sıfırla
        _fullName = null; // fullName'i sıfırla
      }
      _setState(ViewState.Idle);
      return result;
    } catch (e) {
      _setState(ViewState.Idle);
      return false;
    }
  }

  // Yardımcı metod: State'i güncelle ve UI'ı bildir
  void _setState(ViewState state) {
    _viewState = state;
    notifyListeners();
  }

  void _setFullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  @override
  Future<bool?> updateUserProfile(
      String userID, Map<String, dynamic> updatedFields) async {
    try {
      _setState(ViewState.Busy);
      bool? result =
          userRepository.updateUserProfile(userID, updatedFields) as bool?;

      _setState(ViewState.Idle);
      return result;
    } catch (e) {
      _setState(ViewState.Idle);
      return false;
    }
  }

  @override
  Future<bool?> createFundraising(Map<String, dynamic> fundraisingModel,
      String fundraisingID, String userID) async {
    // TODO: implement createFundraising
    throw UnimplementedError();
  }

  @override
  Future<List?> fetchFundraisingCommunity(String userID) {
    // TODO: implement fetchFundraisingCommunity
    throw UnimplementedError();
  }

  @override
  Future<bool?> saveDonation(String userID, String fundraisingID,
      String communityName, String donorName, double donationAmount) {
    // TODO: implement saveDonation
    throw UnimplementedError();
  }

  @override
  Future<List<FundraisingModel>?> fetchFundraising(String userID) {
    // TODO: implement fetchFundraising
    throw UnimplementedError();
  }

  @override
  Future<String?> getFundraisingIDByCommunityName(
      String userID, String communityName) {
    // TODO: implement getFundraisingIDByCommunityName
    throw UnimplementedError();
  }

  @override
  Future<FundraisingModel> getFundraiser(String userID, String fundraisingID) {
    // TODO: implement getFundraiser
    throw UnimplementedError();
  }

  @override
  Future<void> deleteFundraising(String userID, String fundraisingID) async {
    try {
      _setState(ViewState.Busy);
      userRepository.deleteFundraising(userID, fundraisingID);

      _setState(ViewState.Idle);
    } catch (e) {
      _setState(ViewState.Idle);
    }
  }
}
