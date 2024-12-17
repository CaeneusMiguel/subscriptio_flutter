import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:subcript/data/auth/model/userLogin.dart';
import 'package:subcript/data/auth/repository/provider/user_provider.dart';
import 'package:subcript/data/document/repository/controller/document_controller.dart';
import 'package:subcript/ui/features/common/widgets/customAlertDialogInfo.dart';
import 'package:subcript/ui/features/common/widgets/my_custom_Clipper.dart';
import 'package:subcript/ui/features/profile/screens/change_password_screen_user_page.dart';
import 'package:subcript/ui/features/profile/screens/change_pin_page.dart';
import 'package:subcript/ui/theme/colors.dart';

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
  double? latitude;
  double? longitude;
  Location location = Location();
  DocumentController con = Get.put(DocumentController());
  ValueNotifier<dynamic> result = ValueNotifier(null);
  static const platform = MethodChannel('com.example.app/nfc');

  @override
  void initState() {
    userSession = UserLogin.fromJson(GetStorage().read('user'));
    _loaddata();
    //startListeningForTags();
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      // Cambia el color de fondo de la barra de estado
      statusBarIconBrightness:
          Brightness.light, // Cambia el color del texto en la barra de estado
    ));
  }

  static Future<void> startListeningForTags() async {
    platform.setMethodCallHandler((MethodCall call) async {
      if (call.method == "onTagDetected") {
        String tagId = call.arguments as String;
        // Maneja la etiqueta aquí, como abrir una pantalla específica
      }
    });
  }

  Future<Uint8List?> _loaddata() async {
    // await UserProvider().getData(token).then((value) {
    //  code = UserClassFull.fromJson(GetStorage().read('userProfile') ?? {});
    imageFile ??= GetStorage().read("image");
    setState(() {});
  }

  Future<File> convertUint8ListToFile(
      Uint8List uint8List, String fileName) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    File file = File('$tempPath/$fileName');
    await file.writeAsBytes(uint8List);

    return file;
  }

  Future<File?> _loadImageData() async {
    String? img = await con.getImage(userSession?.userId);
    imageDataUint8 = base64Decode(img ?? '');

    // imageDataUint8=await con.getImageFromAPI(token!, id ?? '');
    //GetStorage().write('image',Uint8List.fromList(image.map((element) => element).toList()));

    imageFile = await convertUint8ListToFile(imageDataUint8, 'imagen.jpg');

    return imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  ),
                  child: GestureDetector(
                    onTap: () {
                      showAlertDialogImage(context);
                    },
                    child: ClipOval(
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: imageFile != null
                            ? Image.file(
                                imageFile!,
                                fit: BoxFit.cover,
                              )
                            : FutureBuilder<File?>(
                                future: _loadImageData(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator(
                                      backgroundColor: mainColorBlue,
                                      strokeWidth: 10,
                                      color: Colors.white,
                                    );
                                  } else if (snapshot.hasError) {
                                    return Image.asset(
                                      "resources/defaultImage.png",
                                      color: mainGreenColorButton,
                                    );
                                  } else if (snapshot.hasData) {
                                    return Image.file(
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                    );
                                  } else {
                                    return Image.asset(
                                      "resources/defaultImage.png",
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
                    Text(
                      userSession?.userName ?? '',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
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
                                color: mainColorBlue, width: 1),
                            borderRadius: BorderRadius.circular(
                                8), // Esquinas redondeadas
                          ),
                        ),
                        onPressed: () {
                          const ChangePasswordScreenUser().launch(context);
                        },
                        child: const Text(
                          'Modificar Contraseña',
                          style: TextStyle(fontSize: 16),
                        ),
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
                        onPressed: () {
                          const ChangePinPage().launch(context);
                        },
                        child: const Text(
                          'Modificar Pin',
                          style: TextStyle(fontSize: 16),
                        ),
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
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialogInfo(
                              activeCancel: true,
                              title: "Eliminar cuenta",
                              message:
                                  "Desea enviar una solicitud para eliminar su cuenta?. Su cuenta sera eliminada en un plazo de 24-48 horas.",
                              onConfirm: () {
                                Get.offNamedUntil('/', (route) => false);
                              },
                              onCancel: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        },
                        child: const Text(
                          'Eliminar Cuenta',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    /*10.height,

                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: mainColorBlue,
                          elevation: 2,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                           _ndefWrite();
                          //await startNfcSession(context);
                        },
                        child: const Text('Crear tarjeta NFC', style: TextStyle(fontSize: 16)),
                      ),
                    ),*/

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
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialogInfo(
                              activeCancel: true,
                              title: "Cerrar sesión",
                              message:
                                  "Se va a cerrar sesión, estas seguro que deseas cerrarla?. ",
                              onConfirm: () {
                                GetStorage().erase();
                                Get.offNamedUntil('/', (route) => false);
                              },
                              onCancel: () {
                                finish(context);
                              },
                            ),
                          );
                        },
                        child: const Text(
                          'Cerrar Sesión',
                          style: TextStyle(fontSize: 16),
                        ),
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
      surfaceTintColor: Colors.white,
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
          const Text("Cambiar imagen de perfil",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            backgroundColor: WidgetStateProperty.all<Color>(mainColorBlue),
            // Color de fondo del botón
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Radio de los bordes
              ),
            ),
          ),
          onPressed: () {
            Get.back();
            selectImage(ImageSource.gallery);
          },
          child: const Text("Galeria",
              style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all<Color>(mainGreenColorButton),
            // Color de fondo del botón
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Radio de los bordes
              ),
            ),
          ),
          child: const Text("Camara",
              style: TextStyle(fontSize: 18, color: Colors.white)),
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

    List<String>? parts = image?.name.split('.');

    String fileExtension = parts!.last;

    //image.path
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
        GetStorage().write("image", imageFile);
        UserProvider()
            .updateImage(userSession?.userId, imageFile, fileExtension);
      });
    }
  }


}
