import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/service/enviroment/enviroment.dart';

class DocumentProvider extends GetConnect {
  String url = Environment.apiUrl;
  String url2 = Environment.apiUrl2;
  String? token = GetStorage().read('token');

  Future<Response> getListDocument(String? id,int page,int? month,int? year) async {

    Response response = await post(
        '$url/payroll/listar-payroll/$id',{"monthNumber":month,"yearNumber":year,"page":page,"limit":20},
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

  Future<Uint8List> getDownloadDocument(int id) async {


    final response = await http.get(
        Uri.parse('$url/payroll/download-pdf/$id'),headers: {"Authorization": "Bearer $token"});


    if (response.statusCode == 200) {

      Map<String, dynamic> jsonResponse = json.decode(response.body);
      String base64String = jsonResponse['data'];

      Uint8List document = base64.decode(base64String);

      return document; // Devuelve la imagen como Uint8List
    }else{
      throw Exception('Error al obtener la imagen');// Manejo de errores en caso de respuesta no exitosa
    }


  }


    Future<Response> getDownloadImg(String? id_user) async {

      Response response = await post(
          '$url/user/getImage',{"user_id":id_user},
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          }
      );


      if (response.body["data"]== null) {

        Get.snackbar('Error', 'No se pudo recuperar la imagen');
        return response;
      }

      return response;
    }
}