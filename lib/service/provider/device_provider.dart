import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/service/enviroment/enviroment.dart';




class DeviceProvider extends GetConnect {

  String url = Environment.apiUrl;
  String? token = GetStorage().read('token');


  Future<void> postTokenFireBase(String tokenFireBase) async {
    Response response = await post('$url/user/update-fcm-token',
        {
          "fcm_token": tokenFireBase,

        },
        headers: {'Authorization': 'Bearer $token','Content-Type': 'application/json'});


    if(response.hasError==401){
      Get.snackbar('Error', 'error al actualizar FCM',backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
      GetStorage().erase();
      Get.offNamedUntil('/login', (route) => false);
    }

    //log("hola"+response.body.toString());

  }


}