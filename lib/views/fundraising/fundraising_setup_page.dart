import 'package:another_flushbar/flushbar.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fundraising_goal_chart/core/routes/route_names.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_Text_Form_Field.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_draw_menu.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_drop_down_menu.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_elevated_button.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_text_for_form.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/custom_app_bar.dart';
import 'package:flutter_fundraising_goal_chart/models/fundraising_model.dart';
import 'package:flutter_fundraising_goal_chart/view_models/fundraising_view_models.dart';
import 'package:flutter_fundraising_goal_chart/view_models/user_view_models.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FundraisingSetupPage extends StatefulWidget {
  const FundraisingSetupPage({super.key});

  @override
  State<FundraisingSetupPage> createState() => _FundraisingSetupPageState();
}

class _FundraisingSetupPageState extends State<FundraisingSetupPage> {
  final _formKeyCommunitySetup = GlobalKey<FormState>();

  CurrencyDropDownList _selectedCurrency = CurrencyDropDownList.dollar;
  YesOrNoDropDownList _selectedYesOrNoForDonorNames = YesOrNoDropDownList.yes;
  YesOrNoDropDownList _selectedYesOrNoForDonorAmount = YesOrNoDropDownList.yes;
  GraphicTypeDropDownList _selectedgraphicType =
      GraphicTypeDropDownList.gaugeChart;
  final GlobalKey<ScaffoldState> _scafoldFundraisingSetupPage =
      GlobalKey<ScaffoldState>();

  final TextEditingController _fundraisingTitleController =
      TextEditingController();

  final TextEditingController _fundraisingUniqueName = TextEditingController();
  final TextEditingController _fundraisingSloganController =
      TextEditingController();
  final TextEditingController _fundraisingGoalController =
      TextEditingController();

  int _currentStep = 0;
  int _communityCount = 1;
  List<TextEditingController> _communityNameControllers = [];
  List<TextEditingController> _communityGoalControllers = [];
  String? errorCommunity;

  int activeStep = 0;

  String formatCurrency(double value) {
    var oCcy = NumberFormat("#,##0.00", "en_US");
    return oCcy.format(value);
  }

  TextInputFormatter _currencyFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      String text = newValue.text
          .replaceAll(RegExp(r'[^0-9]'), ''); // Sadece rakamları al

      if (text.isEmpty) {
        return TextEditingValue(
          text: '',
          selection: newValue.selection,
        );
      }

      double doubleValue = double.tryParse(text) ?? 0.0;
      final formatted =
          formatCurrency(doubleValue / 100); // Küçük değerleri düzeltmek için

      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    });
  }

  void _nextStep() {
    if (activeStep < 2) {
      setState(() => activeStep++);
    } else {
      _submitForm();
    }
  }

  void _previousStep() {
    if (activeStep > 0) {
      setState(() => activeStep--);
    }
  }

  @override
  void initState() {
    super.initState();
    _addCommunityFields();
  }

  void _addCommunityFields() {
    _communityNameControllers.clear();
    _communityGoalControllers.clear();
    for (int i = 0; i < _communityCount; i++) {
      _communityNameControllers.add(TextEditingController());
      _communityGoalControllers.add(TextEditingController());
    }
  }

  Future<void> _submitForm() async {
    List<CommunityFundraising> communities = [];
    for (int i = 0; i < _communityCount; i++) {
      String goalText = _communityGoalControllers[i].text.trim();
      communities.add(CommunityFundraising(
        name: _communityNameControllers[i].text,
        goal: double.tryParse(goalText) ?? 0,
      ));
    }
    final UserViewModels userViewModels =
        Provider.of<UserViewModels>(context, listen: false);
    final String userID = userViewModels.userModel!.userID;
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
  }

  void _onCurrencyChanged(CurrencyDropDownList newCurrency) {
    setState(() {
      _selectedCurrency = newCurrency;
    });
  }

  void _onYesOrNoChangedForNamed(YesOrNoDropDownList newValue) {
    setState(() {
      _selectedYesOrNoForDonorNames = newValue;
    });
  }

  void _onYesOrNoChangedForAmount(YesOrNoDropDownList newValue) {
    setState(() {
      _selectedYesOrNoForDonorAmount = newValue;
    });
  }

  void _ongraphicTypeDropDown(GraphicTypeDropDownList newValue) {
    setState(() {
      _selectedgraphicType = newValue;
    });
  }

  @override
  void dispose() {
    _fundraisingTitleController.dispose();
    _fundraisingSloganController.dispose();
    _fundraisingGoalController.dispose();
    _fundraisingUniqueName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldFundraisingSetupPage,
      appBar: CustomAppBar(
        title: 'Fundraising Setup Page',
        scaffoldKey: _scafoldFundraisingSetupPage,
      ),
      drawer: BuildDrawMenu(),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Container(
            width: 600,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Column(
              children: [
                EasyStepper(
                  activeStep: activeStep,
                  lineStyle: LineStyle(
                    lineLength: 60,
                    lineThickness: 4,
                    lineSpace: 5,
                  ),
                  stepShape: StepShape.rRectangle,
                  stepBorderRadius: 15,
                  borderThickness: 2,
                  internalPadding: 10,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  stepRadius: 28,
                  finishedStepBorderColor: Colors.green.shade500,
                  finishedStepBackgroundColor: Colors.green.shade200,
                  activeStepIconColor: Constants.primary,
                  showLoadingAnimation: false,
                  enableStepTapping: true,
                  steps: [
                    EasyStep(
                      customStep: Icon(Icons.info_outline,
                          size: 30,
                          color: activeStep >= 0
                              ? Constants.primary
                              : Colors.grey),
                      customTitle: const Text('General Info',
                          textAlign: TextAlign.center),
                    ),
                    EasyStep(
                      customStep: Icon(Icons.group,
                          size: 30,
                          color: activeStep >= 1
                              ? Constants.primary
                              : Colors.grey),
                      customTitle: const Text('Community Setup',
                          textAlign: TextAlign.center),
                    ),
                    EasyStep(
                      customStep: Icon(Icons.check_circle,
                          size: 30,
                          color: activeStep >= 2
                              ? Constants.primary
                              : Colors.grey),
                      customTitle: const Text('Review & Submit',
                          textAlign: TextAlign.center),
                    ),
                  ],
                ),
                // SizedBox(height: 5),
                _buildStepContent(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (activeStep > 0)
                      BuildElevatedButton(
                          onPressed: _previousStep,
                          buttonText: 'Back',
                          buttonColor: Constants.accent,
                          textColor: Colors.white),
                    BuildElevatedButton(
                        onPressed: _nextStep,
                        buttonText: activeStep < 2 ? "Next" : "Submit",
                        buttonColor: Constants.primary,
                        textColor: Colors.white)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (activeStep) {
      case 0:
        return _buildGeneralInfoStep();
      case 1:
        return _buildCommunitySetupStep();
      case 2:
        return _buildReviewStep();
      default:
        return Container();
    }
  }

  Widget _buildGeneralInfoStep() {
    return SingleChildScrollView(
      child: Column(
        children: [
          //Fetch Fundraising Unique Name From User
          Divider(),
          BuildTextForForm(
            text: 'Please Enter Your Fundraising Unique Name:',
            textColor: Constants.textColor,
            fontSize: 14,
            fontWeight: FontWeight.w100,
          ),
          SizedBox(height: 4),
          BuildTextFormField(
            keyBoardType: TextInputType.text,
            labelText: 'Unique Name',
            hintText: '',
            textFormFieldIcon: Icons.mode_edit_sharp,
            textFormFieldIconColor: Constants.accent,
            outLineInputBorderColor: Constants.accent,
            outLineInputBorderColorOnFocused: Constants.primary,
            textEditingController: _fundraisingUniqueName,
          ),
          SizedBox(height: 15),

          //Fetch Fundraising Slogan From User
          BuildTextForForm(
            text: 'Please Enter Your Fundraising Slogan:',
            textColor: Constants.textColor,
            fontSize: 14,
            fontWeight: FontWeight.w100,
          ),
          SizedBox(height: 4),
          BuildTextFormField(
            keyBoardType: TextInputType.text,
            labelText: 'Fundraising Slogan',
            hintText: '',
            textFormFieldIcon: Icons.mode_edit_sharp,
            textFormFieldIconColor: Constants.accent,
            outLineInputBorderColor: Constants.accent,
            outLineInputBorderColorOnFocused: Constants.primary,
            textEditingController: _fundraisingSloganController,
          ),
          SizedBox(height: 15),

          //Currency
          BuildTextForForm(
            text: 'Which currency would you like to use for your donation?',
            textColor: Constants.textColor,
            fontSize: 14,
            fontWeight: FontWeight.w100,
          ),
          SizedBox(height: 4),
          BuildDropDownMenu(
            initialValue: _selectedCurrency,
            onChanged: _onCurrencyChanged,
            dropdownColor: Constants.background,
            borderColor: Constants.accent,
            focusedBorderColor: Constants.primary,
            iconColor: Constants.accent,
            items: CurrencyDropDownList.values,
            containerWith: double.infinity,
          ),

          // Donor Name
          SizedBox(height: 15),
          BuildTextForForm(
            text:
                'Would you like to show the donor\'s name on the fundraising chart?',
            textColor: Constants.textColor,
            fontSize: 14,
            fontWeight: FontWeight.w100,
          ),
          SizedBox(height: 4),
          BuildDropDownMenu(
            initialValue: _selectedYesOrNoForDonorNames,
            onChanged: _onYesOrNoChangedForNamed,
            dropdownColor: Constants.background,
            borderColor: Constants.accent,
            focusedBorderColor: Constants.primary,
            iconColor: Constants.accent,
            items: YesOrNoDropDownList.values,
            containerWith: double.infinity,
          ),

          // Donor Amount
          SizedBox(height: 15),
          BuildTextForForm(
            text:
                'Would you like to show the donor\'s Amount on the fundraising chart?',
            textColor: Constants.textColor,
            fontSize: 14,
            fontWeight: FontWeight.w100,
          ),
          SizedBox(height: 4),
          BuildDropDownMenu(
            initialValue: _selectedYesOrNoForDonorAmount,
            onChanged: _onYesOrNoChangedForAmount,
            dropdownColor: Constants.background,
            borderColor: Constants.accent,
            focusedBorderColor: Constants.primary,
            iconColor: Constants.accent,
            items: YesOrNoDropDownList.values,
            containerWith: double.infinity,
          ),

          //Chart
          SizedBox(height: 15),
          BuildTextForForm(
            text:
                'Would you like to select a chart type for the Fundraising Goal Chart?',
            textColor: Constants.textColor,
            fontSize: 14,
            fontWeight: FontWeight.w100,
          ),
          SizedBox(height: 4),
          BuildDropDownMenu(
            initialValue: _selectedgraphicType,
            onChanged: _ongraphicTypeDropDown,
            dropdownColor: Constants.background,
            borderColor: Constants.accent,
            focusedBorderColor: Constants.primary,
            iconColor: Constants.accent,
            items: GraphicTypeDropDownList.values,
            containerWith: double.infinity,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCommunitySetupStep() {
    return Column(
      children: [
        Divider(),
        BuildTextForForm(
          text:
              'Will you be doing the fundraising only for yourself or for multiple communities?',
          textColor: Constants.textColor,
          fontSize: 14,
          fontWeight: FontWeight.w100,
        ),
        SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Constants.primary, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _communityCount,
              dropdownColor: Colors.white,
              items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text("$value Communities"),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _communityCount = newValue!;
                  _addCommunityFields();
                });
              },
            ),
          ),
        ),
        Form(
          key: _formKeyCommunitySetup,
          child: Column(
            children: List.generate(_communityCount, (index) {
              return Column(
                children: [
                  SizedBox(height: 20),
                  BuildTextForForm(
                    text: 'Community ${index + 1}',
                    textColor: Constants.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 4),
                  BuildTextFormField(
                    keyBoardType: TextInputType.text,
                    labelText: "Community ${index + 1} Name",
                    textFormFieldIcon: Icons.location_city,
                    textEditingController: _communityNameControllers[index],
                    outLineInputBorderColor: Constants.accent,
                    outLineInputBorderColorOnFocused: Constants.primary,
                    hintText: '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name for Community ${index + 1}'; // Hata mesajı
                      }
                      return null; // Geçerli
                    },
                    errorText: errorCommunity,
                  ),
                  SizedBox(height: 10),
                  BuildTextFormField(
                    keyBoardType:
                        TextInputType.numberWithOptions(decimal: true),
                    labelText: "Community ${index + 1} Goal",
                    textFormFieldIcon: Icons.monetization_on,
                    textEditingController: _communityGoalControllers[index],
                    outLineInputBorderColor: Constants.accent,
                    outLineInputBorderColorOnFocused: Constants.primary,
                    hintText: '',
                    //inputFormatters: [_currencyFormatter()],
                  ),
                ],
              );
            }),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildReviewStep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          BuildTextForForm(
            text: 'Fundraising Name: ${_fundraisingUniqueName.text}',
            textColor: Constants.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w200,
          ),
          BuildTextForForm(
            text: 'Fundraising Slogan: ${_fundraisingSloganController.text}',
            textColor: Constants.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w200,
          ),
          BuildTextForForm(
            text: 'Selected Currency: ${_selectedCurrency.label}',
            textColor: Constants.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w200,
          ),
          BuildTextForForm(
            text: 'Show Donor Names: ${_selectedYesOrNoForDonorNames.label}',
            textColor: Constants.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w200,
          ),
          BuildTextForForm(
            text: 'Fundraising Goal Chart: ${_selectedgraphicType.label}',
            textColor: Constants.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w200,
          ),
        ],
      ),
    );
  }
}

/*
child: Stepper(
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep < 2) {
                  setState(() {
                    _currentStep++;
                  });
                } else {
                  _submitForm();
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep--;
                  });
                }
              },
              onStepTapped: (int step) {
                setState(() {
                  _currentStep = step;
                });
              },
              steps: [
                // Step 1: General Information
                Step(
                  title: Text(
                    'General Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Constants.primary,
                    ),
                  ),
                  content: Column(
                    children: [
                      //Fetch Fundraising Unique Name From User
                      BuildTextForForm(
                        text: 'Please Enter Your Fundraising Unique Name:',
                        textColor: Constants.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w100,
                      ),
                      SizedBox(height: 4),
                      BuildTextFormField(
                        keyBoardType: TextInputType.text,
                        labelText: 'Unique Name',
                        hintText: '2025 Fundraising For Children',
                        textFormFieldIcon: Icons.mode_edit_sharp,
                        textFormFieldIconColor: Constants.accent,
                        outLineInputBorderColor: Constants.accent,
                        outLineInputBorderColorOnFocused: Constants.primary,
                        textEditingController: _fundraisingUniqueName,
                      ),
                      SizedBox(height: 15),

                      //Fetch Fundraising Slogan From User
                      BuildTextForForm(
                        text: 'Please Enter Your Fundraising Slogan:',
                        textColor: Constants.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w100,
                      ),
                      SizedBox(height: 4),
                      BuildTextFormField(
                        keyBoardType: TextInputType.text,
                        labelText: 'Fundraising Slogan',
                        hintText: 'Enter Fundraising Slogan',
                        textFormFieldIcon: Icons.mode_edit_sharp,
                        textFormFieldIconColor: Constants.accent,
                        outLineInputBorderColor: Constants.accent,
                        outLineInputBorderColorOnFocused: Constants.primary,
                        textEditingController: _fundraisingSloganController,
                      ),
                      SizedBox(height: 15),

                      //Currency
                      BuildTextForForm(
                        text:
                            'Which currency would you like to use for your donation?',
                        textColor: Constants.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w100,
                      ),
                      SizedBox(height: 4),
                      BuildDropDownMenu(
                        initialValue: _selectedCurrency,
                        onChanged: _onCurrencyChanged,
                        dropdownColor: Constants.background,
                        borderColor: Constants.accent,
                        focusedBorderColor: Constants.primary,
                        iconColor: Constants.accent,
                        items: CurrencyDropDownList.values,
                      ),

                      // Donor Name
                      SizedBox(height: 15),
                      BuildTextForForm(
                        text:
                            'Would you like to show the donor\'s name on the fundraising chart?',
                        textColor: Constants.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w100,
                      ),
                      SizedBox(height: 4),
                      BuildDropDownMenu(
                        initialValue: _selectedYesOrNoForDonorNames,
                        onChanged: _onYesOrNoChangedForNamed,
                        dropdownColor: Constants.background,
                        borderColor: Constants.accent,
                        focusedBorderColor: Constants.primary,
                        iconColor: Constants.accent,
                        items: YesOrNoDropDownList.values,
                      ),

                      // Donor Amount
                      SizedBox(height: 15),
                      BuildTextForForm(
                        text:
                            'Would you like to show the donor\'s Amount on the fundraising chart?',
                        textColor: Constants.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w100,
                      ),
                      SizedBox(height: 4),
                      BuildDropDownMenu(
                        initialValue: _selectedYesOrNoForDonorAmount,
                        onChanged: _onYesOrNoChangedForAmount,
                        dropdownColor: Constants.background,
                        borderColor: Constants.accent,
                        focusedBorderColor: Constants.primary,
                        iconColor: Constants.accent,
                        items: YesOrNoDropDownList.values,
                      ),

                      //Chart
                      SizedBox(height: 15),
                      BuildTextForForm(
                        text:
                            'Would you like to select a chart type for the Fundraising Goal Chart?',
                        textColor: Constants.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w100,
                      ),
                      SizedBox(height: 4),
                      BuildDropDownMenu(
                        initialValue: _selectedgraphicType,
                        onChanged: _ongraphicTypeDropDown,
                        dropdownColor: Constants.background,
                        borderColor: Constants.accent,
                        focusedBorderColor: Constants.primary,
                        iconColor: Constants.accent,
                        items: GraphicTypeDropDownList.values,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  isActive: _currentStep == 0,
                ),

                // Step 2: Community Setup
                Step(
                  title: Text(
                    'Community Setup',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Constants.primary,
                    ),
                  ),
                  content: Column(
                    children: [
                      BuildTextForForm(
                        text:
                            'Will you be doing the fundraising only for yourself or for multiple communities?',
                        textColor: Constants.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w100,
                      ),
                      SizedBox(height: 4),
                      Container(
                        width: 400,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Constants.primary, width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: _communityCount,
                            dropdownColor: Colors.white,
                            items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                                .map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text("$value Communities"),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _communityCount = newValue!;
                                _addCommunityFields();
                              });
                            },
                          ),
                        ),
                      ),
                      Column(
                        children: List.generate(_communityCount, (index) {
                          return Column(
                            children: [
                              SizedBox(height: 20),
                              BuildTextForForm(
                                text: 'Community ${index + 1}',
                                textColor: Constants.textColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                              SizedBox(height: 4),
                              BuildTextFormField(
                                keyBoardType: TextInputType.text,
                                labelText: "Community ${index + 1} Name",
                                textFormFieldIcon: Icons.location_city,
                                textEditingController:
                                    _communityNameControllers[index],
                                outLineInputBorderColor: Constants.accent,
                                outLineInputBorderColorOnFocused:
                                    Constants.primary,
                                hintText: '',
                              ),
                              SizedBox(height: 10),
                              BuildTextFormField(
                                keyBoardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                labelText: "Community ${index + 1} Goal",
                                textFormFieldIcon: Icons.monetization_on,
                                textEditingController:
                                    _communityGoalControllers[index],
                                outLineInputBorderColor: Constants.accent,
                                outLineInputBorderColorOnFocused:
                                    Constants.primary,
                                hintText: '',
                              ),
                            ],
                          );
                        }),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  isActive: _currentStep == 1,
                ),

                // Step 3: Review & Submit
                Step(
                  title: Text(
                    "Review & Submit",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Constants.primary,
                    ),
                  ),
                  content: Column(
                    children: [
                      BuildTextForForm(
                        text:
                            'Fundraising Title: ${_fundraisingTitleController.text}',
                        textColor: Constants.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                      ),
                      BuildTextForForm(
                        text:
                            'Fundraising Slogan: ${_fundraisingSloganController.text}',
                        textColor: Constants.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                      ),
                      BuildTextForForm(
                        text:
                            'Fundraising Goal: ${_fundraisingGoalController.text}',
                        textColor: Constants.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                      ),
                      BuildTextForForm(
                        text: 'Selected Currency: ${_selectedCurrency.label}',
                        textColor: Constants.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                      ),
                      BuildTextForForm(
                        text:
                            'Show Donor Names: ${_selectedYesOrNoForDonorNames.label}',
                        textColor: Constants.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                      ),
                      BuildTextForForm(
                        text:
                            'Fundraising Goal Chart: ${_selectedgraphicType.label}',
                        textColor: Constants.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.accent,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 40),
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              fontSize: 16,
                              color: Constants.textColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  isActive: _currentStep == 2,
                ),
              ],
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  children: [
                    SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.accent,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(color: Constants.textColor),
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: details.onStepCancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.background,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                      child: Text(
                        'Back',
                        style: TextStyle(color: Constants.accent),
                      ),
                    ),
                  ],
                );
              },
            ),

 */
