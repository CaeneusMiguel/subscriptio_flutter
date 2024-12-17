import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/ui/theme/colors.dart';

class CustomAlertDialogComment extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final ValueChanged<String> onCommentChanged; // Nuevo callback

  const CustomAlertDialogComment({
    Key? key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.onCancel,
    required this.onCommentChanged, // Nuevo callback
  }) : super(key: key);

  @override
  _CustomAlertDialogCommentState createState() => _CustomAlertDialogCommentState();
}

class _CustomAlertDialogCommentState extends State<CustomAlertDialogComment> {
  final TextEditingController _commentController = TextEditingController();

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
        children: [
          Text(widget.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          16.height,
          Text(widget.message, style: TextStyle(fontSize: 16)),
          16.height,
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: 'Añadir comentario',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            maxLines: 3,
            onChanged: widget.onCommentChanged, // Llama al callback al cambiar el texto
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: const Text(
            "Cancelar",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onConfirm();
          },
          child: const Text(
            "Aceptar",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: mainGreenColorButton),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
