import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_Text_Form_Field.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_elevated_button.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_text_for_form.dart';
import 'package:flutter_fundraising_goal_chart/view_models/fundraising_view_models.dart';
import 'package:flutter_fundraising_goal_chart/view_models/user_view_models.dart';
import 'package:provider/provider.dart';

class DonationEntryPage extends StatefulWidget {
  const DonationEntryPage({super.key});

  @override
  State<DonationEntryPage> createState() => _DonationEntryPageState();
}

class _DonationEntryPageState extends State<DonationEntryPage> {
  List<String> list = [];
  String? thisFundraising;
  String? FundraisingID;
  late final String userID;

  // 🔹 Text Controllers
  final TextEditingController _donationAmountController =
      TextEditingController();
  final TextEditingController _donorNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

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
      setState(() {
        FundraisingID = result;
      });
    }
  }

  // 🔹 Function to update dropdown selection
  void _onFundraising(String value) async {
    // Asenkron işlemi burada yapıyoruz
    thisFundraising = value;
    final fundraisingViewModels =
        Provider.of<FundraisingViewModels>(context, listen: false);
    var result = await fundraisingViewModels.getFundraisingIDByCommunityName(
        userID, thisFundraising!);
    debugPrint('Bakalim olacak mi $result');

    // Sonuç alındıktan sonra UI'yi güncelliyoruz
    setState(() {
      FundraisingID = result;
    });
  }

  // 🔹 Submit Form
  void _submitForm() {
    print('Selected Fundraising: $thisFundraising');
    print('Donor Name: ${_donorNameController.text}');
    print('Donation Amount: ${_donationAmountController.text}');

    double? donationAmount = double.tryParse(_donationAmountController.text);

    final fundraisingViewModels =
        Provider.of<FundraisingViewModels>(context, listen: false);
    fundraisingViewModels.userRepository.saveDonation(userID, FundraisingID!,
        thisFundraising!, _donorNameController.text, donationAmount!);
  }

  @override
  void dispose() {
    _donationAmountController.dispose();
    _donorNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background,
      body: Center(
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
            child: Form(
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 400,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Constants.primary, width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: Constants.background,
                          value: thisFundraising,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              _onFundraising(newValue);
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
                  const SizedBox(height: 20),
                  BuildTextForForm(
                      text: 'Please Enter Your Donor\'s Name:',
                      textColor: Constants.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w100),
                  const SizedBox(height: 4),
                  BuildTextFormField(
                      keyBoardType: TextInputType.text,
                      labelText: 'Donor\'s Name',
                      hintText: 'Enter Donor Name',
                      textFormFieldIcon: Icons.title,
                      textFormFieldIconColor: Constants.accent,
                      outLineInputBorderColor: Constants.accent,
                      outLineInputBorderColorOnFocused: Constants.primary,
                      textEditingController: _donorNameController),
                  const SizedBox(height: 15),
                  BuildTextForForm(
                      text: 'Please Enter Donation Amount:',
                      textColor: Constants.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w100),
                  const SizedBox(height: 4),
                  BuildTextFormField(
                      keyBoardType: TextInputType.number,
                      labelText: 'Donation Amount',
                      hintText: 'Enter Donation Amount',
                      textFormFieldIcon: Icons.mode_edit_sharp,
                      textFormFieldIconColor: Constants.accent,
                      outLineInputBorderColor: Constants.accent,
                      outLineInputBorderColorOnFocused: Constants.primary,
                      textEditingController: _donationAmountController),
                  const SizedBox(height: 20),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
