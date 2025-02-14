import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_Text_Form_Field.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_draw_menu.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_elevated_button.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/build_text_for_form.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants/custom_app_bar.dart';
import 'package:flutter_fundraising_goal_chart/models/user_model.dart';
import 'package:flutter_fundraising_goal_chart/view_models/user_view_models.dart';
import 'package:flutter_fundraising_goal_chart/views/auth/forgot_password.dart';
import 'package:flutter_fundraising_goal_chart/views/auth/sign_up.dart';
import 'package:flutter_fundraising_goal_chart/views/fundraising/fundraising_setup_page.dart';
import 'package:provider/provider.dart';


class SingInPage extends StatefulWidget {
  const SingInPage({super.key});

  @override
  State<SingInPage> createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late String email, password;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? fullName;


  void _singIn() async {
    final UserViewModels userViewModels = Provider.of<UserViewModels>(context, listen: false);
    bool validateForm = userViewModels.validateFormForSignIn(
        _emailController, _passwordController);
    if (validateForm) {
      _formKey.currentState!.save();

      UserModel? user = await userViewModels.signInWithEmailAndPassword(email, password);
      final _userviewModel = await userViewModels.getUserData(userViewModels.userModel!.userID);

      debugPrint('Burasi sign in mehod ${user!.fullName}');
      debugPrint('Burasi sign in mehod ----- ${_userviewModel!.fullName}');

      if (_userviewModel.fullName != null) {
        await Flushbar(
          title: 'Welcome ${_userviewModel.fullName}',
          message: 'Your account signed successfully! Thank You!',
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

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                   FundraisingSetupPage()));
      }

      debugPrint(user!.userID);
    }
    debugPrint('Email: ${_emailController.text}');
    debugPrint('Password: ${_passwordController.text}');
  }

  void _signUp() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserViewModels userViewModels =
        Provider.of<UserViewModels>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      appBar:CustomAppBar(title: 'Sign In Page', scaffoldKey: _scaffoldKey,),
      drawer: BuildDrawMenu(),
      body:  Center(
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
            child: Consumer(builder: (context, UserViewModels, child) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20),
                    Align(
                      child: Text(
                        "Sign In",
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
                    SizedBox(height: 20),
                    BuildElevatedButton(
                      onPressed: _singIn,
                      buttonText: "Sign In",
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordPage()));
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Constants.primary),
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0.64,
                      child: TextButton(
                        onPressed: () {
                          _signUp();
                        },
                        child: Text.rich(
                          const TextSpan(
                            text: "Don’t have an account? ",
                            style: TextStyle(color: Constants.primary),
                            children: [
                              TextSpan(
                                text: "Sign Up",
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

}
