import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/service/enviroment/enviroment.dart';

class UserProvider extends GetConnect {
  String url = Environment.apiUrl;
  String? token = GetStorage().read('token');

  Future<Response> login(String email, String pass) async {

    Response response = await post(
        '$url/login_check', {'_username': email, '_password': pass},
    contentType:'application/x-www-form-urlencoded'
    );


    if (response.body['data'] == null) {

      //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }


    return response;
  }

  Future<Response> validatorCheckin(double? lat_user,double? long_user) async {

    lat_user ??= 0.0;
    long_user ??= 0.0;

    Response response = await post(
        '$url/user/validationLocation', {"lat_user":lat_user,"long_user":long_user,},
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        }
    );

    if (response.body['data'] == null) {
      //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }



    return response;
  }



  Future<Response> getConfigCompany() async {
    Response response = await post(
        '$url/user/getConfig',{},
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        }
    );

    if (response.body== null) {
      //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }
    return response;
  }

  Future<Response> updatePassword(String? id,String password, String rePassword) async {
      Response response = await post(
          '$url/user/change-password',{
        "user_id": id,
        "password": password,
        "re_password":  rePassword

      },
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          }
      );


      if (response.body== null) {

        //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
        return response;
      }

      return response;
    }

  Future<void> updateImage(
      String? id_user,
      File? profileImg,
      ) async {

    if (profileImg != null) {
      String base64String = await imageToBase64(profileImg);

      Response response = await post(
          '$url/user/change-image',{
        "user_id": id_user,
        "img": base64String
      },
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          }
      );

      if (response.statusCode == 401) {
        Get.snackbar('Error', 'Usuario desactivado',
            backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
        GetStorage().erase();
        Get.offNamedUntil('/login', (route) => false);
      } else if (response.statusCode != 200) {
        Get.snackbar('Error', 'No se pudo ejecutar la petición');

      }

    }

  }

  Future<String> imageToBase64(File filePath) async {
    try {
      // Lee el archivo de imagen como bytes
      List<int> imageBytes = await filePath.readAsBytes();

      // Convierte los bytes a una cadena base64
      String base64String = base64Encode(Uint8List.fromList(imageBytes));

      return base64String;
    } catch (e) {

      return "";
    }
  }
}