import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/Screens/register/registerAdminScreen.dart';
import 'package:subcript/service/controller/register_controller.dart';
import 'package:subcript/utils/colors.dart';
import 'package:subcript/utils/widgets/buttonMaterialCustom.dart';
import 'package:subcript/utils/widgets/textFieldCustom.dart';

class RegisterCompanyScreen extends StatefulWidget {
  const RegisterCompanyScreen({super.key});

  @override
  State<RegisterCompanyScreen> createState() => _RegisterCompanyScreenState();
}

class _RegisterCompanyScreenState extends State<RegisterCompanyScreen> {
  FocusNode password = FocusNode();
  FocusNode re_password = FocusNode();
  FocusNode userName = FocusNode();
  FocusNode jobName = FocusNode();
  FocusNode cif = FocusNode();
  FocusNode adress = FocusNode();
  FocusNode emailJob = FocusNode();
  FocusNode city = FocusNode();
  FocusNode province = FocusNode();
  FocusNode country = FocusNode();
  FocusNode emailUser = FocusNode();

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
          title: const Text('Registrar Empresa',
              style: TextStyle(
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
                          'Introduce los siguientes datos necesarios para el registro de su empresa:',
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                    ),
                    30.height,
                    TextFieldCustom(
                      controller: con.companyNameController,
                      color: Colors.black,
                      colorText: Colors.black,
                      textFieldType: TextFieldType.EMAIL,
                      focus: jobName,
                      autofocus: true,
                      border: 25.0,
                      nameLabel: "Nombre",
                    ),
                    15.height,
                    TextFieldCustom(
                      controller: con.cifnifController,
                      color: Colors.black,
                      colorText: Colors.black,
                      textFieldType: TextFieldType.EMAIL,
                      focus: cif,
                      autofocus: false,
                      border: 25.0,
                      nameLabel: "CifNif",
                    ),
                    15.height,
                    TextFieldCustom(
                      controller: con.emailController,
                      color: Colors.black,
                      colorText: Colors.black,
                      textFieldType: TextFieldType.EMAIL,
                      focus: emailJob,
                      autofocus: false,
                      border: 25.0,
                      nameLabel: "Correo",
                    ),
                    15.height,
                    TextFieldCustom(
                      controller: con.townController,
                      color: Colors.black,
                      colorText: Colors.black,
                      textFieldType: TextFieldType.EMAIL,
                      focus: city,
                      autofocus: false,
                      border: 25.0,
                      nameLabel: "Ciudad",
                    ),
                    15.height,
                    TextFieldCustom(
                      controller: con.provinceController,
                      color: Colors.black,
                      colorText: Colors.black,
                      textFieldType: TextFieldType.EMAIL,
                      focus: province,
                      autofocus: false,
                      border: 25.0,
                      nameLabel: "Provincia",
                    ),
                    15.height,
                    TextFieldCustom(
                      controller: con.countryController,
                      color: Colors.black,
                      colorText: Colors.black,
                      textFieldType: TextFieldType.EMAIL,
                      focus: country,
                      autofocus: false,
                      border: 25.0,
                      nameLabel: "País",
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              SafeArea(
                top: false,
                child: ButtonMaterialCustom(
                    nameButton: 'Siguiente',
                    pHorizontal: 40,
                    pVertical: 15,
                    borderSize: 6,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterAdminScreen(
                              cifnif: con.cifnifController.text.trim(),
                              nameCompany:
                                  con.companyNameController.text.trim(),
                              country: con.countryController.text.trim(),
                              email: con.emailController.text.trim(),
                              province: con.provinceController.text.trim(),
                              town: con.townController.text.trim()),
                        ),
                      );


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
