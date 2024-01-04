import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/service/enviroment/enviroment.dart';
import 'package:subcript/service/models/listCheking.dart';
import 'package:subcript/service/provider/cheking_provider.dart';
import 'package:subcript/service/provider/user_provider.dart';

class ChekingController extends GetxController {

  String url = Environment.apiUrl;

  cheking() async {

    Response responseApi= await ChekingProvider().cheking();

    if(responseApi.body['data']!=null){


      Get.snackbar('Cheking', responseApi.body['message'] ,
          backgroundColor: const Color(0xFF00dba2a), colorText: Colors.white);

    } else {
      Get.snackbar('Error', 'Error durante el cheking' ,
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);

    }
  }

  Future<Response> getIsCheking() async {

    Response responseApi= await ChekingProvider().getIsCheking();

    if(responseApi.body['data']!=null){
      GetStorage().write('statusCheking',responseApi.body['data']['isCheckIn']);
      return responseApi;
    } else {
      Get.snackbar('Error', 'Token expirado,reiniciando' ,
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
      Get.offNamedUntil('/', (route) => false);
      return Response();
    }
  }


  Future<List<ListCheking>> chekingList() async {

    Response responseApi= await ChekingProvider().getListCheking();

    if(responseApi.body!=null){


      List<ListCheking>listCheking = ListCheking.fromJsonList(responseApi.body['data']);
      print(responseApi.body['data'].toString());
      return listCheking;
    } else {
      Get.snackbar('Error', 'Token expirado,reiniciando' ,
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
      Get.offNamedUntil('/', (route) => false);
      return [];
    }
  }




}
