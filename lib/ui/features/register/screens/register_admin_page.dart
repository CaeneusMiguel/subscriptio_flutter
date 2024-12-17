import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/data/profile/repository/controller/register_controller.dart';
import 'package:subcript/ui/features/common/widgets/buttonMaterialCustom.dart';
import 'package:subcript/ui/features/common/widgets/customAlertDialogInfo.dart';
import 'package:subcript/ui/features/common/widgets/textFieldCustom.dart';
import 'package:subcript/ui/theme/colors.dart';

class RegisterAdminScreen extends StatefulWidget {
  final String nameCompany;
  final String cifnif;
  final String email;
  final String town;
  final String province;
  final String country;

  const RegisterAdminScreen({
    super.key,
    required this.nameCompany,
    required this.cifnif,
    required this.email,
    required this.town,
    required this.province,
    required this.country,
  });

  @override
  State<RegisterAdminScreen> createState() => _RegisterAdminScreenState();
}

class _RegisterAdminScreenState extends State<RegisterAdminScreen> {
  FocusNode password = FocusNode();
  FocusNode re_password = FocusNode();
  FocusNode userName = FocusNode();
  FocusNode lastName = FocusNode();
  FocusNode email = FocusNode();
  FocusNode dni = FocusNode();
  FocusNode telephone = FocusNode();

  bool _obscurePassword = true; // Controla si la contraseña principal está oculta
  bool _obscureRePassword = true; // Controla si la confirmación de contraseña está oculta

  RegisterController con = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Registrar Responsable',
              style: TextStyle(fontSize: 26, color: Colors.black,fontWeight: FontWeight.bold)),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    20.height,
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Introduce los datos del responsable a cargo de la empresa:',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    30.height,
                    TextFieldCustom(
                      controller: con.nameUserController,
                      color: Colors.black,
                      colorText: Colors.black,
                      textFieldType: TextFieldType.EMAIL,
                      focus: userName,
                      autofocus: true,
                      border: 25.0,
                      nameLabel: "Nombre",
                    ),
                    15.height,
                    TextFieldCustom(
                      controller: con.pinCodeController,
                      color: Colors.black,
                      colorText: Colors.black,
                      textFieldType: TextFieldType.EMAIL,
                      focus: lastName,
                      autofocus: true,
                      border: 25.0,
                      nameLabel: "Código Checking",
                    ),
                    15.height,
                    TextFieldCustom(
                      controller: con.usernameController,
                      color: Colors.black,
                      colorText: Colors.black,
                      textFieldType: TextFieldType.EMAIL,
                      focus: dni,
                      autofocus: false,
                      border: 25.0,
                      nameLabel: "DNI",
                    ),
                    15.height,
                    TextFieldCustom(
                      controller: con.codeController,
                      color: Colors.black,
                      colorText: Colors.black,
                      textFieldType: TextFieldType.EMAIL,
                      focus: email,
                      autofocus: false,
                      border: 25.0,
                      nameLabel: "Código",
                    ),
                    15.height,
                    TextFieldCustom(
                      controller: con.telephoneController,
                      color: Colors.black,
                      colorText: Colors.black,
                      textFieldType: TextFieldType.PHONE,
                      focus: telephone,
                      autofocus: false,
                      border: 25.0,
                      nameLabel: "Teléfono",
                    ),
                    15.height,
                    AppTextField(
                      focus: password,
                      controller: con.passwordController,
                      textFieldType: TextFieldType.PASSWORD,
                      cursorColor: Colors.black,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        labelStyle: const TextStyle(color: Colors.black),
                        suffixIcon: IconButton(
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
                          const BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                    15.height,
                    AppTextField(
                      focus: re_password,
                      controller: con.re_passwordController,
                      textFieldType: TextFieldType.PASSWORD,
                      cursorColor: Colors.black,
                      obscureText: _obscureRePassword,
                      decoration: InputDecoration(
                        labelText: "Confirmar Contraseña",
                        labelStyle: const TextStyle(color: Colors.black),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureRePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureRePassword = !_obscureRePassword;
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
                          borderSide:
                          const BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              SafeArea(
                top: false,
                child: ButtonMaterialCustom(
                  nameButton: 'Registrar',
                  pHorizontal: 40,
                  pVertical: 15,
                  borderSize: 6,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => CustomAlertDialogInfo(
                        activeCancel: false,
                        title: "Info",
                        message:
                        "Su petición de registro ha sido enviada con éxito. Su cuenta será creada en un plazo de 24-48 horas",
                        onConfirm: () {
                          Get.offNamedUntil('/', (route) => false);
                        },
                      ),
                    );
                  },
                  colorButton: mainColorBlue,
                  textColor: Colors.white,
                  textSize: 16,
                ),
              ),
              30.height,
            ],
          ),
        ),
      ),
    );
  }
}
