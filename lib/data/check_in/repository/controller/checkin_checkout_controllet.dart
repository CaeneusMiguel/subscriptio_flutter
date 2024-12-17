import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/data/check_in/model/purpose.dart';
import 'package:subcript/data/check_in/repository/provider/cheking_provider.dart';
import 'package:subcript/ui/theme/colors.dart';


class ChekingCheckoutController extends GetxController {

  TextEditingController userController = TextEditingController();
  TextEditingController cifController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();


  Future<List<Purpose>> pausePurposeList() async {
    String userName= userController.text.trim();
    String? cif = GetStorage().read('CifHub');
    Response responseApi = await ChekingProvider().listPausePurposeHub(cif);


    if (responseApi.body['data'] != null) {
      List<Purpose> listPurpose =
      Purpose.fromJsonList(responseApi.body['data']);
      return listPurpose;

    } else {


      return [];
    }
  }

  Future<void> chekingCheckout() async {
    String userName= cifController.text.trim();
    String pin= pinController.text.trim();
    Response responseApi =
    await ChekingProvider().checkInCheckOut(pin, userName);

    if (responseApi.body != null) {
      Get.snackbar(
          'Fichar', responseApi.body['message'],
          backgroundColor: mainGreenColorButton, colorText: Colors.white);
    } else {
      Get.snackbar('Error', 'Sesión expirada,reiniciando',
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
      Get.offNamedUntil('/', (route) => false);

    }
  }
}
