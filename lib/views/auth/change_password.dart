import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_fundraising_goal_chart/core/routes/route_names.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_draw_menu.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_elevated_button.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_text_for_form.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_text_form_field_via_password.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/custom_app_bar.dart';
import 'package:flutter_fundraising_goal_chart/view_models/user_view_models.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<ScaffoldState> _scaffoldChangePasswordKey =
      GlobalKey<ScaffoldState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordConfirmController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserViewModels userViewModels =
        Provider.of<UserViewModels>(context, listen: false);
    return Scaffold(
      key: _scaffoldChangePasswordKey,
      appBar: CustomAppBar(
        title: 'Change Password',
        scaffoldKey: _scaffoldChangePasswordKey,
      ),
      drawer: BuildDrawMenu(),
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
                  SizedBox(height: 20),
                  Align(
                    child: Text(
                      "Change Password",
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
                      text: 'Please Enter New Password:',
                      textColor: Constants.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w100),
                  SizedBox(height: 4),
                  BuildTextFormFieldViaPassword(
                    textEditingController: _newPasswordController,
                    keyBoardType: TextInputType.visiblePassword,
                    hintText: 'Enter New Password',
                    outLineInputBorderColor: Constants.accent,
                    outLineInputBorderColorOnFocused: Constants.primary,
                    labelText: 'New Password',
                    textFormFieldIcon: Icons.mode_edit_sharp,
                    textFormFieldIconColor: Constants.accent,
                    errorText: userViewModels.passwordError,
                  ),
                  BuildTextForForm(
                      text: 'Please Enter Confirm Password:',
                      textColor: Constants.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w100),
                  SizedBox(height: 4),
                  BuildTextFormFieldViaPassword(
                    textEditingController: _newPasswordConfirmController,
                    keyBoardType: TextInputType.visiblePassword,
                    hintText: 'Enter Confirm Password',
                    outLineInputBorderColor: Constants.accent,
                    outLineInputBorderColorOnFocused: Constants.primary,
                    labelText: 'Confirm Password',
                    textFormFieldIcon: Icons.mode_edit_sharp,
                    textFormFieldIconColor: Constants.accent,
                    errorText: userViewModels.passwordError,
                  ),
                  SizedBox(height: 20),
                  BuildElevatedButton(
                    onPressed: () {
                      _changePassword(_newPasswordController.text);
                    },
                    buttonText: "Change Password",
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

  _changePassword(String newPassword) async {
    Future.delayed(Duration(milliseconds: 400), () async {
      UserViewModels userViewModels =
          Provider.of<UserViewModels>(context, listen: false);

      var user = userViewModels.userModel!.userID;
      if (user != null) {
        var result = await userViewModels.updatePassword(newPassword);
        if (result!) {
          await Flushbar(
            title: 'Hello !',
            message: 'You have updated password',
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
           context.push(RouteNames.singIn);
        }
      }
    });
  }
}
