
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subcript/config/enviroment/enviroment.dart';
import 'package:subcript/data/document/model/document.dart';
import 'package:subcript/data/document/repository/provider/document_provider.dart';

class DocumentController extends GetxController {

  String url = Environment.apiUrl;

  documentDownload() async {

    /*Response responseApi= await ChekingProvider().cheking();

    if(responseApi.body['data']!=null){


      Get.snackbar('Cheking', responseApi.body['message'] ,
          backgroundColor: const Color(0xFF00dba2a), colorText: Colors.white);

    } else {
      Get.snackbar('Error', 'Error durante el cheking' ,
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
    }*/
  }

  Future<List<Document>> documentList(String? id,int page,int? month,int? year) async {

    Response responseApi= await DocumentProvider().getListDocument(id,page,month,year);

    if(responseApi.body!=null){

      List<Document>listdocument = Document.fromJsonList(responseApi.body['data']);
      return listdocument;
    } else {
      Get.snackbar('Error', 'Sesión expirada,reiniciando' ,
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
      Get.offNamedUntil('/', (route) => false);
      return [];
    }
  }


  Future<String?> getImage(String? id_user) async {

    Response responseApi= await DocumentProvider().getDownloadImg(id_user);

    if(responseApi.body!=null){

      String? img = responseApi.body['data'];
      return img;
    } else {
      Get.snackbar('Error', 'Sesión expirada,reiniciando' ,
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
      Get.offNamedUntil('/', (route) => false);
      return "";
    }
  }

}
