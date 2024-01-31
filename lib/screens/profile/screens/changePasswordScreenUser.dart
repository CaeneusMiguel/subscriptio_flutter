import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/screens/login/loginScreen.dart';
import 'package:subcript/service/controller/password_change_controller.dart';
import 'package:subcript/utils/colors.dart';
import 'package:subcript/utils/common/alertDialogInfo.dart';
import 'package:subcript/utils/common/confirmDialog.dart';


class ChangePasswordScreenUser extends StatefulWidget {

  const ChangePasswordScreenUser({super.key});

  @override
  State<ChangePasswordScreenUser> createState() => _ChangePasswordScreenUserState();
}

class _ChangePasswordScreenUserState extends State<ChangePasswordScreenUser> {

  PasswordChangeController con = Get.put(PasswordChangeController());

  FocusNode newPassword = FocusNode();
  FocusNode confirmPassword = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Column(
          children: [
            SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    20.height,
                    const Text('Modificar Contraseña',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold))
                        .paddingSymmetric(horizontal: 0)
                        .center(),
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
                        child: Text('Introduce una nueva contraseña que contenga  caracteres alfanumericos, mayusculas y minusculas .',style: TextStyle(fontSize: 16),),
                      ),
                      30.height,
                      AppTextField(
                        controller: con.passWordController,
                        focus: newPassword,
                        nextFocus: confirmPassword,
                        textInputAction: TextInputAction.next,
                        textFieldType: TextFieldType.PASSWORD,
                        cursorColor: Colors.black12,
                        suffixIconColor: Colors.black,
                        textStyle:
                        primaryTextStyle(color: Colors.black54, size: 16),
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.black54),
                          label: const Text('Nueva Contraseña',
                              style: TextStyle(fontFamily: 'Vagrounded')),
                          contentPadding:
                          const EdgeInsets.fromLTRB(30, 18, 18, 18),
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
                            borderSide:
                            const BorderSide(color: mainColorBlue, width: 2),
                          ),
                        ),
                      ),
                      25.height,
                      AppTextField(
                        controller: con.passWordRepController,
                        focus: confirmPassword,
                        textInputAction: TextInputAction.done,
                        textFieldType: TextFieldType.PASSWORD,
                        cursorColor: Colors.black,
                        textStyle:
                        primaryTextStyle(color: Colors.black54, size: 16),
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.black),
                          label: const Text('Confirmar Contraseña',
                              style: TextStyle(fontFamily: 'Vagrounded')),
                          contentPadding:
                          const EdgeInsets.fromLTRB(30, 18, 18, 18),
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
                            borderSide:
                            const BorderSide(color: mainColorBlue, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 30),
                ).expand()
          ],
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: mainColorBlue.withAlpha(70),
                  borderRadius: radius(100)),
              child: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Colors.white),
                onPressed: () {
                  finish(context);
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: mainColorBlue, borderRadius: radius(100)),
              child: IconButton(
                icon: const Icon(Icons.check, color: Colors.white),
                onPressed: () {
                  if(con.passWordController.text.trim()==con.passWordRepController.text.trim()){
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        title: "Modificación de Contraseña",
                        message:
                        "Se va a modificar la contraseña con la que se inicia sesión, la sesión se cerrará a continuación. ",
                        onConfirm: () {
                          con.updatePasswordUser();
                          const LoginScreen().launch(context);

                        },
                      ),
                    );
                  }else{
                   showDialog(
                      context: context,
                      builder: (context) => AlertDialogInfo(
                        title: "Error",
                        message:
                        "Las contraseñas Introducidas son diferentes, porfavor asegurate de que sean iguales.",
                        onConfirm: () {
                          Navigator.pop(context);
                        },
                      ),
                    );

                  }

                },
              ),
            )
          ],
        ).paddingSymmetric(horizontal: 30,vertical: 30),
      ),
    );
  }
}

