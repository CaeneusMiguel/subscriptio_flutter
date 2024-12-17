import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
import 'package:subcript/data/check_in/repository/controller/checkin_checkout_controllet.dart';
import 'package:subcript/ui/theme/colors.dart';

class ConfirmDialogHub extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;

  const ConfirmDialogHub({
    Key? key,
    required this.title,
    required this.message,
    required this.onConfirm,
  }) : super(key: key);

  @override
  _ConfirmDialogHubState createState() => _ConfirmDialogHubState();
}

class _ConfirmDialogHubState extends State<ConfirmDialogHub> {
  ChekingCheckoutController con = Get.put(ChekingCheckoutController());
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(36),
          bottomLeft: Radius.circular(36),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          16.height,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(widget.message, style: const TextStyle(fontSize: 15)),
          ),
          26.height,
          AppTextField(
            controller: con.userController,
            textFieldType: TextFieldType.NAME,
            decoration:  InputDecoration(
              labelText: "Nombre de usuario",
              labelStyle: TextStyle(color: Colors.black),
              contentPadding: const EdgeInsets.fromLTRB(30, 18, 18, 18),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(36),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(36),
                borderSide: const BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(36),
                borderSide: const BorderSide(
                  color: mainColorBlue,
                  width: 2,
                ),
              ),
            ),
          ),
          16.height,
          AppTextField(
            cursorColor: mainColorBlue,
            controller: con.passwordController,
            textFieldType: TextFieldType.PASSWORD,
            obscureText: _obscurePassword, // Manejar visibilidad de contraseña
            suffix: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            decoration:  InputDecoration(
              focusColor: mainColorBlue,
              labelText: "Contraseña",
              labelStyle: TextStyle(color: Colors.black),
              contentPadding: const EdgeInsets.fromLTRB(30, 18, 18, 18),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(36),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(36),
                borderSide: const BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(36),
                borderSide: const BorderSide(
                  color: mainColorBlue,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
        child: const Text("Cancelar", style: TextStyle(fontSize: 18,color: Colors.grey,fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
        TextButton(
          onPressed: () {
            if (con.userController.text.trim().isEmpty ||
                con.passwordController.text.trim().isEmpty) {
              Get.snackbar(
                'Error',
                'Todos los campos deben estar llenos',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }

            final storedUser = GetStorage().read('UserHub') ?? '';
            final storedPass = GetStorage().read('PassHub') ?? '';

            if (con.userController.text.trim() == storedUser &&
                con.passwordController.text.trim() == storedPass) {
              con.passwordController.text = "";
              con.userController.text = "";
              widget.onConfirm();
              Navigator.of(context).pop();
              Get.toNamed('/');
            } else {
              Get.snackbar(
                'Error',
                'Usuario o contraseña incorrectos',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          },
          child: const Text("Aceptar", style: TextStyle(fontSize: 18,color: mainColorBlue,fontWeight: FontWeight.bold)),
        ),

      ],
    );
  }
}
