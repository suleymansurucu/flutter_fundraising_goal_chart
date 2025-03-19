import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_Text_Form_Field.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_draw_menu.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_elevated_button.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_text_for_form.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/custom_app_bar.dart';
import 'package:flutter_fundraising_goal_chart/models/donation_model.dart';
import 'package:flutter_fundraising_goal_chart/view_models/donation_view_models.dart';
import 'package:flutter_fundraising_goal_chart/view_models/fundraising_view_models.dart';
import 'package:flutter_fundraising_goal_chart/view_models/user_view_models.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class DonationEntryPage extends StatefulWidget {
  const DonationEntryPage({super.key});

  @override
  State<DonationEntryPage> createState() => _DonationEntryPageState();
}

class _DonationEntryPageState extends State<DonationEntryPage> {
  final _formKeyForDonationEntry = GlobalKey<ScaffoldState>();

  List<String> list = [];
  String? thisFundraising;
  String? FundraisingID;
  late final String userID;

  // 🔹 Text Controllers
  final TextEditingController _donationAmountController =
      TextEditingController();
  final TextEditingController _donorNameController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchDataFromViewModes();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void fetchDataFromViewModes() async {
    final fundraisingViewModels =
        Provider.of<FundraisingViewModels>(context, listen: false);
    await fundraisingViewModels.fetchData();
    Future.delayed(Duration(milliseconds: 400));
    FundraisingID = fundraisingViewModels.fundraisingID;
    thisFundraising = fundraisingViewModels.thisFundraising;
    list = fundraisingViewModels.list ?? ['Create Fundraising'];
    final userViewModels = Provider.of<UserViewModels>(context, listen: false);
    userID = userViewModels.userModel!.userID;
  }

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

  // The function is fetch data from firebase // I am using provider state management why I do not need the function
/*
  void fetchData() async {
    final fundraisingViewModels =
        Provider.of<FundraisingViewModels>(context, listen: false);
    final userViewModels = Provider.of<UserViewModels>(context, listen: false);
    userID = userViewModels.userModel!.userID;

    List<String>? fetchedList = await fundraisingViewModels
        .fetchFundraisingCommunity(userID) as List<String>;

    if (fetchedList != null && fetchedList.isNotEmpty) {
      setState(() {
        list = fetchedList;
        thisFundraising = list[0]; // Default selection
      });

      fundraisingViewModels.fetchFundraising(userID);
      var result = await fundraisingViewModels.getFundraisingIDByCommunityName(
          userID, thisFundraising!);

      // Update the state with the fundraising ID
      FundraisingID = result;
    }
  }
*/

  // 🔹 Function to update dropdown selection => When I used Provider in FundraisingViewModel, I do not need this function
/*  void _onFundraising(String value) async {
    thisFundraising = value;
    final fundraisingViewModels =
        Provider.of<FundraisingViewModels>(context, listen: false);
    var result = await fundraisingViewModels.getFundraisingIDByCommunityName(
        userID, thisFundraising!);
    FundraisingID = result;
  }*/

  // 🔹 Submit Form
  Future<void> _submitForm() async {
    double? donationAmount = NumberFormat.decimalPattern('en_US')
        .parse(_donationAmountController.text)
        .toDouble();

    final donationViewModels =
        Provider.of<DonationViewModels>(context, listen: false);
    final fundraisingViewModels =
        Provider.of<FundraisingViewModels>(context, listen: false);
    bool validation = donationViewModels.validateForm(
        _donorNameController, _donorNameController);
    String donationID = Uuid().v4();
    if (validation) {
      DonationModel donationModel = DonationModel(
          donationID: donationID,
          communityName: fundraisingViewModels.thisFundraising!,
          donationAmount: donationAmount!,
          donorName: _donorNameController.text,
          fundraisingID: fundraisingViewModels.fundraisingID!,
          userID: userID,
          timestamp: Timestamp.now());
      try {
        Future.delayed(Duration(milliseconds: 400));
        donationViewModels.addDonation(donationModel);
        await Flushbar(
          title: 'You have added donation',
          message:
              '${_donorNameController.text.toString()} : \$ ${_donationAmountController.text.toString()}',
          duration: Duration(seconds: 1),
          titleColor: Constants.background,
          messageColor: Constants.background,
          backgroundColor: Constants.primary,
          maxWidth: 600,
          titleSize: 32,
          messageSize: 32,
          showProgressIndicator: true,
          flushbarPosition: FlushbarPosition.TOP,
          margin: EdgeInsets.all(20),
        ).show(context);
        _donorNameController.clear();
        _donationAmountController.clear();
      } catch (e) {
        debugPrint('Donation Entry Donate Submit${e.toString()}');
      }
    } else {
      _formkey.currentState!.reset();
      _donorNameController.clear();
      _donationAmountController.clear();
    }
    /*final fundraisingViewModels =
        Provider.of<FundraisingViewModels>(context, listen: false);
    fundraisingViewModels.userRepository.saveDonation(userID, FundraisingID!,
        thisFundraising!, _donorNameController.text, donationAmount!);*/
  }

  @override
  void dispose() {
    _donationAmountController.dispose();
    _donorNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      print("🔄 Sayfa build ediliyor...");

      return Scaffold(
        key: _formKeyForDonationEntry,
        appBar: CustomAppBar(
          title: 'Submit Donation',
          scaffoldKey: _formKeyForDonationEntry,
        ),
        drawer: BuildDrawMenu(),
        body: Center(
          child: Container(
            // Flexible'ı kaldır
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background2.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Image.asset(
                    'assets/images/entry-donations.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      width: 400,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child:
                          Consumer2<FundraisingViewModels, DonationViewModels>(
                        builder: (context, fundraisingViewModels,
                            donationViewModels, widget) {
                          if (fundraisingViewModels.isLoading) {
                            return CircularProgressIndicator();
                          }
                          if (fundraisingViewModels.list!.isEmpty) {
                            return Text('No fundraising events found',
                                style: TextStyle(color: Colors.red));
                          }
                          return Form(
                            key: _formkey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: BuildTextForForm(
                                      text: 'Select a Fundraising Event:',
                                      textColor: Constants.textColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w100),
                                ),
                                const SizedBox(height: 4),
                                if (list.isEmpty)
                                  Text('No fundraising events found',
                                      style: TextStyle(color: Colors.red)),
                                Container(
                                  width: 400,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Constants.primary, width: 1.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      dropdownColor: Constants.background,
                                      value:
                                          fundraisingViewModels.thisFundraising,
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          fundraisingViewModels
                                              .onFundraising(newValue);
                                        }
                                      },
                                      isExpanded: true,
                                      items: list.map((String item) {
                                        return DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(item),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Align(
                                  child: Text(
                                    "Enter Your Donation",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Constants.textColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Divider(),
                                const SizedBox(height: 20),
                                BuildTextForForm(
                                    text: 'Please Enter Donor Full Name:',
                                    textColor: Constants.textColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w100),
                                SizedBox(height: 4),
                                BuildTextFormField(
                                    textEditingController: _donorNameController,
                                    textFormFieldIcon: Icons.person,
                                    textFormFieldIconColor: Constants.primary,
                                    keyBoardType: TextInputType.text,
                                    hintText: 'Donor Name',
                                    errorText: donationViewModels.donorNameError,
                                    outLineInputBorderColor: Constants.accent,
                                    outLineInputBorderColorOnFocused:
                                        Constants.primary),
                                SizedBox(height: 20),
                                BuildTextForForm(
                                    text: 'Please Enter Donation Amount:',
                                    textColor: Constants.textColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w100),
                                SizedBox(height: 4),
                                BuildTextFormField(
                                  textEditingController:
                                      _donationAmountController,
                                  textFormFieldIcon: Icons.person,
                                  textFormFieldIconColor: Constants.primary,
                                  keyBoardType: TextInputType.number,
                                  hintText: 'Donation Amount',
                                  errorText: donationViewModels.donorAmountError,
                                  outLineInputBorderColor: Constants.accent,
                                  outLineInputBorderColorOnFocused:
                                      Constants.primary,
                                  inputFormatters: [_currencyFormatter()],
                                ),
                                SizedBox(height: 20),
                                BuildElevatedButton(
                                  onPressed: () {
                                    try {
                                      _submitForm();
                                    } catch (e, stackTrace) {
                                      print("🚨 Hata: $e");
                                      print(stackTrace);
                                    }
                                  },
                                  buttonText: "Submit Donation",
                                  buttonColor: Constants.accent,
                                  textColor: Colors.white,
                                  borderRadius: 15,
                                  paddingHorizontal: 50,
                                  paddingVertical: 20,
                                  iconColor: Colors.white,
                                  hasShadow: true,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e, stackTrace) {
      print("❌ Build sırasında hata oluştu: $e");
      print("🔍 Stack Trace: $stackTrace");
      return Center(child: Text("❌ Sayfa yüklenirken hata oluştu: $e"));
    }
  }
}
