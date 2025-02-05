import 'package:flutter/material.dart';

class BuildTextFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextInputType keyBoardType;
  final String labetText;
  final String hintText;
  final IconData textFormFieldIcon;
  final Color textFormFieldIconColor;
  final Color outLineInputBorderColor;
  final Color outLineInputBorderColorOnFocused;

  const BuildTextFormField(
      {required this.textEditingController,
      required this.keyBoardType,
      required this.labetText,
      required this.hintText,
      required this.textFormFieldIcon,
      required this.textFormFieldIconColor,
      required this.outLineInputBorderColor,
      required this.outLineInputBorderColorOnFocused,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      keyboardType: keyBoardType,
      decoration: InputDecoration(
        labelText: labetText,
        hintText: hintText,
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
    );
  }
}
