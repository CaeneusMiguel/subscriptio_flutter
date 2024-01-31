import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/screens/profile/screens/changePasswordScreenUser.dart';
import 'package:subcript/service/controller/document_controller.dart';
import 'package:subcript/service/models/userLogin.dart';
import 'package:subcript/service/provider/user_provider.dart';
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
  late Uint8List imageDataUint8;
  ImagePicker picker = ImagePicker();
  File? imageFile;
  DocumentController con = Get.put(DocumentController());

  @override
  void initState() {
    userSession = UserLogin.fromJson(GetStorage().read('user'));
    _loaddata();
    super.initState();
  }


  Future<Uint8List?> _loaddata() async {
   // await UserProvider().getData(token).then((value) {
    //  code = UserClassFull.fromJson(GetStorage().read('userProfile') ?? {});
    imageFile ??= GetStorage().read("image");
      setState(() {

      });
  }
  Future<Uint8List?> _loadImageData() async {
    String? img=await con.getImage(userSession?.userId);
    imageDataUint8 = base64Decode(img ?? '');

   // imageDataUint8=await con.getImageFromAPI(token!, id ?? '');
    //GetStorage().write('image',Uint8List.fromList(image.map((element) => element).toList()));
    return imageDataUint8;//GetStorage().read('image');
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          ClipPath(
      clipper: MyCustomClipper(),
      child: Container(
        color: mainColorBlue,
        height: 300.0,
      ),
      ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                20.height,
                Container(
                  height: 126,
                  width: 126,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 5.0,
                    ),
                  ),child:GestureDetector(
    onTap: () {
    showAlertDialogImage(context);
    },child:
              ClipOval(
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration:  const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: imageFile != null
                        ? Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    )
                        : FutureBuilder<Uint8List?>(
                      future: _loadImageData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Muestra un indicador de carga mientras se carga la imagen
                        } else if (snapshot.hasError) {
                          return Image.asset(
                            "images/defaultImage.png",
                            color: mainColorBlue,
                          );
                        } else if (snapshot.hasData) {
                          return Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          );
                        } else {
                          return Image.asset(
                            "images/defaultImage.png",
                            color: mainGreenColorButton,
                          );
                        }
                      },
                    ),
                  ),
                ),
                ),
                ),

                Column(
                  children: [
                    10.height,
                    Text(userSession?.userName ?? '',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    50.height,
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

  void showAlertDialogImage(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(36),
          bottomLeft: Radius.circular(36),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Selecciona una opción", style: TextStyle(fontSize: 18)),
          16.height,
          const Text(
              "Elige la opción que prefieras para cambiar tu imagen de perfil",
              style: TextStyle(fontSize: 15)),
          16.height,
        ],
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(mainColorBlue),
            // Color de fondo del botón
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Radio de los bordes
              ),
            ),
          ),
          onPressed: () {
            Get.back();
            selectImage(ImageSource.gallery);
          },
          child: const Text("Galeria",style: TextStyle(fontSize: 18,color: Colors.white)),
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(mainGreenColorButton),
            // Color de fondo del botón
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Radio de los bordes
              ),
            ),
          ),
          child: const Text("Camara", style: TextStyle(fontSize: 18,color: Colors.white)),
          onPressed: () {
            Get.back();
            selectImage(ImageSource.camera);
          },
        ),
        5.width,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  Future selectImage(ImageSource imageSource) async {
    XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
        GetStorage().write("image", imageFile);
        UserProvider().updateImage(userSession?.userId, imageFile);
      });
    }
  }

}
