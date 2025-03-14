import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/routes/route_names.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_drop_down_menu.dart';
import 'package:flutter_fundraising_goal_chart/locator.dart';
import 'package:flutter_fundraising_goal_chart/models/fundraising_model.dart';
import 'package:flutter_fundraising_goal_chart/services/user_repository.dart';
import 'package:flutter_fundraising_goal_chart/view_models/fundraising_view_models.dart';
import 'package:flutter_fundraising_goal_chart/view_models/user_view_models.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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
  TextEditingController get fundraisingSloganText =>
      _fundraisingSloganController;

// Fundraising Goal Getter
  TextEditingController get fundraisingGoalText => _fundraisingGoalController;

// Community Getter (Tüm topluluk adlarını ve hedeflerini liste olarak döndürmek için)
  List<TextEditingController> get communityNames => _communityNameControllers;

  List<TextEditingController> get communityGoals => _communityGoalControllers;

  CurrencyDropDownList get selectedCurrency => _selectedCurrency;

  YesOrNoDropDownList get selectedYesOrNoForDonorNames =>
      _selectedYesOrNoForDonorNames;

  YesOrNoDropDownList get selectedYesOrNoForDonorAmount =>
      _selectedYesOrNoForDonorAmount;

  GraphicTypeDropDownList get selectedGraphicType => _selectedgraphicType;

  int get communityCount => _communityCount;

  int _activeStep = 0; // Using variable for easyStepper next or back

  int get activeStep => _activeStep;
  late FundraisingModel _firstFundraising;

  void initializeFundraising(String userID, String fundraisingID) async {
    var fetchedFundraising =
        await userRepository.getFundraiser(userID, fundraisingID);
    _firstFundraising = fetchedFundraising!;

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

  void addCommunityFields() {
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
    } else if (newValue is GraphicTypeDropDownList) {
      _selectedgraphicType = newValue;
    }
    notifyListeners();
  }

  void setDropDownValueDonorNames<T>(T newValue) {
    _selectedYesOrNoForDonorNames = newValue as YesOrNoDropDownList;
    notifyListeners();
  }

  void setDropDownValueDonorAmounts(YesOrNoDropDownList newValue) {
    _selectedYesOrNoForDonorAmount = newValue;
    notifyListeners();
  }

  void setDropDownCommunityCounts(int? newValue) {
    _communityCount = newValue ?? 1;
    addCommunityFields();
    notifyListeners();
  }

  void updateSubmitStep(
      String userID, String fundraisingID, BuildContext context) async {
    Map<String, dynamic> updatedFields = {};

    // Check changed fields of user profile
    void addIfChanged(String key, String newValue, String? oldValue) {
      if (newValue.isNotEmpty && newValue != oldValue) {
        updatedFields[key] = newValue;
      }
    }

    // Check textEditting Controller
    addIfChanged("uniqueName", _fundraisingUniqueName.text,
        _firstFundraising.uniqueName);
    addIfChanged("showDonorNames", _selectedYesOrNoForDonorNames.label,
        _firstFundraising.showDonorNames);
    addIfChanged("showDonorAmount", _selectedYesOrNoForDonorAmount.label,
        _firstFundraising.showDonorAmount);
    addIfChanged("goalChartType", _selectedgraphicType.label,
        _firstFundraising.graphicType);
    addIfChanged("fundraisingSlogan", _fundraisingSloganController.text,
        _firstFundraising.slogan);
    addIfChanged(
        "currency", _selectedCurrency.label, _firstFundraising.currency);

    // `communities` için güncellenmiş alanları saklamak için bir liste oluştur
    List<Map<String, dynamic>> updatedCommunities = [];

// `communities` için değişiklikleri kontrol et
    for (int i = 0; i < communityCount; i++) {
      updatedCommunities.add({
        'communityName': _communityNameControllers[i].text,
        'communityGoal': double.tryParse(_communityGoalControllers[i].text)
      });
    }

// Eğer topluluklar değiştiyse `updatedFields` içine ekle
    if (updatedCommunities.isNotEmpty) {
      updatedFields['communities'] = updatedCommunities;
    }
    try {
      var result = await userRepository.updateFundraising(
          userID, fundraisingID, updatedFields);

      result == true
          ? await Flushbar(
              title: 'You have updated fundraising display page',
              message:
                  'You are forwarding a list of your fundraising. You can find this page on your display page.',
              duration: Duration(seconds: 3),
              titleColor: Constants.background,
              messageColor: Constants.background,
              backgroundColor: Constants.primary,
              maxWidth: 600,
              titleSize: 32,
              messageSize: 22,
              showProgressIndicator: true,
              flushbarPosition: FlushbarPosition.TOP,
              margin: EdgeInsets.all(20),
            ).show(context)
          : await Flushbar(
              title: 'You do not have updated fundraising display page',
              message: 'Please enter your information.',
              duration: Duration(seconds: 3),
              titleColor: Constants.background,
              messageColor: Constants.background,
              backgroundColor: Constants.primary,
              maxWidth: 600,
              titleSize: 32,
              messageSize: 22,
              showProgressIndicator: true,
              flushbarPosition: FlushbarPosition.TOP,
              margin: EdgeInsets.all(20),
            ).show(context);

      result == true
          ? context.go(RouteNames.allFundraisingShowList)
          : SizedBox();
    } catch (e) {
      debugPrint(e.toString());
    }
    _activeStep = 0;
    notifyListeners();
  }

  void nextStep() {
    if (_activeStep < 2) {
      _activeStep++;
    } else {
      // _submitForm();
    }
    notifyListeners();
  }

  void previousStep() {
    if (_activeStep > 0) {
      _activeStep--;
    }
    notifyListeners();
  }

  Future<void> submitForm(String userID, BuildContext context) async {
    List<CommunityFundraising> communities = [];
    for (int i = 0; i < _communityCount; i++) {
      String goalText = _communityGoalControllers[i].text.trim();
      communities.add(CommunityFundraising(
        name: _communityNameControllers[i].text,
        goal: double.tryParse(goalText) ?? 0,
      ));
    }

    String fundraisingID = Uuid().v4();

    Map<String, dynamic> createFundraising = {
      'fundraisingID': Uuid().v4(),
      'userID': userID,
      'fundraisingID': fundraisingID,
      'uniqueName': _fundraisingUniqueName.text,
      'fundraisingSlogan': _fundraisingSloganController.text,
      'currency': _selectedCurrency.label,
      'showDonorNames': _selectedYesOrNoForDonorNames.label,
      'showDonorAmount': _selectedYesOrNoForDonorAmount.label,
      'goalChartType': _selectedgraphicType.label,
      'communities': communities.map((community) {
        return {
          'communityName': community.name,
          'communityGoal': community.goal,
        };
      }).toList(),
    };

    final FundraisingViewModels fundraisingViewModels =
        Provider.of<FundraisingViewModels>(context, listen: false);
    var resul = await fundraisingViewModels.createFundraising(
        createFundraising, fundraisingID, userID);
    if (resul) {
      await Flushbar(
        title: 'You have created fundraising display page',
        message:
            'You are forwarding a list of your fundraising. You can find this page on your display page.',
        duration: Duration(seconds: 3),
        titleColor: Constants.background,
        messageColor: Constants.background,
        backgroundColor: Constants.primary,
        maxWidth: 600,
        titleSize: 32,
        messageSize: 22,
        showProgressIndicator: true,
        flushbarPosition: FlushbarPosition.TOP,
        margin: EdgeInsets.all(20),
      ).show(context);
      context.go(RouteNames.allFundraisingShowList);
    } else {
      await Flushbar(
        title: 'You do not have created fundraising display page',
        message: 'Please enter your information.',
        duration: Duration(seconds: 3),
        titleColor: Constants.background,
        messageColor: Constants.background,
        backgroundColor: Constants.primary,
        maxWidth: 600,
        titleSize: 32,
        messageSize: 22,
        showProgressIndicator: true,
        flushbarPosition: FlushbarPosition.TOP,
        margin: EdgeInsets.all(20),
      ).show(context);
    }
    _activeStep = 0;
    notifyListeners();
  }
}
