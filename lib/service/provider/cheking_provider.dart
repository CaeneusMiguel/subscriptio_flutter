import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/service/enviroment/enviroment.dart';

class ChekingProvider extends GetConnect {
  String url = Environment.apiUrl;
  String? token = GetStorage().read('token');

  Future<Response> cheking(double? lat,double? long) async {

    Response response = await post(
        '$url/timerecord/record', {"latitude":lat,"longitude":long},
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

  Future<Response> pause(int? id_purpose) async {

    Response response = await post(
        '$url/timerecord/BreakTime', {"purpose_id":id_purpose},
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


  Future<Response> getPurpose() async {

    Response response = await post(
        '$url/timerecord/getPurposeCompany', {},
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



    return response;
  }

  Future<Response> getIsBreakIn() async {

    Response response = await post(
        '$url/timerecord/is-breakin', {},
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        }
    );

    if (response.body['data'] == null) {
      Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }



    return response;
  }

  Future<Response> getListCheking(int page,int? month,int? year) async {

    Response response = await post(
        '$url/timerecord/getAppTimeRecord',{"page":page,"limit":30,"monthNumber":month,"yearNumber":year},
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        }
    );


    if (response.body== null) {

      Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }


    return response;
  }
}