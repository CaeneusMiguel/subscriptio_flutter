import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:subcript/service/enviroment/enviroment.dart';
import 'package:subcript/service/models/holidaysData.dart';
import 'package:subcript/service/models/userLogin.dart';
import 'package:subcript/service/provider/holidays_provider.dart';
import 'package:subcript/utils/colors.dart';

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
    } else {
      Get.snackbar('Error', 'Error al obtener la lista de vacaciones',
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
      return [];
    }
  }

  Future<void> requestHolidays(BuildContext context) async {
    userSession = UserLogin.fromJson(GetStorage().read('user'));
    String? message = petition_comment.text.trim();
    DateTime date1 = DateFormat('dd/MM/yyyy').parse(startHolidays);
    DateTime date2 = DateFormat('dd/MM/yyyy').parse(endHolidays);
    DateTime currentDate = DateTime.now();

    bool isDate1BeforeDate2 = date2.isBefore(date1);
    bool areDatesEqual = date1.isAtSameMomentAs(date2);

    bool isDate1BeforeCurrentDate = date1.isBefore(currentDate);
    bool isDate2BeforeCurrentDate = date2.isBefore(currentDate);


    if (isDate1BeforeDate2 == false) {
      if (areDatesEqual == true) {
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
          Get.snackbar('Error', 'Error al solicitar el periodo de vacaciones',
              backgroundColor: const Color(0xFFe5133d),
              colorText: Colors.white);
        }
      } else {
        if (isDate1BeforeCurrentDate == false || isDate2BeforeCurrentDate == false) {
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
            Get.snackbar('Error', 'Error al solicitar el periodo de vacaciones',
                backgroundColor: const Color(0xFFe5133d),
                colorText: Colors.white);
          }
        } else {
          Get.snackbar('Error', 'Rango de fechas anterior a la fecha actual',
              backgroundColor: const Color(0xFFe5133d),
              colorText: Colors.white);
        }
      }
    } else {
      Get.snackbar(
          'Error', 'La fecha de finalización es previa a la fecha de inicio',
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
    }
  }
}
