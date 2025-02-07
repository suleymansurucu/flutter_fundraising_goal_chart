import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_Text_Form_Field.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_drop_down_menu.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_elevated_button.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_text_for_form.dart';

class FundraisingSetupPage extends StatefulWidget {
  const FundraisingSetupPage({super.key});

  @override
  State<FundraisingSetupPage> createState() => _FundraisingSetupPageState();
}

class _FundraisingSetupPageState extends State<FundraisingSetupPage> {
  CurrencyDropDownList _selectedCurrency = CurrencyDropDownList.dollar;
  YesOrNoDropDownList _selectedYesOrNo = YesOrNoDropDownList.yes;
  GraphicTypeDropDownList _selectedgraphicType=GraphicTypeDropDownList.progressBar;
  final TextEditingController _fundraisingTitleController =
      TextEditingController();
  final TextEditingController _fundraisingSloganController =
      TextEditingController();
  final TextEditingController _fundraisingGoalController =
      TextEditingController();

  void _onCurrencyChanged(CurrencyDropDownList newCurrency) {
    setState(() {
      _selectedCurrency = newCurrency;
    });
  }

  void _onYesOrNoChanged(YesOrNoDropDownList newValue) {
    setState(() {
      _selectedYesOrNo = newValue;
    });
  }
  void _ongraphicTypeDropDown(GraphicTypeDropDownList newValue) {
    setState(() {
      _selectedgraphicType = newValue;
    });
  }

  @override
  void dispose() {
    // Clean textEdittingController For Memory Management
    _fundraisingTitleController.dispose();
    _fundraisingSloganController.dispose();
    _fundraisingGoalController.dispose();
    super.dispose();
  }

  void _submitForm() {
    //Write to the console from user input.
    print("Fundraising Title: ${_fundraisingTitleController.text}");
    print("Fundraising Slogan: ${_fundraisingSloganController.text}");
    print("Fundraising Goal Amount: ${_fundraisingGoalController.text}");
    print("Selected Currency: ${_selectedCurrency.label}");
    print("Show Donor Names: ${_selectedYesOrNo.label}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Container(
            width: 400,
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
                ),
              ],
            ),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    child: Text(
                      "Create Your Fundraising Display Chart Screen",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Constants.textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  BuildTextForForm(
                      text: 'Please Enter Your Fundraising Name:',
                      textColor: Constants.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w100),
                  SizedBox(
                    height: 4,
                  ),
                  BuildTextFormField(
                      keyBoardType: TextInputType.text,
                      labelText: 'Fundraising Title',
                      hintText: 'Enter Fundraising Title Name',
                      textFormFieldIcon: Icons.title,
                      textFormFieldIconColor: Constants.accent,
                      outLineInputBorderColor: Constants.accent,
                      outLineInputBorderColorOnFocused: Constants.primary,
                      textEditingController: _fundraisingTitleController),
                  SizedBox(height: 15),
                  BuildTextForForm(
                      text: 'Please Enter Your Fundraising Slogan:',
                      textColor: Constants.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w100),
                  SizedBox(
                    height: 4,
                  ),
                  BuildTextFormField(
                      keyBoardType: TextInputType.text,
                      labelText: 'Fundraising Slogan',
                      hintText: 'Enter Fundraising Slogan',
                      textFormFieldIcon: Icons.mode_edit_sharp,
                      textFormFieldIconColor: Constants.accent,
                      outLineInputBorderColor: Constants.accent,
                      outLineInputBorderColorOnFocused: Constants.primary,
                      textEditingController: _fundraisingSloganController),
                  SizedBox(height: 15),
                  BuildTextForForm(
                      text: 'Please Enter Your Fundraising Goal Amount:',
                      textColor: Constants.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w100),
                  SizedBox(
                    height: 4,
                  ),
                  BuildTextFormField(
                      keyBoardType: TextInputType.number,
                      labelText: 'Goal Amount',
                      hintText: 'Enter Fundraising Goal Amount',
                      textFormFieldIcon: Icons.double_arrow,
                      textFormFieldIconColor: Constants.accent,
                      outLineInputBorderColor: Constants.accent,
                      outLineInputBorderColorOnFocused: Constants.primary,
                      textEditingController: _fundraisingGoalController),
                  SizedBox(height: 15),
                  BuildTextForForm(
                      text:
                          'Which currency would you like to use for your donation',
                      textColor: Constants.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w100),
                  SizedBox(
                    height: 4,
                  ),
                  BuildDropDownMenu(
                      initialValue: _selectedCurrency,
                      onChanged: _onCurrencyChanged,
                      dropdownColor: Constants.background,
                      borderColor: Constants.accent,
                      focusedBorderColor: Constants.primary,
                      iconColor: Constants.accent,
                      items: CurrencyDropDownList.values),
                  SizedBox(height: 15),
                  BuildTextForForm(
                      text:
                          'Would you like to show the donors name on the fundraising chart?',
                      textColor: Constants.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w100),
                  SizedBox(
                    height: 4,
                  ),
                  BuildDropDownMenu(
                      initialValue: _selectedYesOrNo,
                      onChanged: _onYesOrNoChanged,
                      dropdownColor: Constants.background,
                      borderColor: Constants.accent,
                      focusedBorderColor: Constants.primary,
                      iconColor: Constants.accent,
                      items: YesOrNoDropDownList.values),
                  SizedBox(height: 15),
                  BuildTextForForm(
                      text:
                      'Would you like to select a chart type for the Fundraising Goal Chart?',
                      textColor: Constants.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w100),
                  SizedBox(
                    height: 4,
                  ),
                  BuildDropDownMenu(
                      initialValue: _selectedgraphicType,
                      onChanged: _ongraphicTypeDropDown,
                      dropdownColor: Constants.background,
                      borderColor: Constants.accent,
                      focusedBorderColor: Constants.primary,
                      iconColor: Constants.accent,
                      items: GraphicTypeDropDownList.values),
                  SizedBox(height: 20),
                  BuildElevatedButton(
                    onPressed: _submitForm,
                    buttonText: "Create",
                    buttonColor: Constants.accent,
                    textColor: Colors.white,
                    borderRadius: 15,
                    paddingHorizontal: 50,
                    paddingVertical: 20,
                    iconColor: Colors.white,
                    hasShadow: true,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
