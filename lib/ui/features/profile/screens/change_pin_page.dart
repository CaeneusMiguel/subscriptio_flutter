import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/data/profile/repository/controller/password_change_controller.dart';
import 'package:subcript/ui/features/common/alertDialogInfo.dart';
import 'package:subcript/ui/features/common/confirmDialog.dart';
import 'package:subcript/ui/features/login/screens/login_page.dart';
import 'package:subcript/ui/theme/colors.dart';

class ChangePinPage extends StatefulWidget {
  const ChangePinPage({super.key});

  @override
  State<ChangePinPage> createState() =>
      _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  PasswordChangeController con = Get.put(PasswordChangeController());

  FocusNode newPin = FocusNode();
  FocusNode confirmPin = FocusNode();

  bool _obscureNewPin = true;
  bool _obscureConfirmPin = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  20.height,
                  const Text(
                    'Modificar Pin',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ).paddingSymmetric(horizontal: 0).center(),
                  10.height,
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  20.height,
                  const Center(
                    child: Text(
                      'Introduce un nuevo pin de hasta 4 dígitos.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  30.height,
                  AppTextField(
                    controller: con.pinWordController,
                    focus: newPin,
                    nextFocus: confirmPin,
                    textInputAction: TextInputAction.next,
                    textFieldType: TextFieldType.PASSWORD,
                    obscureText: _obscureNewPin,
                    cursorColor: Colors.black12,
                    suffixIconColor: Colors.black,
                    textStyle: primaryTextStyle(
                      color: Colors.black54,
                      size: 16,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.black),
                      label: const Text(
                        'Nuevo pin',
                        style: TextStyle(fontFamily: 'Vagrounded'),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPin ? Icons.visibility_off : Icons.visibility,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPin = !_obscureNewPin;
                          });
                        },
                      ),
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

                  25.height,
                  AppTextField(
                    controller: con.pinWordRepController,
                    focus: confirmPin,
                    textInputAction: TextInputAction.done,
                    textFieldType: TextFieldType.PASSWORD,
                    obscureText: _obscureConfirmPin,
                    cursorColor: Colors.black,
                    textStyle: primaryTextStyle(
                      color: Colors.black54,
                      size: 16,
                    ),
                    keyboardType: TextInputType.number, // Solo teclado numérico
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Permitir solo números
                      LengthLimitingTextInputFormatter(4), // Limitar a 4 dígitos
                    ],
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.black),
                      label: const Text(
                        'Confirmar pin',
                        style: TextStyle(fontFamily: 'Vagrounded'),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPin ? Icons.visibility_off : Icons.visibility,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPin = !_obscureConfirmPin;
                          });
                        },
                      ),
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
              ).paddingSymmetric(horizontal: 30),
            ).expand(),
          ],
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: mainColorBlue.withOpacity(0.6),
                borderRadius: radius(100),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  finish(context);
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: mainColorBlue,
                borderRadius: radius(100),
              ),
              child: IconButton(
                icon: const Icon(Icons.check, color: Colors.white),
                onPressed: () {
                  if (con.pinWordController.text.trim() ==
                      con.pinWordRepController.text.trim()) {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        title: "Modificación de Pin",
                        message:
                        "Se va a modificar el PIN con el que se inicia la jornada en modo Hub. ¿Estás seguro de que deseas cambiarlo?",
                        onConfirm: () {
                          con.updatePinUser(context);

                        },
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialogInfo(
                        title: "Error",
                        message:
                        "Los pins introducidos son diferentes. Por favor, asegúrate de que sean iguales.",
                        onConfirm: () {
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 30, vertical: 30),
      ),
    );
  }
}
