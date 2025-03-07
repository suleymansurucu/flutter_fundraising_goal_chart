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
import 'package:flutter_fundraising_goal_chart/view_models/fundraising_page_view_models.dart';
import 'package:flutter_fundraising_goal_chart/view_models/fundraising_view_models.dart';
import 'package:flutter_fundraising_goal_chart/view_models/user_view_models.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UpdateFundraisingPage extends StatefulWidget {
  final String fundraisingID;
  final String userID;

  const UpdateFundraisingPage({required this.userID,required this.fundraisingID, super.key});

  @override
  State<UpdateFundraisingPage> createState() => _UpdateFundraisingPageState();
}

class _UpdateFundraisingPageState extends State<UpdateFundraisingPage> {
  final _formKeyCommunitySetup = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scafoldFundraisingSetupPage =
      GlobalKey<ScaffoldState>();

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
     // _submitForm();
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
    FundraisingPageViewModels fundraisingPageViewModels=Provider.of<FundraisingPageViewModels>(context,listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fundraisingPageViewModels.initializeFundraising(widget.userID, widget.fundraisingID);
    });
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
    FundraisingPageViewModels fundraisingPageViewModels=Provider.of<FundraisingPageViewModels>(context);


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
            textEditingController: fundraisingPageViewModels.fundraisingUniqueNameText,
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
            textEditingController: fundraisingPageViewModels.fundraisingSloganText,
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
            initialValue: fundraisingPageViewModels.selectedCurrency,
            onChanged:  ,
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
