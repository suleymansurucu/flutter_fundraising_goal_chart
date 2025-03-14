import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fundraising_goal_chart/core/utils/constants.dart';

class BuildTextFormFieldViaPassword extends StatefulWidget {
  final TextEditingController textEditingController;
  final TextInputType keyBoardType;
  final String? labelText;
  final String hintText;
  final IconData? textFormFieldIcon;
  final Color? textFormFieldIconColor;
  final Color outLineInputBorderColor;
  final Color outLineInputBorderColorOnFocused;
  final FormFieldSetter<String>? onSaved;
  final String? Function(String?)? validator;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onPressedObscure;
  bool obscureText;

  BuildTextFormFieldViaPassword({
    required this.textEditingController,
    required this.keyBoardType,
    this.labelText,
    required this.hintText,
    this.textFormFieldIcon,
    this.textFormFieldIconColor,
    required this.outLineInputBorderColor,
    required this.outLineInputBorderColorOnFocused,
    this.onSaved,
    this.validator,
    this.errorText,
    this.inputFormatters,
    this.obscureText = true,
    this.onPressedObscure,
    super.key,
  });

  @override
  State<BuildTextFormFieldViaPassword> createState() =>
      _BuildTextFormFieldViaPasswordState();
}

class _BuildTextFormFieldViaPasswordState
    extends State<BuildTextFormFieldViaPassword> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
    if (widget.onPressedObscure != null) {
      widget.onPressedObscure!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      controller: widget.textEditingController,
      keyboardType: widget.keyBoardType,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        errorText: widget.errorText,
        prefixIcon: widget.textFormFieldIcon != null
            ? Icon(widget.textFormFieldIcon, color: widget.textFormFieldIconColor)
            : null,
        suffixIcon: IconButton(
          onPressed: _togglePasswordVisibility,
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
        ),
        suffixIconColor: Constants.primary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: widget.outLineInputBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: widget.outLineInputBorderColorOnFocused, width: 2),
        ),
      ),
      onSaved: widget.onSaved,
      validator: widget.validator,
    );
  }
}
