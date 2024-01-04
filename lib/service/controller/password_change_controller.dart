import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/service/models/userLogin.dart';
import 'package:subcript/service/provider/user_provider.dart';


class PasswordChangeController extends GetxController {

  String token = GetStorage().read('token');
  UserLogin? userSession;


  TextEditingController passWordController = TextEditingController();
  TextEditingController passWordRepController = TextEditingController();


  @override
  Future<void> onInit() async {
    userSession = UserLogin.fromJson(GetStorage().read('user'));

    super.onInit();
  }


  updatePasswordUser() async {
    String newPassWord = passWordController.text.trim();
    String newPassWordRep = passWordRepController.text.trim();

    print(newPassWord);
    print(newPassWordRep);

    print(userSession?.userId);
    Response responseApi = await UserProvider()
        .updatePassword(userSession?.userId,newPassWord,newPassWordRep);

    print('Response Api: ${responseApi.statusCode}');

    if(responseApi.statusCode == 200){
      GetStorage().erase();
        Get.snackbar(
            'Contraseña Actualizada ', 'Se ha actualizado su contraseña correctamente',
            backgroundColor: const Color(0xFF0a528a), colorText: Colors.white);
    } else {
      Get.snackbar('Error de actualización',  '',
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
    }
  }
}

