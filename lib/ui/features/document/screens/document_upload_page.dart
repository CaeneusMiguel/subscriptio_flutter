import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:subcript/data/auth/model/userLogin.dart';
import 'package:subcript/data/document/repository/provider/document_provider.dart';
import 'package:subcript/ui/theme/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';


class DocumentUploadPage extends StatefulWidget {
  const DocumentUploadPage({super.key});

  @override
  State<DocumentUploadPage> createState() => _DocumentUploadPageState();
}

class _DocumentUploadPageState extends State<DocumentUploadPage> {
  final TextEditingController _nameController = TextEditingController();
  List<Map<String, String>> _documentTypes=[];
  String? _selectedDocumentType;
  UserLogin? userSession;
  FilePickerResult? pickerDocument;
  File? imageFile;
  File? fileDocument;
  PlatformFile? pickedFile;
  String? fileName;
  ImagePicker pickerImage = ImagePicker();
  String? extension;
  bool _isSubmitAttempted = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getListTypeDocument();
  }

  Future<void> getListTypeDocument() async {
    userSession = UserLogin.fromJson(GetStorage().read('user'));

    _documentTypes=await DocumentProvider().getListTypeDocument(userSession!.companyId!);
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  20.height,
                  const Text(
                    'Subir Documento',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ).paddingSymmetric(horizontal: 0).center(),
                  46.height,

                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(30, 18, 18, 18),
                      labelText: 'Nombre del documento',
                      labelStyle: TextStyle(color: Colors.black),
                      focusColor: mainColorBlue,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(36),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(36),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(36),
                        borderSide: const BorderSide(
                            color: mainColorBlue, width: 2),
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Necesita introducir un nombre';
                      }
                      return null;
                    },
                  ),
                  20.height,
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: _selectedDocumentType,
                    items: _documentTypes.map((Map<String, String> type) {
                      return DropdownMenuItem<String>(
                        value: type['id'],
                        child: Text(type['name'] ?? ''),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedDocumentType = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.black54),
                      label: const Text('Tipo de documento',
                          style: TextStyle(fontFamily: 'Vagrounded')),
                      contentPadding: const EdgeInsets.fromLTRB(30, 18, 18, 18),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(36),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(36),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(36),
                        borderSide: const BorderSide(
                            color: mainColorBlue, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Necesita seleccionar un tipo de documento';
                      }
                      return null;
                    },
                  ),
                  60.height,
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: mainColorBlue,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: mainColorBlue, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        selectFile();
                      },
                      child: const Text(
                        'Seleccionar Documento',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  20.height,
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: mainGreenColorButton,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: mainGreenColorButton, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        selectImage(ImageSource.camera);
                      },
                      child: const Text(
                        'Escanear documento',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  if (_isSubmitAttempted && fileDocument == null)
                    Column(
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          'Necesita seleccionar una imagen o documento',
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ],
                    ),
                  60.height,
                  // Vista previa del archivo seleccionado
                  if (fileDocument != null) ...[
                    fileDocument!.path.endsWith('.jpg') ||
                        fileDocument!.path.endsWith('.jpeg') ||
                        fileDocument!.path.endsWith('.png')
                        ? Image.file(
                      fileDocument!,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    )
                        : Icon(
                      Icons.insert_drive_file,
                      size: 150,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${fileDocument!.path.split('/').last}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ]
                ],
              ).paddingSymmetric(horizontal: 30),
            ),
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: mainColorBlue.withAlpha(70),
                borderRadius: BorderRadius.circular(100),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: mainColorBlue,
                borderRadius: BorderRadius.circular(100),
              ),
              child: IconButton(
                icon: const Icon(Icons.check, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _isSubmitAttempted = true; // Intento de envío
                  });

                  if (_formKey.currentState!.validate() &&
                      fileDocument != null) {
                    // Envía los datos
                    DocumentProvider().sendDocument(
                      fileDocument,
                      _selectedDocumentType!,
                      _nameController.text.trim(),
                    );

                    _nameController.clear();
                    fileDocument = null;
                    _selectedDocumentType = null;
                    _resetForm();

                  }
                },
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 30, vertical: 30),
      ),
    );
  }

  Future<void> selectImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();

    // Seleccionar la imagen con reducción de calidad
    final XFile? image = await _picker.pickImage(
      source: source,
      maxWidth: 1024, // Ancho máximo
      maxHeight: 1024, // Altura máxima
      imageQuality: 85, // Calidad en un rango de 0-100
    );

    if (image != null) {
      fileDocument = File(image.path);
      setState(() {});
    } else {
      //print("No se seleccionó ninguna imagen");
    }
  }
  void _resetForm() {
    _nameController.clear();
    fileDocument = null;
    _selectedDocumentType = null;
    _isSubmitAttempted = false;
    setState(() {});
  }


  Future selectFile() async {
    pickerDocument = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (pickerDocument != null) {
      fileName = pickerDocument?.files.first.name;
      pickedFile = pickerDocument?.files.first;
      fileDocument = File(pickedFile!.path.toString());
      setState(() {});

    }
  }


  void showAlertDialogImage(BuildContext context) {


    AlertDialog alertDialog = AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(36),
          bottomLeft: Radius.circular(36),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Seleccionar documento",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          const Text("Elige el documento que prefieras para subir:",
              style: TextStyle(fontSize: 15)),
          SizedBox(height: 16),
        ],
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(mainColorBlue),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          onPressed: () {

          },
          child: const Text("Documentos",
              style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(mainGreenColorButton),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          child: const Text("Cámara",
              style: TextStyle(fontSize: 18, color: Colors.white)),
          onPressed: () {
            Get.back();
            selectImage(ImageSource.camera); // Abre la cámara
          },
        ),
        SizedBox(width: 5),
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

}
