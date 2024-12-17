import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/data/auth/repository/provider/user_provider.dart';
import 'package:subcript/data/check_in/repository/controller/checkin_checkout_controllet.dart';
import 'package:subcript/data/check_in/repository/provider/cheking_provider.dart';
import 'package:subcript/ui/theme/colors.dart';

class SubcriptioHubConfigPage extends StatefulWidget {
  const SubcriptioHubConfigPage({super.key});

  @override
  State<SubcriptioHubConfigPage> createState() =>
      _SubcriptioHubConfigPageState();
}

class _SubcriptioHubConfigPageState extends State<SubcriptioHubConfigPage> {
  ChekingCheckoutController con = Get.put(ChekingCheckoutController());

  FocusNode userHub = FocusNode();
  FocusNode cif = FocusNode();
  FocusNode password = FocusNode();
  FocusNode confirmPassword = FocusNode();

  bool _obscurePassword = true; // Estado para ocultar/mostrar contraseña
  bool _obscureConfirmPassword = true; // Estado para ocultar/mostrar confirmación de contraseña

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
                  const Text('Configuración HUB',
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold))
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
                  40.height,
                  Center(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text:
                              'Introduce tu nombre de usuario y contraseña para tu '),
                          TextSpan(
                            text: 'Subcriptio HUB',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: mainColorBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  60.height,
                  AppTextField(
                    controller: con.userController,
                    focus: userHub,
                    nextFocus: cif,
                    textInputAction: TextInputAction.next,
                    textFieldType: TextFieldType.NAME,
                    cursorColor: Colors.black12,
                    suffixIconColor: Colors.black,
                    textStyle:
                    primaryTextStyle(color: Colors.black54, size: 16),
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.black),
                      label: const Text('Usuario',
                          style: TextStyle(fontFamily: 'Vagrounded')),
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
                        borderSide:
                        const BorderSide(color: mainColorBlue, width: 2),
                      ),
                    ),
                  ),
                  25.height,
                  AppTextField(
                    controller: con.cifController,
                    focus: cif,
                    nextFocus: password,
                    textInputAction: TextInputAction.next,
                    textFieldType: TextFieldType.NAME,
                    cursorColor: Colors.black12,
                    suffixIconColor: Colors.black,
                    textStyle:
                    primaryTextStyle(color: Colors.black54, size: 16),
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.black),
                      label: const Text('CIF',
                          style: TextStyle(fontFamily: 'Vagrounded')),
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
                        borderSide:
                        const BorderSide(color: mainColorBlue, width: 2),
                      ),
                    ),
                  ),
                  25.height,
                  AppTextField(
                    controller: con.passwordController,
                    focus: password,
                    nextFocus: confirmPassword,
                    textInputAction: TextInputAction.next,
                    textFieldType: TextFieldType.PASSWORD,
                    obscureText: _obscurePassword,
                    cursorColor: Colors.black,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    textStyle:
                    primaryTextStyle(color: Colors.black54, size: 16),
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.black),
                      label: const Text('Contraseña',
                          style: TextStyle(fontFamily: 'Vagrounded')),
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
                  color: mainColorBlue.withOpacity(0.6),
                  borderRadius: radius(100)),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                onPressed: () async {
                  if (con.userController.text.trim().isEmpty ||
                      con.cifController.text.trim().isEmpty ||
                      con.passwordController.text.trim().isEmpty ) {
                    Get.snackbar(
                      'Error',
                      'Todos los campos deben estar rellenos',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  Response response = await UserProvider()
                      .loginCifCompany(con.userController.text.trim(),con.passwordController.text.trim(),con.cifController.text.trim());

                  print(response.body);
                  if (response.body['success'] == true) {
                    Response responseApi = await ChekingProvider()
                        .listPausePurposeHub(con.cifController.text.trim());

                    if (responseApi.body['success'] == true) {
                      GetStorage()
                          .write('UserHub', con.userController.text.trim());
                      GetStorage().write('CifHub', con.cifController.text.trim());
                      GetStorage()
                          .write('PassHub', con.passwordController.text.trim());

                      con.userController.text = "";
                      con.cifController.text = "";
                      con.passwordController.text = "";
                      con.rePasswordController.text = "";

                      Get.toNamed('/subcriptioHub');
                    } else {
                      Get.snackbar(
                        'Error',
                        'El CIF introducido no pertenece a ninguna empresa',
                        backgroundColor: redColorButton,
                        colorText: Colors.white,
                      );
                    }
                  } else {
                    Get.snackbar(
                      'Error',
                      "${response.body['message']}",
                      backgroundColor: redColorButton,
                      colorText: Colors.white,
                    );
                  }

                },
              ),
            )
          ],
        ).paddingSymmetric(horizontal: 30, vertical: 30),
      ),
    );
  }
}
