import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/config/enviroment/enviroment.dart';
import 'package:subcript/data/auth/model/companyConfi.dart';
import 'package:subcript/data/auth/repository/provider/user_provider.dart';
import 'package:subcript/data/check_in/model/listCheking.dart';
import 'package:subcript/data/check_in/model/purpose.dart';
import 'package:subcript/data/check_in/repository/provider/cheking_provider.dart';
import 'package:subcript/ui/theme/colors.dart';


class ChekingController extends GetxController {
  String url = Environment.apiUrl;

  cheking(double? lat,double? long,String? comment) async {
    Response responseApi = await ChekingProvider().cheking(lat,long,comment);

    if (responseApi.body['data'] != null) {
      /*Get.snackbar(
        "Checkin",
        responseApi.body['message'],
        backgroundColor: greenColorButton,
        colorText: Colors.white,
      );*/
    } else {
      Get.snackbar('Error', 'Error durante el cheking',
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
    }
  }

  Future<CompanyConfi> getConfigCompany() async {
    Response responseApi = await UserProvider().getConfigCompany();
    CompanyConfi config;
    config = CompanyConfi.fromJson(responseApi.body['data']);
    return config;
  }

   Future<Response> pause(int? purpose_id) async {
    Response responseApi = await ChekingProvider().pause(purpose_id);

    if (responseApi.body['data']['id'] == null) {
     Get.snackbar('Error', 'Ha ocurrido un error al generar la pausa.',
          backgroundColor: orangeColorButton, colorText: Colors.white);
    }



    return responseApi;
  }

  Future<bool> validatorCheckin(double? lat_user, double? long_user) async {
    Response responseApi =
        await UserProvider().validatorCheckin(lat_user, long_user);
    bool check = responseApi.body['data'];


    return check;
  }

  Future<List<Purpose>> getPurposeList() async {
    Response responseApi = await ChekingProvider().getPurpose();

    if (responseApi.body['data'] != null) {
      List<Purpose> listPurpose =
          Purpose.fromJsonList(responseApi.body['data']);
      return listPurpose;
      /*Get.snackbar('Cheking', responseApi.body['message'] ,
          backgroundColor: const Color(0xFF00dba2a), colorText: Colors.white);*/
    }
      return [];

  }

  Future<Response> getIsCheking() async {
    Response responseApi = await ChekingProvider().getIsCheking();

    if (responseApi.body['data'] != null) {
      GetStorage()
          .write('statusCheking', responseApi.body['data']['isCheckIn']);
      return responseApi;
    } else {
      Get.snackbar('Error', 'Sesión expirada,reiniciando',
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
      Get.offNamedUntil('/', (route) => false);
      return Response();
    }
  }

  Future<Response> getIsBreakIn() async {
    Response responseApi = await ChekingProvider().getIsBreakIn();
    if (responseApi.body['data'] != null) {
      GetStorage()
          .write('statusBreakIn', responseApi.body['data']['isBreakIn']);
      return responseApi;
    } else {
      Get.snackbar('Error', 'Sesión expirada,reiniciando',
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
      Get.offNamedUntil('/', (route) => false);
      return Response();
    }
  }

  Future<List<ListCheking>> chekingList(int page, int? month, int? year) async {

    Response responseApi =
        await ChekingProvider().getListCheking(page, month, year);

    if (responseApi.body != null) {
      List<ListCheking> listCheking =
          ListCheking.fromJsonList(responseApi.body['data']['data_list']);

      return listCheking;
    } else {
      Get.snackbar('Error', 'Sesión expirada,reiniciando',
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
      Get.offNamedUntil('/', (route) => false);
      return [];
    }
  }
}
