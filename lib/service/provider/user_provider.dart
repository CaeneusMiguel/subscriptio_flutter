import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/service/enviroment/enviroment.dart';

class UserProvider extends GetConnect {
  String url = Environment.apiUrl;
  String? token = GetStorage().read('token');

  Future<Response> login(String email, String pass) async {

    Response response = await post(
        '$url/login_check', {'_username': email, '_password': pass},
    contentType:'application/x-www-form-urlencoded'
    );


    if (response.body['data'] == null) {

      //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }


    return response;
  }

  Future<Response> updatePassword(String? id,String password, String rePassword) async {
      Response response = await post(
          '$url/user/change-password',{
        "user_id": id,
        "password": password,
        "re_password":  rePassword

      },
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          }
      );


      if (response.body== null) {

        //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
        return response;
      }

      return response;
    }
}