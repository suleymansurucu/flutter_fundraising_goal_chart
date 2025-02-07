import 'package:flutter/material.dart';

class BuildTextFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextInputType keyBoardType;
  final String labelText;
  final String hintText;
  final IconData textFormFieldIcon;
  final Color textFormFieldIconColor;
  final Color outLineInputBorderColor;
  final Color outLineInputBorderColorOnFocused;
  final FormFieldSetter<String>? onSaved;
  final String? Function(String?)? validator;
  final String? errorText;


  const BuildTextFormField({
    required this.textEditingController,
    required this.keyBoardType,
    required this.labelText,
    required this.hintText,
    required this.textFormFieldIcon,
    required this.textFormFieldIconColor,
    required this.outLineInputBorderColor,
    required this.outLineInputBorderColorOnFocused,
    this.onSaved,
    this.validator,
    this.errorText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      keyboardType: keyBoardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        prefixIcon: Icon(textFormFieldIcon, color: textFormFieldIconColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: outLineInputBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          BorderSide(color: outLineInputBorderColorOnFocused, width: 2),
        ),
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }
}
