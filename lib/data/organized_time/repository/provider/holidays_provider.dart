import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/config/enviroment/enviroment.dart';

class HolidaysProvider extends GetConnect {
  String url = Environment.apiUrl;
  String? token = GetStorage().read('token');

  Future<Response> getListHolidays(
      int page, String? status, String idUser) async {
    Response response = await post('$url/holidays/get', {
      "page": page,
      "maxResultPerPage": 20,
      "filters": {"user": idUser, "accepted": status}
    }, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    });

    if (response.body == null) {
     // Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }

    return response;
  }

  Future<Response> requestHolidays(String? message, String? idUser,
      int? companyId, String? startDate, String? endDate) async {
    Response response = await post('$url/holidays/create', {
      "user_id": idUser,
      "company_id": companyId,
      "start_date": startDate,
      "end_date": endDate,
      "petition_comment": message
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
}
