import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/ui/theme/colors.dart';

class CustomAlertDialogInfo extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool activeCancel;

  const CustomAlertDialogInfo({
    Key? key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.onCancel,required this.activeCancel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(36),
          bottomLeft: Radius.circular(36),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
          16.height,
          Text(message,style: TextStyle(fontSize: 16,)),
          16.height,
        ],
      ),
      actions: [
        activeCancel ?
        TextButton(
            onPressed: onCancel,
            child: const Text("Cancelar",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.grey))
        ): Container(),
        TextButton(
          onPressed: onConfirm,
          child: const Text("Aceptar",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: mainGreenColorButton))
        ),


      ],
    );
  }
}
