import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/service/controller/login_controller.dart';
import 'package:subcript/utils/colors.dart';
import 'package:subcript/utils/widgets/buttonMaterialCustom.dart';
import 'package:subcript/utils/widgets/textFieldCustom.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode password = FocusNode();
  FocusNode userName = FocusNode();

  LoginController con = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              50.height,
              Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    'resources/logo.png',
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  )),
              20.height,
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFieldCustom(
                    controller: con.emailController,
                    color: Colors.black,
                    colorText: Colors.black,
                    textFieldType: TextFieldType.EMAIL,
                    focus: userName,
                    autofocus: true,
                    border: 25.0,
                    nameLabel: "Usuario",
                  )),
              30.height,
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFieldCustom(
                    controller: con.passwordController,
                    color: Colors.black,
                    colorText: Colors.black,
                    textFieldType: TextFieldType.PASSWORD,
                    focus: password,
                    autofocus: true,
                    border: 25.0,
                    nameLabel: "Contraseña",
                  )),
              40.height,
              ButtonMaterialCustom(
                  nameButton: 'Iniciar Sesión',
                  pHorizontal: 40,
                  pVertical: 15,
                  borderSize: 6,
                  onPressed: () {
                    con.login();


                  },
                  colorButton: mainColorBlue,
                  textColor: Colors.white,
                  textSize: 16),
              50.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Aún no tienes cuenta? ",
                      style: TextStyle(fontSize: 16)),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/registerCompany');
                    },
                    child: const Text('Regístrate',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              Expanded(child: Container()),
              const Center(child: Text("© 2023 Studio128k.")),
            ],
          ),
        ),
      ),
    );
  }
}
