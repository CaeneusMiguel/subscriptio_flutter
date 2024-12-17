import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/data/auth/repository/provider/user_provider.dart';
import 'package:subcript/data/profile/repository/controller/register_controller.dart';
import 'package:subcript/ui/features/common/widgets/buttonMaterialCustom.dart';
import 'package:subcript/ui/features/common/widgets/customAlertDialogInfo.dart';
import 'package:subcript/ui/features/common/widgets/textFieldCustom.dart';
import 'package:subcript/ui/theme/colors.dart';

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({super.key});

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  FocusNode userName = FocusNode();

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
          backgroundColor: Colors.transparent, // Fondo transparente
          elevation: 0, // Eliminar la sombra
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            // Flecha de retroceso con color negro
            onPressed: () {
              // Agrega aquí la función para volver atrás
              Navigator.pop(context);
            },
          ),
          title: const Text('Recuperar Contraseña',
              style: TextStyle(
                  fontSize: 26, color: Colors.black,fontWeight: FontWeight.bold)), // Color del texto negro
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  20.height,
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                        'Introduce tu email  para recuperar tu contraseña:',
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                  30.height,
                  TextFieldCustom(
                    controller: con.companyNameController,
                    color: Colors.black,
                    colorText: Colors.black,
                    textFieldType: TextFieldType.NAME,
                    focus: userName,
                    autofocus: true,
                    border: 25.0,
                    nameLabel: "Email",
                  ),
                ],
              ),
            ),
            40.height,
            SafeArea(
              top: false,
              child: ButtonMaterialCustom(
                  nameButton: 'Recuperar',
                  pHorizontal: 40,
                  pVertical: 15,
                  borderSize: 6,
                  onPressed: () async {
                    await UserProvider()
                        .recoverPassword(con.companyNameController.text)
                        .then((value) {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => CustomAlertDialogInfo(
                          title: "Recuperación de contraseña",
                          activeCancel: false,
                          message: value,
                          onConfirm: () {
                            con.companyNameController.clear();
                            Navigator.pop(context);
                          },
                          onCancel: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    });
                  },
                  colorButton: mainColorBlue,
                  textColor: Colors.white,
                  textSize: 16),
            ),
            30.height
          ],
        ),
      ),
    );
  }
}
