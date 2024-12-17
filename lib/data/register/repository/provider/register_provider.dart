import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/config/enviroment/enviroment.dart';

class RegisterProvider extends GetConnect {
  String url = Environment.apiUrl;
  String? token = GetStorage().read('token');
  Future<Response> register(
      String email,
      String password,
      String companyName,
      String cifnif,
      String nameUser,
      String telephone,
      String town,
      String province,
      String country,
      String re_password,
      String surnames,
      String pinCode,
      String code,
      String username) async {

    Response response = await post(
        '$url/admin/register',
        {
          'companyName': companyName,
          'cifnif': cifnif,
          'email': email,
          'name': nameUser,
          'telephone1': telephone,
          'town': town,
          'province': province,
          'country': country,
          'password': password,
          're_password': re_password,
          'surnames': surnames,
          'pinCode': pinCode,
          'code': code,
          'username': username
        },
        contentType: 'application/x-www-form-urlencoded');


    if (response.body['data'] == null) {

      //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }


    return response;
  }
}
