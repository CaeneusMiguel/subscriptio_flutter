import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/data/auth/repository/controller/login_controller.dart';
import 'package:subcript/ui/features/common/widgets/buttonMaterialCustom.dart';
import 'package:subcript/ui/features/login/screens/subcriptio_hub_config_page.dart';
import 'package:subcript/ui/theme/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode password = FocusNode();
  FocusNode userName = FocusNode();
  String? currentYear = DateTime.now().year.toString();
  bool _obscureText = true; // Estado para controlar si la contraseña está oculta

  LoginController con = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    currentYear = DateTime.now().year.toString();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent, // Cambia el color de fondo de la barra de estado
      statusBarIconBrightness: Brightness.dark, // Cambia el color del texto en la barra de estado
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                ).animate().fade(delay: 400.ms).slideY()),
            20.height,
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppTextField(
                  focus: userName,
                  controller: con.emailController,
                  textFieldType: TextFieldType.EMAIL,
                  cursorColor: Colors.black,
                  textStyle: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.black),
                    labelText: "Usuario",
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
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                ).animate().fade(delay: 500.ms).slideY()),
            30.height,
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppTextField(
                  focus: password,
                  controller: con.passwordController,
                  textFieldType: TextFieldType.PASSWORD,
                  cursorColor: Colors.black,
                  obscureText: _obscureText,
                  textStyle: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.black),
                    labelText: "Contraseña",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
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
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                ).animate().fade(delay: 600.ms).slideY()),
            40.height,
            ButtonMaterialCustom(
                nameButton: 'Iniciar Sesión',
                pHorizontal: 40,
                pVertical: 15,
                borderSize: 6,
                onPressed: () async {
                  await FirebaseMessaging.instance.getToken().then((value) async {
                    GetStorage().write('tokenMessage', value);
                    await con.login(value);
                  });
                },
                colorButton: mainColorBlue,
                textColor: Colors.white,
                textSize: 16).animate().fade(delay: 700.ms).slideY(),
            40.height,
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
                      style: TextStyle(fontWeight: FontWeight.bold, color: mainColorBlue)),
                )
              ],
            ).animate().fade(delay: 800.ms).slideY(),
            30.height,
            GestureDetector(
              onTap: () {
                Get.toNamed('/recoverPass');
              },
              child: Center(
                child: const Text('¿Olvidaste la contraseña?',
                    style: TextStyle(fontWeight: FontWeight.bold, color: mainColorBlue)).animate().fade(delay: 900.ms).slideY(),
              ),
            ),
            Expanded(child: Container()),
            Center(child:  Text("© $currentYear Studio128k.",style: const TextStyle(fontSize:16)).animate().fade(delay: 1000.ms).slideY()),
            10.height,
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10.0, bottom: 20),
        child: FloatingActionButton(
          onPressed: () {
            const SubcriptioHubConfigPage().launch(context);
          },
          elevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          splashColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          child: SvgPicture.asset(
            'resources/hub_2.svg',
            width: 62,
            height: 62,
            color: mainColorBlue,
          ),
        ),
      ),
    );
  }
}
