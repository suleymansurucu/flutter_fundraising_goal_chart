import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_drop_down_menu.dart';
import 'package:flutter_fundraising_goal_chart/locator.dart';
import 'package:flutter_fundraising_goal_chart/models/fundraising_model.dart';
import 'package:flutter_fundraising_goal_chart/services/user_repository.dart';

class FundraisingPageViewModels with ChangeNotifier {
  final UserRepository userRepository = locator<UserRepository>();
  FundraisingModel? _fundraisingModel;

  FundraisingModel? get fundraisingModel => _fundraisingModel;
  CurrencyDropDownList _selectedCurrency = CurrencyDropDownList.dollar;
  YesOrNoDropDownList _selectedYesOrNoForDonorNames = YesOrNoDropDownList.yes;
  YesOrNoDropDownList _selectedYesOrNoForDonorAmount = YesOrNoDropDownList.yes;
  GraphicTypeDropDownList _selectedgraphicType =
      GraphicTypeDropDownList.pieChart;

  TextEditingController _fundraisingTitleController = TextEditingController();

  TextEditingController _fundraisingUniqueName = TextEditingController();
  TextEditingController _fundraisingSloganController = TextEditingController();
  TextEditingController _fundraisingGoalController = TextEditingController();
  List<TextEditingController> _communityNameControllers = [];
  List<TextEditingController> _communityGoalControllers = [];
  int _communityCount = 1;

  // Fundraising Unique Name Getter
  TextEditingController get fundraisingUniqueNameText => _fundraisingUniqueName;

// Fundraising Slogan Getter
  TextEditingController get fundraisingSloganText => _fundraisingSloganController;

// Fundraising Goal Getter
  TextEditingController get fundraisingGoalText => _fundraisingGoalController;

// Community Getter (Tüm topluluk adlarını ve hedeflerini liste olarak döndürmek için)
  List<String> get communityNames =>
      _communityNameControllers.map((controller) => controller.text).toList();

  List<double> get communityGoals => _communityGoalControllers
      .map((controller) => double.tryParse(controller.text) ?? 0.0)
      .toList();

  CurrencyDropDownList get selectedCurrency => _selectedCurrency;

  YesOrNoDropDownList get selectedYesOrNoForDonorNames =>
      _selectedYesOrNoForDonorNames;

  YesOrNoDropDownList get selectedYesOrNoForDonorAmount =>
      _selectedYesOrNoForDonorAmount;

  GraphicTypeDropDownList get selectedGraphicType => _selectedgraphicType;

  int get communityCount => _communityCount;

  void initializeFundraising(String userID, String fundraisingID) async {
    var fetchedFundraising =
        await userRepository.getFundraiser(userID, fundraisingID);

    if (fetchedFundraising != null) {
      _fundraisingUniqueName.text = fetchedFundraising.uniqueName.isNotEmpty
          ? fetchedFundraising.uniqueName
          : '';
      _fundraisingSloganController.text =
          fetchedFundraising.slogan.isNotEmpty ? fetchedFundraising.slogan : '';

      _selectedCurrency = CurrencyDropDownList.values.firstWhere(
        (e) => e.label == fetchedFundraising.currency,
        orElse: () => CurrencyDropDownList.dollar,
      );

      _selectedYesOrNoForDonorNames = YesOrNoDropDownList.values.firstWhere(
        (e) => e.label == fetchedFundraising.showDonorNames,
        orElse: () => YesOrNoDropDownList.yes,
      );

      _selectedYesOrNoForDonorAmount = YesOrNoDropDownList.values.firstWhere(
        (e) => e.label == fetchedFundraising.showDonorAmount,
        orElse: () => YesOrNoDropDownList.yes,
      );

      _selectedgraphicType = GraphicTypeDropDownList.values.firstWhere(
        (e) => e.label == fetchedFundraising.graphicType,
        orElse: () => GraphicTypeDropDownList.gaugeChart,
      );
      _communityCount = fetchedFundraising.communities.isNotEmpty
          ? fetchedFundraising.communities.length
          : 1;

      _communityNameControllers.clear();
      _communityGoalControllers.clear();
      for (int i = 0; i < _communityCount; i++) {
        _communityNameControllers.add(TextEditingController(
            text: fetchedFundraising.communities[i].name));

        _communityGoalControllers.add(TextEditingController(
            text: fetchedFundraising.communities[i].goal.toString()));
      }
    }
    notifyListeners();
  }
  void _addCommunityFields() {
    _communityNameControllers.clear();
    _communityGoalControllers.clear();
    for (int i = 0; i < _communityCount; i++) {
      _communityNameControllers.add(TextEditingController());
      _communityGoalControllers.add(TextEditingController());
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _fundraisingTitleController.dispose();
    _fundraisingUniqueName.dispose();
    _fundraisingSloganController.dispose();
    _fundraisingGoalController.dispose();

    for (var controller in _communityNameControllers) {
      controller.dispose();
    }
    for (var controller in _communityGoalControllers) {
      controller.dispose();
    }

    super.dispose();
  }
  void setDropdownValue<T>(T newValue) {
    if (newValue is CurrencyDropDownList) {
      _selectedCurrency = newValue;
    } else if (newValue is YesOrNoDropDownList) {
      if (_selectedYesOrNoForDonorNames.values.contains(newValue)) {
        _selectedYesOrNoForDonorNames = newValue;
      } else {
        _selectedYesOrNoForDonorAmount = newValue;
      }
    } else if (newValue is GraphicTypeDropDownList) {
      _selectedgraphicType = newValue;
    }

    notifyListeners(); // UI'yi güncelle
  }
}
