import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuildTextFormField extends StatefulWidget {
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




  const BuildTextFormField({
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
    super.key,
  });

  @override
  State<BuildTextFormField> createState() => _BuildTextFormFieldState();
}

class _BuildTextFormFieldState extends State<BuildTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      keyboardType: widget.keyBoardType,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        errorText: widget.errorText,
        prefixIcon: Icon(widget.textFormFieldIcon, color: widget.textFormFieldIconColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: widget.outLineInputBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          BorderSide(color: widget.outLineInputBorderColorOnFocused, width: 2),
        ),
      ),
      onSaved: widget.onSaved,
      validator: widget.validator,
    );
  }
}
