import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/screens/profile/screens/changePasswordScreenUser.dart';
import 'package:subcript/service/models/userLogin.dart';
import 'package:subcript/utils/colors.dart';
import 'package:subcript/utils/widgets/customAlertDialogInfo.dart';
import 'package:subcript/utils/widgets/my_custom_Clipper.dart';


class ProfileUser extends StatefulWidget {
  const ProfileUser({super.key});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {

  UserLogin? userSession;
  @override
  void initState() {
    userSession = UserLogin.fromJson(GetStorage().read('user'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          ClipPath(
      child: Container(
        color: mainColorBlue,
        height: 300.0,
      ),
      clipper: MyCustomClipper(),
      ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                20.height,
                Container(
                  width: 130, // Ajusta el tamaño de la imagen según tus necesidades
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white, // Color del borde blanco
                      width: 5.0, // Ancho del borde
                    ),
                    image: const DecorationImage(
                      image: AssetImage('resources/studiorenderImage.jpeg'), // Ruta de la imagen de perfil
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  children: [
                    10.height,
                    Text(userSession?.userName ?? '',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    60.height,
                    /*Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColorBlue,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: mainColorBlue, width: 1),
                            borderRadius: BorderRadius.circular(
                                8), // Esquinas redondeadas
                          ),
                        ),
                        onPressed: () {

                        },
                        child:
                        const Text("Modificar perfil",style: TextStyle(fontSize: 16),),
                      ),
                    ),
                    10.height,
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: mainColorBlue,
                          elevation: 2,
                          // Sombra en un color naranja más claro y semi-transparente
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: mainColorBlue, width: 1),
                            borderRadius: BorderRadius.circular(
                                8), // Esquinas redondeadas
                          ),
                        ),
                        onPressed: () async {

                        },
                        child: const Text("Justificantes",style: TextStyle(fontSize: 16),)
                      ),
                    ),
                    10.height,*/
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: mainColorBlue,
                          elevation: 2,
                          // Sombra en un color naranja más claro y semi-transparente
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: mainColorBlue,
                                width: 1),
                            borderRadius: BorderRadius.circular(
                                8), // Esquinas redondeadas
                          ),
                        ),
                        onPressed: () {
                          const ChangePasswordScreenUser().launch(context);
                        },
                        child: const Text('Modificar contraseña',style: TextStyle(fontSize: 16),),
                      ),
                    ),
                    10.height,
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: mainColorBlue,
                          elevation: 2,
                          // Sombra en un color naranja más claro y semi-transparente
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: mainColorBlue,
                                width: 1),
                            borderRadius: BorderRadius.circular(
                                8), // Esquinas redondeadas
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialogInfo(
                              title: "Eliminar cuenta",
                              message:
                              "Su petición de Eliminar su cuenta ha sido enviada con exito. Su cuenta sera eliminada en un plazo de 24-48 horas",
                              onConfirm: () {


                                Get.offNamedUntil('/', (route) => false);
                              },
                              onCancel: (){
                                Navigator.of(context).pop();
                              },
                            ),
                          );

                        },
                        child: const Text('Eliminar Cuenta',style: TextStyle(fontSize: 16),),
                      ),
                    ),
                    10.height,
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: mainColorBlue,
                          elevation: 2,
                          // Sombra en un color naranja más claro y semi-transparente
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: mainColorBlue,
                                width: 1),
                            borderRadius: BorderRadius.circular(
                                8), // Esquinas redondeadas
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialogInfo(
                              title: "Cerrar sesión",
                              message:
                              "Se va a cerrar sesión, estas seguro que deseas cerrarla?. ",
                              onConfirm: () {
                                GetStorage().erase();
                                Get.offNamedUntil('/', (route) => false);
                              },
                            ),
                          );

                        },
                        child: const Text('Cerrar Sesión',style: TextStyle(fontSize: 16),),
                      ),
                    ),


                  ],
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}
