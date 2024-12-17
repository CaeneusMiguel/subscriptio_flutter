import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:subcript/config/enviroment/enviroment.dart';
import 'package:subcript/data/auth/model/userLogin.dart';
import 'package:subcript/data/organized_time/model/holidaysData.dart';
import 'package:subcript/data/organized_time/repository/provider/holidays_provider.dart';
import 'package:subcript/ui/theme/colors.dart';

class HolidaysController extends GetxController {
  String url = Environment.apiUrl;
  UserLogin? userSession;
  String startHolidays = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String endHolidays = DateFormat('dd/MM/yyyy').format(DateTime.now());

  TextEditingController petition_comment = TextEditingController();

  Future<List<HolidaysData>> getHolidaysList(
      int page, String? status, String id_user) async {
    Response responseApi =
        await HolidaysProvider().getListHolidays(page, status, id_user);

    if (responseApi.body['data'] != null) {
      List<HolidaysData> listHolidays =
          HolidaysData.fromJsonList(responseApi.body['data'][0]);
      return listHolidays;
    }
      return [];

  }

  Future<void> requestHolidays(BuildContext context) async {
    userSession = UserLogin.fromJson(GetStorage().read('user'));
    String? message = petition_comment.text.trim();

    Response responseApi = await HolidaysProvider().requestHolidays(
        message,
        userSession?.userId,
        userSession?.companyId,
        startHolidays,
        endHolidays);

    if (responseApi.body['data'] != null) {
      Get.snackbar(
        "Solicitud",
        responseApi.body['message'],
        backgroundColor: greenColorButton,
        colorText: Colors.white,
      );

      Navigator.pop(context);
    } else {
      Get.snackbar('Error',  responseApi.body['message'],
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
    }
  }
}
