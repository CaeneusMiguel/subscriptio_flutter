import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/config/enviroment/enviroment.dart';
import 'package:subcript/data/auth/model/userLogin.dart';
import 'package:subcript/data/document/model/document.dart';
import 'package:http_parser/http_parser.dart';
import 'package:subcript/main.dart';
import 'package:subcript/ui/theme/colors.dart';

class DocumentProvider extends GetConnect {
  String url = Environment.apiUrl;
  //String url2 = Environment.apiUrl2;
  String? token = GetStorage().read('token');
  UserLogin? userSession;

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

  Future<List<Document>> signatureDocument(int payrollId,String img) async {

    Response response = await post(
        '$url/payroll/add-img-to-pdf',{"payroll_id":payrollId,"img":img},
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        }
    );

    print(response.body);
    List<Document>listdocument = Document.fromJsonList(response.body['data']);
    if (listdocument.isEmpty) {

      //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return [];
    }



    return listdocument;
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


  Future<void> uploadDocument(
      String? file,
      String type,
      int userId,
      int companyId,
      String name
      ) async {
/*
    if (profileImg != null) {
      String base64String = await imageToBase64(profileImg);*/

      Response response = await post(
          '$url/document/upload',{
        "file": file,
        //"img": base64String,
        "typeId": type,
        "userId": userId,
        "companyId": companyId,
        "name": name
      },
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          }
      );

      if (response.statusCode == 401) {
        Get.snackbar('Error', 'Usuario desactivado',
            backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
        GetStorage().erase();
        Get.offNamedUntil('/login', (route) => false);
      } else if (response.statusCode != 200) {
        //Get.snackbar('Error', 'No se pudo ejecutar la petición');

      }

    }

  Future<void> sendDocument(
      File? file,
      String typeId,
      String name,
      ) async {
    try {
      userSession = UserLogin.fromJson(GetStorage().read('user'));

      // Crear una solicitud Multipart
      var request = http.MultipartRequest('POST', Uri.parse('$url/document/upload'));

      // Adjuntar el archivo al cuerpo de la solicitud
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file!.path,
        ),
      );

      request.fields['typeId'] = typeId;
      request.fields['userId'] = userSession!.userId;
      request.fields['companyId'] = userSession!.companyId.toString();
      request.fields['name'] = name;

      request.headers['Authorization'] = 'Bearer $token';

      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);


      if (response.statusCode == 200) {
        Get.snackbar('Exito',
            'Documento subido con éxito',
            backgroundColor: mainGreenColorButton,
            colorText: Colors.white);
      } else {
        Get.snackbar('Error',
            'Error al subir el documento',
            backgroundColor: redColorButton,
            colorText: Colors.white);
            }
    } catch (e) {
     // print('Error al subir el documento: $e');
    }

  }

  Future<List<Map<String, String>>>  getListTypeDocument(int idCompany) async {

    Response response = await post(
        '$url/type-document/list',{
          "filter_filters": {
        'companyId': idCompany,
            'all': true
      }
    },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        }
    );



    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = response.body;

      // Verifica que la estructura sea la esperada
      if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
        List<dynamic> types = jsonResponse['data']['types'];

        // Crear una lista de mapas con id y name, asegurando que ambos sean String
        List<Map<String, String>> documentTypes = types.map((type) {
          return {
            'id': type['id'].toString(), // Asegura que sea String
            'name': type['name'].toString(), // Asegura que sea String
          };
        }).toList();

        return documentTypes;
      } else {
        throw Exception('Error: No se encontraron datos válidos en la respuesta.');
      }
    } else {
      throw Exception('Error al obtener los tipos de documentos: ${response.statusCode}');
    }


  }


    Future<Response> getDownloadImg(String? id_user) async {

      Response response = await post(
          '$url/user/get-image',{"user_id":id_user},
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          }
      );


      if (response.body["data"]== null) {

        //Get.snackbar('Error', 'No se pudo recuperar la imagen');
        return response;
      }

      return response;
    }
}
