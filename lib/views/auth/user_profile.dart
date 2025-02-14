import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_Text_Form_Field.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_draw_menu.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_elevated_button.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_text_for_form.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/custom_app_bar.dart';
import 'package:flutter_fundraising_goal_chart/view_models/user_view_models.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserData();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _communityNameController =
      TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldUserProfileKey =
      GlobalKey<ScaffoldState>();

  late String email,
      fullName,
      communityName,
      addressLine1,
      city,
      state,
      zipCode;


  @override
  Widget build(BuildContext context) {
    final UserViewModels userViewModels =
        Provider.of<UserViewModels>(context, listen: false);
    return Scaffold(
            key: _scaffoldUserProfileKey,
            appBar: CustomAppBar(
              title: 'Edit Profile Page',
              scaffoldKey: _scaffoldUserProfileKey,
            ),
            drawer: BuildDrawMenu(),
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
                  child: Consumer<UserViewModels>(
                      builder: (context, userViewModels, child) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20),
                          Align(
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Constants.textColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 20),

                          // CommunityName
                          BuildTextForForm(
                              text: 'Please Enter Your Community Name:',
                              textColor: Constants.textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w100),
                          SizedBox(height: 4),
                          BuildTextFormField(
                            keyBoardType: TextInputType.visiblePassword,
                            labelText: 'Community Name',
                            hintText: 'Enter Community Name',
                            textFormFieldIcon: Icons.home,
                            textFormFieldIconColor: Constants.accent,
                            outLineInputBorderColor: Constants.accent,
                            outLineInputBorderColorOnFocused: Constants.primary,
                            textEditingController: _communityNameController,
                            errorText: userViewModels.confirmPasswordError,
                            onSaved: (value) {
                              communityName = value!;
                            },
                          ),

                          //Community Address Line
                          BuildTextForForm(
                              text: 'Please Enter Your Community Address:',
                              textColor: Constants.textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w100),
                          SizedBox(height: 4),
                          BuildTextFormField(
                            keyBoardType: TextInputType.text,
                            labelText: 'Address',
                            hintText: '123 Paterson Ave.',
                            textFormFieldIcon: Icons.location_on_rounded,
                            textFormFieldIconColor: Constants.accent,
                            outLineInputBorderColor: Constants.accent,
                            outLineInputBorderColorOnFocused: Constants.primary,
                            textEditingController: _addressLine1Controller,
                            errorText: userViewModels.addressLine1Error,
                            onSaved: (value) {
                              addressLine1 = value!;
                              debugPrint('Widget $addressLine1');
                            },
                          ),
                          SizedBox(height: 15),

                          // Community City
                          BuildTextForForm(
                              text: 'Please Enter Your Community City:',
                              textColor: Constants.textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w100),
                          SizedBox(height: 4),
                          BuildTextFormField(
                            keyBoardType: TextInputType.text,
                            labelText: 'City',
                            hintText: 'Brooklyn',
                            textFormFieldIcon: Icons.location_city_outlined,
                            textFormFieldIconColor: Constants.accent,
                            outLineInputBorderColor: Constants.accent,
                            outLineInputBorderColorOnFocused: Constants.primary,
                            textEditingController: _cityController,
                            errorText: userViewModels.cityError,
                            onSaved: (value) {
                              city = value!;
                              debugPrint('Widget $city');
                            },
                          ),
                          SizedBox(height: 15),

                          //Community State
                          BuildTextForForm(
                              text: 'Please Enter Your Community State:',
                              textColor: Constants.textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w100),
                          SizedBox(height: 4),
                          BuildTextFormField(
                            keyBoardType: TextInputType.text,
                            labelText: 'State',
                            hintText: 'New York',
                            textFormFieldIcon: Icons.location_on_rounded,
                            textFormFieldIconColor: Constants.accent,
                            outLineInputBorderColor: Constants.accent,
                            outLineInputBorderColorOnFocused: Constants.primary,
                            textEditingController: _stateController,
                            errorText: userViewModels.stateError,
                            onSaved: (value) {
                              state = value!;
                              debugPrint('Widget $fullName');
                            },
                          ),
                          SizedBox(height: 15),

                          //Community zipCode
                          BuildTextForForm(
                              text: 'Please Enter Your Community Zip Code:',
                              textColor: Constants.textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w100),
                          SizedBox(height: 4),
                          BuildTextFormField(
                            keyBoardType: TextInputType.text,
                            labelText: 'Zip Code',
                            hintText: '11223',
                            textFormFieldIcon: Icons.code,
                            textFormFieldIconColor: Constants.accent,
                            outLineInputBorderColor: Constants.accent,
                            outLineInputBorderColorOnFocused: Constants.primary,
                            textEditingController: _zipCodeController,
                            errorText: userViewModels.zipCodeError,
                            onSaved: (value) {
                              zipCode = value!;
                              debugPrint('Widget $zipCode');
                            },
                          ),
                          SizedBox(height: 15),

                          //Email
                          BuildTextForForm(
                              text: 'Please Enter Your Email Address:',
                              textColor: Constants.textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w100),
                          SizedBox(height: 4),
                          BuildTextFormField(
                            keyBoardType: TextInputType.emailAddress,
                            labelText: 'Email',
                            hintText: 'Enter Email Address',
                            textFormFieldIcon: Icons.email,
                            textFormFieldIconColor: Constants.accent,
                            outLineInputBorderColor: Constants.accent,
                            outLineInputBorderColorOnFocused: Constants.primary,
                            textEditingController: _emailController,
                            errorText: userViewModels.emailError,
                            onSaved: (value) {
                              email = value!;
                            },
                          ),
                          SizedBox(height: 15),
                          //Email
                          BuildTextForForm(
                              text: 'Please Enter Your Full Name:',
                              textColor: Constants.textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w100),
                          SizedBox(height: 4),
                          BuildTextFormField(
                            keyBoardType: TextInputType.emailAddress,
                            labelText: 'Full Name',
                            hintText: 'Enter Full Name',
                            textFormFieldIcon: Icons.edit,
                            textFormFieldIconColor: Constants.accent,
                            outLineInputBorderColor: Constants.accent,
                            outLineInputBorderColorOnFocused: Constants.primary,
                            textEditingController: _fullNameController,
                            errorText: userViewModels.userNameError,
                            onSaved: (value) {
                              fullName = value!;
                            },
                          ),
                          SizedBox(height: 20),
                          BuildElevatedButton(
                            onPressed: _editProfile,
                            buttonText: "Edit Your Profile",
                            buttonColor: Constants.accent,
                            textColor: Colors.white,
                            borderRadius: 15,
                            paddingHorizontal: 50,
                            paddingVertical: 20,
                            iconColor: Colors.white,
                            hasShadow: true,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Opacity(
                            opacity: 0.64,
                            child: TextButton(
                              onPressed: () {
                                _changeThePassword();
                              },
                              child: Text.rich(
                                const TextSpan(
                                  text: "Change the Your Password ",
                                  style: TextStyle(color: Constants.primary),
                                  children: [
                                    TextSpan(
                                      text: "Click It !",
                                      style: TextStyle(
                                          color: Constants.accent,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          );
  }

  Future<void> _editProfile() async {
    final UserViewModels userViewModels =
    Provider.of<UserViewModels>(context, listen: false);
    final String userID = userViewModels.userModel!.userID;
    Map<String,dynamic> updatedFields ={};

    // Check changed fields of user profile
    void addIfChanged(String key, String newValue, String? oldValue) {
      if (newValue.isNotEmpty && newValue != oldValue) {
        updatedFields[key] = newValue;
      }
    }

    // Check textEditting Controller
    addIfChanged("email", _emailController.text, userViewModels.userModel?.email);
    addIfChanged("communityName", _communityNameController.text, userViewModels.userModel?.communityName);
    addIfChanged("city", _cityController.text, userViewModels.userModel?.city);
    addIfChanged("state", _stateController.text, userViewModels.userModel?.state);
    addIfChanged("zipCode", _zipCodeController.text, userViewModels.userModel?.zipCode);
    addIfChanged("addressLine1", _addressLine1Controller.text, userViewModels.userModel?.addressLine1);

    // if updated fields in form you can updated
    if (updatedFields.isNotEmpty) {
      bool? result = await userViewModels.updateUserProfile(userID, updatedFields);
      if (result == true) {
        debugPrint('true gorduk');
      }  else {
        debugPrint('false gorduk');

      }
        await Flushbar(
          title: 'Updated... ${_fullNameController.text}',
          message: 'Your profile updated successfully!',
          duration: Duration(seconds: 3),
          titleColor: Constants.background,
          messageColor: Constants.background,
          backgroundColor: Constants.primary,
          maxWidth: 600,
          titleSize: 32,
          showProgressIndicator: true,
          flushbarPosition: FlushbarPosition.TOP,
          margin: EdgeInsets.all(20),
        ).show(context);

    }

  }

  void _changeThePassword() {}

  void _fetchUserData() async {
    final UserViewModels userViewModels =
    Provider.of<UserViewModels>(context, listen: false);
    var fetchedUser =
    await userViewModels.getUserData(userViewModels.userModel!.userID);
    debugPrint('Fetched User: $fetchedUser');
    debugPrint(userViewModels.state.toString());

    debugPrint(fetchedUser.toString());
    if (fetchedUser != null) {
      _emailController.text =
      fetchedUser.email.isNotEmpty ? fetchedUser.email : '';
      _communityNameController.text =
      fetchedUser.communityName?.isNotEmpty ?? false ? fetchedUser.communityName! : '';
      _cityController.text =
      fetchedUser.city?.isNotEmpty ?? false ? fetchedUser.city! : '';
      _stateController.text =
      fetchedUser.state?.isNotEmpty ?? false ? fetchedUser.state! : '';
      _zipCodeController.text =
      fetchedUser.zipCode?.isNotEmpty ?? false ? fetchedUser.zipCode! : '';
      _addressLine1Controller.text =
      fetchedUser.addressLine1?.isNotEmpty ?? false ? fetchedUser.addressLine1! : '';
      _fullNameController.text =
      fetchedUser.fullName?.isNotEmpty ?? false ? fetchedUser.fullName! : '';
    }
  }
}
