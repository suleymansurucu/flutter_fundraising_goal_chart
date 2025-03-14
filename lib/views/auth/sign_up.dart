import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_Text_Form_Field.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_elevated_button.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_text_for_form.dart';
import 'package:flutter_fundraising_goal_chart/models/user_model.dart';
import 'package:flutter_fundraising_goal_chart/view_models/user_view_models.dart';
import 'package:flutter_fundraising_goal_chart/views/auth/sing_in.dart';
import 'package:flutter_fundraising_goal_chart/views/fundraising/fundraising_setup_page.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late String email, fullName, password, passwordConfirm;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  void _singUp() async {
    final UserViewModels userViewModels =
    Provider.of<UserViewModels>(context, listen: false);
    var validateForm = userViewModels.validateForm(_emailController,
        _fullNameController, _passwordController, _passwordConfirmController);
    if (validateForm) {
      _formKey.currentState!.save();

      var user = await userViewModels.createWithInEmailAndPassword(
          email, passwordConfirm);

      if (user != null) {
        var newSaveUser=UserModel(userID: user.userID, email: email,createdAt: DateTime.timestamp(), fullName: fullName);
        await userViewModels.saveUser(newSaveUser);
        await Flushbar(
          title: 'Welcome ${_fullNameController.text}',
          message: 'Your account created successfully! Thank You!',
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

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => FundraisingSetupPage()));
      }

    }


  }

  void _singIn() {
    Navigator.pop(
        context, MaterialPageRoute(builder: (context) => SingInPage()));
  }

  @override
  Widget build(BuildContext context) {
    final UserViewModels userViewModels =
    Provider.of<UserViewModels>(context, listen: false);
    return userViewModels.state == ViewState.Idle
        ? Scaffold(
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
            child: Consumer<UserViewModels>(builder: (context, userViewModels, child) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20),
                    Align(
                      child: Text(
                        "Sign Up",
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
                        text: 'Please Enter Your Full Name:',
                        textColor: Constants.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w100),
                    SizedBox(height: 4),
                    BuildTextFormField(
                      keyBoardType: TextInputType.text,
                      labelText: 'FullName',
                      hintText: 'Enter Full Name',
                      textFormFieldIcon: Icons.email,
                      textFormFieldIconColor: Constants.accent,
                      outLineInputBorderColor: Constants.accent,
                      outLineInputBorderColorOnFocused: Constants.primary,
                      textEditingController: _fullNameController,
                      errorText: userViewModels.userNameError,
                      onSaved: (value) {
                        fullName = value!;
                      },
                    ),
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
                    BuildTextForForm(
                        text: 'Please Enter Password:',
                        textColor: Constants.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w100),
                    SizedBox(height: 4),
                    BuildTextFormField(
                      keyBoardType: TextInputType.visiblePassword,
                      labelText: 'Password',
                      hintText: 'Enter Password',
                      textFormFieldIcon: Icons.mode_edit_sharp,
                      textFormFieldIconColor: Constants.accent,
                      outLineInputBorderColor: Constants.accent,
                      outLineInputBorderColorOnFocused: Constants.primary,
                      textEditingController: _passwordController,
                      errorText: userViewModels.passwordError,
                      onSaved: (value) {
                        password = value!;
                      },
                    ),
                    SizedBox(height: 15),
                    BuildTextForForm(
                        text: 'Please Enter Confirm Password:',
                        textColor: Constants.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w100),
                    SizedBox(height: 4),
                    BuildTextFormField(
                      keyBoardType: TextInputType.visiblePassword,
                      labelText: 'Confirm Password',
                      hintText: 'Enter Confirm Password',
                      textFormFieldIcon: Icons.mode_edit_sharp,
                      textFormFieldIconColor: Constants.accent,
                      outLineInputBorderColor: Constants.accent,
                      outLineInputBorderColorOnFocused: Constants.primary,
                      textEditingController: _passwordConfirmController,
                      errorText: userViewModels.confirmPasswordError,
                      onSaved: (value) {
                        passwordConfirm = value!;
                      },
                    ),
                    SizedBox(height: 20),
                    BuildElevatedButton(
                      onPressed: _singUp,
                      buttonText: "Create",
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
                          _singIn();
                        },
                        child: Text.rich(
                          const TextSpan(
                            text: "Already  have an account? ",
                            style: TextStyle(color: Constants.primary),
                            children: [
                              TextSpan(
                                text: "Sign In",
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
    )
        : Center(
      child: CircularProgressIndicator(),
    );
  }
}
