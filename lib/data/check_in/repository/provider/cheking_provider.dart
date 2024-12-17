import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/config/enviroment/enviroment.dart';
import 'package:subcript/ui/theme/colors.dart';

class ChekingProvider extends GetConnect {
  String url = Environment.apiUrl;
  String? token = GetStorage().read('token');

  Future<Response> cheking(double? lat, double? long, String? comment) async {
    Response response = await post('$url/timerecord/record', {
      "latitude": lat,
      "longitude": long,
      "comment": comment
    }, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    });

    if (response.body['data'] == null) {
      //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }

    return response;
  }

  Future<Response> pause(int? id_purpose) async {
    Response response = await post('$url/timerecord/BreakTime', {
      "purpose_id": id_purpose
    }, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    });
    if (response.body['data'] == null) {
      //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }

    return response;
  }

  Future<Response> getPurpose() async {
    Response response = await post('$url/timerecord/getPurposeCompany', {},
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        });

    if (response.body['data'] == null) {
      //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }

    return response;
  }

  Future<Response> getIsCheking() async {
    Response response = await post('$url/timerecord/is-checkin', {}, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    });

    if (response.body['data'] == null) {
      //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }

    return response;
  }

  Future<Response> getIsBreakIn() async {
    Response response = await post('$url/timerecord/is-breakin', {}, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    });

    if (response.body['data'] == null) {
      //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }

    return response;
  }

  Future<Response> getListCheking(int page, int? month, int? year) async {
    Response response = await post('$url/timerecord/getAppTimeRecord', {
      "page": page,
      "limit": 30,
      "monthNumber": month,
      "yearNumber": year
    }, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    });

    if (response.body == null) {
      //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }

    return response;
  }

  Future<Response> checkInCheckOut(String? pin, String userName) async {
    Response response = await post('$url/timerecord/checkin-checkout', {
      "username": userName,
      "pin_code": pin,
    }, headers: {
      'Content-Type': 'application/json'
    });

    if (response.body == null) {
      //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }

    return response;
  }

  Future<int> checkInCheckOutPause(String? pin, String? userName, int? purpose, bool? app_confirm) async {
    Response response = await post('$url/break_time_record/checkin-checkout', {
      "username": userName,
      "pin_code": pin,
      "purpose": purpose,
      "app_confirm":app_confirm
    }, headers: {
      'Content-Type': 'application/json'
    });

    if (response.body['success'] == true) {

        Get.snackbar(
            'Pausa', response.body['message'],
            backgroundColor: mainGreenColorButton, colorText: Colors.white);

      return 0;
    }else{
      if(response.body['data']==1){

        return response.body['data'];

      }else{
        Get.snackbar(
            'Pausa', response.body['message'],
            backgroundColor: redColorButton, colorText: Colors.white);

        return 0;

      }


    }


  }

  Future<Response> listPausePurposeHub(String? cif) async {
    Response response = await post('$url/company/get-break-types/$cif',{}, headers: {
      'Content-Type': 'application/json'
    });


    return response;
  }
}
