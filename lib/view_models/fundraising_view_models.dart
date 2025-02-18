import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/locator.dart';
import 'package:flutter_fundraising_goal_chart/models/fundraising_model.dart';
import 'package:flutter_fundraising_goal_chart/services/user_repository.dart';
import 'package:uuid/uuid.dart';

enum ViewState { Busy, Idle }

class FundraisingViewModels with ChangeNotifier {
  final UserRepository userRepository = locator<UserRepository>();

  ViewState _viewState = ViewState.Idle;

  ViewState get state => _viewState;

  FundraisingModel? _fundraisingModel;

  FundraisingModel? get fundraisingModel => _fundraisingModel;
  List<String> _dropdownItems = [];
  String? _selectedValue;

  List<String> get dropdownItems => _dropdownItems;

  String? get selectedValue => _selectedValue;

  @override
  Future<bool> createFundraising(Map<String, dynamic> fundraisingModel,
      String fundraisingID, String userID) async {
    try {
      _setState(ViewState.Busy);
      var createdFundraising = userRepository.createFundraising(
          fundraisingModel, fundraisingID, userID);

      _setState(ViewState.Idle);
      return true;
    } catch (e) {
      _setState(ViewState.Idle);
      return false;
    }
  }

  Future<List?> fetchFundraisingCommunity(String userID) async {
    try {
      _setState(ViewState.Busy);
      List<String> listName =
          await userRepository.fetchFundraisingCommunity(userID) as List<String>;

      _setState(ViewState.Idle);
      return listName;
    } catch (e) {
      _setState(ViewState.Idle);
      return null;
    }
  }

  void _setState(ViewState state) {
    _viewState = state;
    notifyListeners();
  }
}
