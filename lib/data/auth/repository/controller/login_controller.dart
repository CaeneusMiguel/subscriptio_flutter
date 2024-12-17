import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/config/enviroment/enviroment.dart';
import 'package:subcript/data/auth/repository/provider/user_provider.dart';
import 'package:subcript/data/common/repository/provider/device_provider.dart';
import 'package:subcript/data/common/repository/provider/firebase_api.dart';


class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String url = Environment.apiUrl;

  login(String? tokenFireBase) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    Response responseApi = await UserProvider().login(email, password);

    if (responseApi.body['data'] != null) {
      //log(responseApi.body['token']);
      String token = responseApi.body['data']['token'];
      //log("${responseApi.body['user']}");

      GetStorage().write(
          'user',
          responseApi.body[
              'data']); // Actualiza la información del usuario en GetStorage
      GetStorage().write('token', token).then((value) async {
        await FirebaseApi().initNotifications();
        print(tokenFireBase);
        DeviceProvider().postTokenFireBase(tokenFireBase ?? '');
      });

      emailController.text = "";
      passwordController.text = "";

      Get.toNamed('/dashboard');
    } else {
      Get.snackbar('Login fallido', 'Error en las credenciales',
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
    }
  }
}
