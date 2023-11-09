import 'package:flutter/material.dart';

class ButtonMaterialCustom extends StatelessWidget {
  final String nameButton;
  final double pHorizontal;
  final double pVertical;
  final double borderSize;
  final Color colorButton;
  final Color textColor;
  final double textSize;
  final VoidCallback onPressed;
  ButtonMaterialCustom(
      {required this.nameButton,
      required this.pHorizontal,
      required this.pVertical,
      required this.borderSize,
      required this.colorButton,
      required this.textColor,
      required this.textSize,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding:
          EdgeInsets.symmetric(horizontal: pHorizontal, vertical: pVertical),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderSize),
      ),
      onPressed: onPressed,
      color: colorButton,
      child: Text(
        nameButton,
        style: TextStyle(color: textColor, fontSize: textSize),
      ),
    );
  }
}
