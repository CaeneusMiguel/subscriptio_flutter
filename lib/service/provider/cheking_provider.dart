import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/service/enviroment/enviroment.dart';

class ChekingProvider extends GetConnect {
  String url = Environment.apiUrl;
  String? token = GetStorage().read('token');

  Future<Response> cheking() async {

    Response response = await post(
        '$url/timerecord/record', {},
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        }
    );

    if (response.body['data'] == null) {
      //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }

    print("${response.body}");


    return response;
  }

  Future<Response> getIsCheking() async {

    Response response = await post(
        '$url/timerecord/is-checkin', {},
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        }
    );

    if (response.body['data'] == null) {
      Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }

    print("hola ${response.body}");


    return response;
  }
}