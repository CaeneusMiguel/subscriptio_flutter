import 'package:get/get.dart';
import 'package:subcript/service/enviroment/enviroment.dart';

class UserProvider extends GetConnect {
  String url = Environment.apiUrl;


  Future<Response> login(String email, String pass) async {
    print("entra en el login provider");
    Response response = await post(
        '$url/login_check', {'_username': email, '_password': pass},
    contentType:'application/x-www-form-urlencoded'
    );

    print("${response.body}");
    if (response.body['data'] == null) {
      print("hola");
      //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }

    print("${response.body}");


    return response;
  }
}