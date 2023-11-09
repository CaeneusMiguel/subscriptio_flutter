import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class TextFieldCustom extends StatelessWidget {
  final String nameLabel;
  final double border;
  final Color color;
  final Color colorText;
  FocusNode? focus;
  TextEditingController? controller;
  final TextFieldType textFieldType;
  bool autofocus;

  TextFieldCustom(
      {required this.textFieldType,
      required this.autofocus,
      required this.nameLabel,
      required this.border,
      required this.color,
      required this.colorText,
      this.focus,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      focus: focus,
      textFieldType: textFieldType,
      autoFocus: autofocus,
      cursorColor: color,
      controller: controller,
      suffixIconColor: color,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: colorText),
        label: Text(
          nameLabel,
        ),
        contentPadding: const EdgeInsets.fromLTRB(30, 18, 18, 18),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colorText),
          borderRadius: BorderRadius.circular(36),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(36),
          borderSide: BorderSide(color: colorText),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(36),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
    ); /*,TextField(
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(border),
            borderSide:  BorderSide(color: color),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(border),
            borderSide:
             BorderSide(width: 1, color: color),
          ),
          labelText: nameLabel,
          labelStyle: TextStyle(color: colorText),
          alignLabelWithHint: false,
          filled: true),
      cursorColor: color,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
    );*/
  }
}
