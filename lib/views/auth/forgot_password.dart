import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/routes/route_names.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_Text_Form_Field.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_draw_menu.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_elevated_button.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_text_for_form.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/custom_app_bar.dart';
import 'package:flutter_fundraising_goal_chart/view_models/user_view_models.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldUserForgotPassword = GlobalKey<ScaffoldState>();

  void _forgotPassword() async {
    print('Your Email Adress ${_emailController.text}');
    final UserViewModels userViewModels =
    Provider.of<UserViewModels>(context, listen: false);
    bool? result = await userViewModels.sendPasswordResetEmail(_emailController.text);

    Future.delayed(Duration(milliseconds: 300), () async {
      if (mounted) {
        if(result!)  {
          await Flushbar(
            title: 'Hello ${_emailController.text}!',
            message: 'You should check your email box for reset your email',
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldUserForgotPassword,
      appBar: CustomAppBar(
        title: 'Forgot Password',
        scaffoldKey: _scaffoldUserForgotPassword,
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
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  Align(
                    child: Text(
                      "Forgot Password",
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
                      textEditingController: _emailController),
                  SizedBox(height: 20),
                  BuildElevatedButton(
                    onPressed: _forgotPassword,
                    buttonText: "Forgot",
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
