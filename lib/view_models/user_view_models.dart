import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/locator.dart';
import 'package:flutter_fundraising_goal_chart/models/user_model.dart';
import 'package:flutter_fundraising_goal_chart/services/auth_base.dart';
import 'package:flutter_fundraising_goal_chart/services/user_repository.dart';

enum ViewState { Busy, Idle }

class UserViewModels with ChangeNotifier implements AuthBase {
  final UserRepository userRepository = locator<UserRepository>();

  ViewState _viewState = ViewState.Idle;

  ViewState get state => _viewState;

  set state(ViewState value) {
    _viewState = value;
    notifyListeners();
  }

  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  set userModel(UserModel? value) {
    _userModel = value;
  }
  String? emailError;
  String? userNameError;

  String? passwordError;
  String? confirmPasswordError;

  bool validateForm(emailController,userNamecontroller,passwordController,confirmPasswordController ) {
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

    if (userNamecontroller.text.isEmpty) {
      userNameError = "Full Name cannot be empty";
      isValid = false;
    }else {
      userNameError = null;
    }

    notifyListeners();
    return isValid;
  }
  bool validateFormForSignIn(emailController,passwordController ) {
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
      _viewState = ViewState.Busy;
      UserModel? userModel=await userRepository.createWithInEmailAndPassword(email, password);
      _viewState=ViewState.Idle;
      return userModel;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async{
    try {
      _viewState = ViewState.Busy;
      UserModel? userModel=await userRepository.signInWithEmailAndPassword(email, password);
      _viewState=ViewState.Idle;
      return userModel;
    } catch (e) {
      return null;
    }
  }
}
