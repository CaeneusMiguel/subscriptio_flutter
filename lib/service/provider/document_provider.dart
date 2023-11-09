import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/service/enviroment/enviroment.dart';

class DocumentProvider extends GetConnect {
  String url = Environment.apiUrl;
  String url2 = Environment.apiUrl2;
  String? token = GetStorage().read('token');

  Future<Response> getListDocument(String? id) async {
    print("entra en el login provider");
    Response response = await get(
        '$url/listar-payroll/$id',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        }
    );


    if (response.body== null) {
      print("hola");
      //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }

    print("${response.body}");


    return response;
  }

  Future<Uint8List> getDownloadDocument(String id) async {
    print(id);

    final response = await http.get(
        Uri.parse('$url2/download-pdf/$id'),headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      print("hola");
      List<dynamic> image = response.bodyBytes;
      Uint8List document = Uint8List.fromList(
          image.map((element) => element as int).toList());
      //GetStorage().write('image', imageData);
      //log(response.body);

      print(document);
      return document; // Devuelve la imagen como Uint8List
    }else{
      throw Exception('Error al obtener la imagen');// Manejo de errores en caso de respuesta no exitosa
    }


  }
}