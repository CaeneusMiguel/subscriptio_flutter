import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/data/auth/model/userLogin.dart';
import 'package:subcript/data/auth/repository/provider/user_provider.dart';
import 'package:subcript/ui/features/login/screens/login_page.dart';

class PasswordChangeController extends GetxController {

  String token = GetStorage().read('token');
  UserLogin? userSession;


  TextEditingController passWordController = TextEditingController();
  TextEditingController passWordRepController = TextEditingController();
  TextEditingController pinWordController = TextEditingController();
  TextEditingController pinWordRepController = TextEditingController();

  @override
  Future<void> onInit() async {
    userSession = UserLogin.fromJson(GetStorage().read('user'));

    super.onInit();
  }


  updatePasswordUser(BuildContext context) async {
    String newPassWord = passWordController.text.trim();
    String newPassWordRep = passWordRepController.text.trim();


    Response responseApi = await UserProvider()
        .updatePassword(userSession?.userId,newPassWord,newPassWordRep);


    if(responseApi.statusCode == 200){
      passWordController.text='';
      passWordRepController.text='';
      GetStorage().erase();
      const LoginScreen().launch(context);
        Get.snackbar(
            'Contraseña Actualizada ', 'Se ha actualizado su contraseña correctamente',
            backgroundColor: const Color(0xFF0a528a), colorText: Colors.white);
    } else {

      passWordController.text='';
      passWordRepController.text='';
      Get.snackbar('Error de actualización',  'No se ha podido actualizar la clave',
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
    }
  }

  updatePinUser(BuildContext context) async {
    String newPinWord = pinWordController.text.trim();
    String newPinWordRep = pinWordRepController.text.trim();


    Response responseApi = await UserProvider()
        .updatePin(userSession?.userId,newPinWord);

    print(responseApi.body);

    if(responseApi.statusCode == 200){
      pinWordController.text='';
      pinWordRepController.text='';
      finish(context);
      Get.snackbar(
          'Pin Actualizado', 'Se ha actualizado su pin correctamente',
          backgroundColor: const Color(0xFF0a528a), colorText: Colors.white);
    } else {

      pinWordController.text='';
      pinWordRepController.text='';
      Get.snackbar('Error de actualización',  'No se ha podido actualizar la clave',
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
    }
  }
}

