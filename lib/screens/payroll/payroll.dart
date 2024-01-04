import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:subcript/service/controller/document_controller.dart';
import 'package:subcript/service/models/document.dart';
import 'package:subcript/service/models/userLogin.dart';
import 'package:subcript/service/provider/document_provider.dart';
import 'package:subcript/utils/colors.dart';

class PayRoll extends StatefulWidget {
  const PayRoll({super.key});

  @override
  State<PayRoll> createState() => _PayRollState();
}

class _PayRollState extends State<PayRoll> {

  List<Document?> payroll=[];
  UserLogin? userSession;

  DocumentController con = Get.put(DocumentController());
  @override
  void initState() {
    userSession = UserLogin.fromJson(GetStorage().read('user'));
    getlistPayRoll();
    super.initState();
  }
  getlistPayRoll() async {
    payroll=await con.documentList(userSession?.userId);
    payroll.forEach((nombre) {

    });
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: payroll.isEmpty ?const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text("No tienes ningún archivo",style: TextStyle(fontSize: 18),)),
        ],
      ):ListView.builder(
        itemCount: payroll.length, // Cambia esto al número deseado de tarjetas
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async {
              Uint8List document=await DocumentProvider().getDownloadDocument(payroll[index]!.file);
              final directorio_en_cache = await getTemporaryDirectory();
              final nameDirectory = 'facturas'; // Nombre del directorio
              final directory = Directory('${directorio_en_cache.path}/$nameDirectory');


              if (!(await directory.exists())) {
                await directory.create(recursive: true);

              }
              String nombreArchivo = payroll[index]!.nombre.replaceAll(' ', '_').replaceAll('/', '-');

              File documentPayrol = await File('${directory.path}/$nombreArchivo.pdf');
              documentPayrol.writeAsBytesSync(document);
              OpenFile.open(documentPayrol.path);
            },
            child: Card(
              elevation: 5.0,
              margin: const EdgeInsets.all(16.0),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(
                      Icons.description,
                      color: mainColorBlue,size: 40,
                    ),
                    title: Text(
                      payroll[index]!.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                   ListTile(
                    leading: const Icon(
                      Icons.description,
                      color: Colors.transparent,
                    ),
                    title: Text(
                     "${payroll[index]!.createDate.date}",
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ); // Cada elemento de la lista es una tarjeta
        },
      ),
    );
  }
}
