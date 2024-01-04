import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/service/controller/register_controller.dart';
import 'package:subcript/utils/colors.dart';
import 'package:subcript/utils/widgets/buttonMaterialCustom.dart';
import 'package:subcript/utils/widgets/customAlertDialogInfo.dart';
import 'package:subcript/utils/widgets/textFieldCustom.dart';

class RegisterAdminScreen extends StatefulWidget {
  final String nameCompany;
  final String cifnif;
  final String email;
  final String town;
  final String province;
  final String country;

  const RegisterAdminScreen(
      {super.key, required this.nameCompany, required this.cifnif, required this.email, required this.town, required this.province, required this.country});

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

  RegisterController con = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent, // Fondo transparente
          elevation: 0, // Eliminar la sombra
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            // Flecha de retroceso con color negro
            onPressed: () {
              // Agrega aquí la función para volver atrás
              Navigator.pop(context);
            },
          ),
          title: const Text('Registrar Responsable', style: TextStyle(
              fontSize: 20, color: Colors.black)), // Color del texto negro
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
                          style: TextStyle(fontSize: 16, color: Colors.black)),
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
                      nameLabel: "Codigo checking",
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
                      nameLabel: "Codigo",
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
                      nameLabel: "Telefono",
                    ),
                    15.height,
                    TextFieldCustom(
                      controller: con.passwordController,
                      color: Colors.black,
                      colorText: Colors.black,
                      textFieldType: TextFieldType.PASSWORD,
                      focus: password,
                      autofocus: false,
                      border: 25.0,
                      nameLabel: "Contraseña",
                    ),
                    15.height,
                    TextFieldCustom(
                      controller: con.re_passwordController,
                      color: Colors.black,
                      colorText: Colors.black,
                      textFieldType: TextFieldType.PASSWORD,
                      focus: re_password,
                      autofocus: false,
                      border: 25.0,
                      nameLabel: "Confirmar Contraseña",
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
                          title: "Info",
                          message:
                          "Su petición de registro ha sido enviada con exito. Su cuenta sera creada en un plazo de 24-48 horas",
                          onConfirm: () {
                            Get.offNamedUntil('/', (route) => false);
                          },
                        ),
                      );
                     /* con.register(
                          context, widget.nameCompany,
                          widget.cifnif,  widget.email,
                          widget.town, widget.province,
                          widget.country);*/
                    },
                    colorButton: mainColorBlue,
                    textColor: Colors.white,
                    textSize: 16),
              ),
              30.height
            ],
          ),
        ),
      ),
    );
  }
}
