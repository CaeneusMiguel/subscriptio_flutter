import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'package:subcript/data/auth/model/userLogin.dart';
import 'package:subcript/data/document/model/document.dart';
import 'package:subcript/data/document/repository/controller/document_controller.dart';
import 'package:subcript/data/document/repository/provider/document_provider.dart';
import 'package:subcript/ui/features/document/screens/document_upload_page.dart';
import 'package:subcript/ui/theme/colors.dart';

class PayRoll extends StatefulWidget {
  const PayRoll({super.key});

  @override
  State<PayRoll> createState() => _PayRollState();
}

class _PayRollState extends State<PayRoll> {
  UserLogin? userSession;

  DocumentController con = Get.put(DocumentController());
  HawkFabMenuController hawkFabMenuController = HawkFabMenuController();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _hasMoreData = true;
  bool _isLoading = false;
  List<Map<String, dynamic>> transformedList = [];
  int month = DateTime.now().month;
  int year = DateTime.now().year;
  int? monthFinal;
  int? yearFinal;
  bool _dataCharged = false;
  int animationValue = 0;
  bool _isExpanded = false;

  @override
  void initState() {
    initializeDateFormatting('es', null);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _hasMoreData) {
        _getlistPayRoll();
      }
    });
    userSession = UserLogin.fromJson(GetStorage().read('user'));
    _getlistPayRoll();
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  _getlistPayRoll() async {
    if (_isLoading) return;
    try {
      setState(() {
        _isLoading = true;
      });

      List<Document> newDocuments = await con.documentList(
          userSession?.userId, _currentPage, monthFinal, yearFinal);
      if (newDocuments.isEmpty) {
        setState(() {
          _hasMoreData = false;
        });
        return;
      }

      _currentPage++;

      await _transformAndAddData(newDocuments);
    } finally {
      setState(() {
        _dataCharged = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _transformAndAddData(List<Document> newDocument) async {
    newDocument.forEach((document) {
      String formattedCreateDate =
          DateFormat('HH:mm').format(document.createDate.date);

      transformedList.add({
        'date': DateFormat('yyyy-MM-dd').format(document.createDate.date),
        'create_date': formattedCreateDate,
        'name': document.nombre,
        'file_path': document.file,
        'id_document': document.id,
        'status': document.isSigned ?? true,
        'widthsignature': document.width ?? true,
        'heightsignature': document.height ?? true
      });
    });
  }

  String formatSpanishDate(DateTime date) {
    final format = DateFormat('EEEE d MMMM y', 'es');
    String formattedDate = format.format(date);

    // Capitalizar la primera letra de cada palabra
    List<String> words = formattedDate.split(' ');
    for (int i = 0; i < words.length; i++) {
      words[i] = words[i][0].toUpperCase() + words[i].substring(1);
    }

    return words.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: _dataCharged == false
          ? Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  color: mainColorBlue.withOpacity(0.9),
                  strokeWidth: 10,
                ),
              ),
            )
          : transformedList.isEmpty
              ? const Center(
                  child: Text(
                    "No tienes ningun archivo disponible",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : SafeArea(
                top: true,
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 8),
                  child: RefreshIndicator(
                    color: mainColorBlue,
                    onRefresh: () async {
                      setState(() {
                        _currentPage = 1;
                        transformedList = [];
                        monthFinal = null;
                        yearFinal = null;
                      });
                      await _getlistPayRoll();
                    },
                    child:GroupedListView<dynamic, String>(
                      controller: _scrollController,
                      useStickyGroupSeparators: true,
                      elements: transformedList,
                      groupBy: (element) => element['date'],
                      groupSeparatorBuilder: (String value) {
                        animationValue = animationValue + 100;

                        Widget separatorWidget = Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: mainColorBlue,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey, // Color de la sombra
                                  spreadRadius:
                                      0, // Radio de expansión de la sombra
                                  blurRadius: 3, // Desenfoque de la sombra
                                  offset: Offset(0,
                                      3), // Desplazamiento de la sombra (horizontal, vertical)
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  formatSpanishDate(DateTime.parse(value)),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                        if (animationValue < 700) {
                          // Si se cumple la condición, aplicar la animación
                          separatorWidget = separatorWidget
                              .animate()
                              .fade(duration: animationValue.ms)
                              .slideY();
                        }
                        return separatorWidget;
                      },
                      itemBuilder: (context, dynamic element) {
                        Widget cardWidget = Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10.0, left: 16, right: 16),
                          child: Card(
                            elevation: 3,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ClipPath(
                              clipper: ShapeBorderClipper(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(3))),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    left: BorderSide(
                                        color: element['status']
                                            ? mainColorBlue.withOpacity(0.9)
                                            : orangeColorButton,
                                        width: 6),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0, bottom: 16.0, right: 10.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: Image.asset(
                                            "resources/doc.png",
                                            height: 50),
                                        title: Text(
                                          element['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            "${DateFormat('dd-MM-yyyy').format(DateTime.parse(element['date']))}  ${element['create_date']}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12.0,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        trailing: Container(
                                          width: 46,
                                          height: 46,
                                          child: GestureDetector(
                                            onTap: () async {
                                              Uint8List document =
                                                  await DocumentProvider()
                                                      .getDownloadDocument(
                                                          element[
                                                              'id_document']);
                                              final directorioEnCache =
                                                  await getTemporaryDirectory();
                                              const nameDirectory =
                                                  'documentos';
                                              final directory = Directory(
                                                  '${directorioEnCache.path}/$nameDirectory');

                                              if (!(await directory
                                                  .exists())) {
                                                await directory.create(
                                                    recursive: true);
                                              }
                                              String nombreArchivo =
                                                  element['name']
                                                      .replaceAll(' ', '_')
                                                      .replaceAll('/', '-');
                                              File documentPayrol = await File(
                                                  '${directory.path}/$nombreArchivo.pdf');
                                              documentPayrol
                                                  .writeAsBytesSync(document);
                                              OpenFile.open(
                                                  documentPayrol.path);
                                            },
                                            child: Material(
                                              elevation: 1,
                                              // Ajusta la elevación según tus necesidades
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration:
                                                    boxDecorationWithRoundedCorners(
                                                  backgroundColor:
                                                      Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12),
                                                  border: Border.all(
                                                      color: Colors.grey
                                                          .withOpacity(0.2)),
                                                ),
                                                child: const Icon(
                                                    Icons.download_sharp,
                                                    color: mainColorBlue),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      element['status']
                                          ? Container()
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 18.0,
                                                  top: 20.0,
                                                  right: 18.0),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  await showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                        context) {
                                                      final signatureController =
                                                          SignatureController(
                                                        penStrokeWidth: 2.0,
                                                        penColor:
                                                            Colors.black,
                                                      );

                                                      return AlertDialog(
                                                        surfaceTintColor:
                                                            Colors.white,
                                                        backgroundColor:
                                                            Colors.white,
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(
                                                                      36),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      36)),
                                                        ),
                                                        title: const Text(
                                                            "Firmar Documento"),
                                                        content: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize
                                                                  .min,
                                                          children: [
                                                            Container(
                                                              width: 350,
                                                              height: 280,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .black),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0),
                                                              ),
                                                              child:
                                                                  Signature(
                                                                controller:
                                                                    signatureController,
                                                                dynamicPressureSupported:
                                                                    true,
                                                                width: 330,
                                                                height: 262,
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                            8.height,
                                                            const Text(
                                                              "Al firmar este documento, estoy aceptando cumplir con el contenido establecido en este consentimiento.",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      13.0),
                                                            ),
                                                          ],
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(
                                                                        null);
                                                              },
                                                              child: const Text(
                                                                  "Cancelar",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .grey))),
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                // Obtener la firma actual del SignaturePad y cerrar el cuadro de diálogo
                                                                var signatureData =
                                                                    await signatureController
                                                                        .toPngBytes();
                                                                String
                                                                    base64String =
                                                                    base64Encode(
                                                                        signatureData!);

                                                                DocumentProvider().signatureDocument(
                                                                    element[
                                                                        'id_document'],
                                                                    base64String);
                                                                _currentPage =
                                                                    1;
                                                                transformedList =
                                                                    [];
                                                                monthFinal =
                                                                    null;
                                                                yearFinal =
                                                                    null;
                                                                setState(() {
                                                                  _isLoading =
                                                                      false;
                                                                });

                                                                await _getlistPayRoll()
                                                                    .then(
                                                                        (value) {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .hideCurrentSnackBar();
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text('Documento firmado')),
                                                                  );
                                                                });

                                                                _currentPage =
                                                                    1;
                                                                transformedList =
                                                                    [];
                                                                monthFinal =
                                                                    null;
                                                                yearFinal =
                                                                    null;
                                                                setState(() {
                                                                  _isLoading =
                                                                      false;
                                                                });

                                                                await _getlistPayRoll()
                                                                    .then(
                                                                        (value) {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .hideCurrentSnackBar();
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text('Documento firmado')),
                                                                  );
                                                                });

                                                                setState(
                                                                    () {});

                                                                Get.back();
                                                              },
                                                              child: const Text(
                                                                  "Aceptar",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          mainGreenColorButton))),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color:
                                                          orangeColorButton,
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(36)),
                                                  child: const Center(
                                                    child: Padding(
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                              horizontal: 8.0,
                                                              vertical: 3),
                                                      child: Text(
                                                        "Firma requerida",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16.0,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );

                        if (animationValue < 700) {
                          // Si se cumple la condición, aplicar la animación
                          cardWidget = cardWidget
                              .animate()
                              .fade(duration: animationValue.ms)
                              .slideY();
                        }

                        return cardWidget;
                      },
                      order: GroupedListOrder.DESC,
                      floatingHeader: false,
                    ),
                  ),
                ),
              ),
      floatingActionButton: CustomFloatingActions(
        onRefresh: () async {
          setState(
            () async {
              _currentPage = 1;
              transformedList = [];
              monthFinal = null;
              yearFinal = null;
              await _getlistPayRoll().then((value) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Filtro eliminado')),
                );
              });
            },
          );
        },
        onFilter: () {
          showMonthPicker(
            context,
            onSelected: (month, year) async {
              if (kDebugMode) {}
              setState(() {
                this.month = month;
                this.year = year;
                monthFinal = month;
                yearFinal = year;
              });

              if (monthFinal != null) {
                _currentPage = 1;
                transformedList = [];
                await _getlistPayRoll().then((value) {});
              }
            },
            initialSelectedMonth: month,
            initialSelectedYear: year,
            firstEnabledMonth: 1,
            lastEnabledMonth: 12,
            firstYear: 2023,
            lastYear: DateTime.now().year,
            selectButtonText: 'Aceptar',
            cancelButtonText: 'Cancelar',
            highlightColor: mainGreenColorButton,
            textColor: Colors.black,
            contentBackgroundColor: Colors.white,
            dialogBackgroundColor: Colors.white,
          );
        },
        onAdd: () {
          const DocumentUploadPage().launch(context);
        },
      ).animate().fade(delay: 1200.ms).slideX(),
    );
  }
}

class CustomFloatingActions extends StatefulWidget {
  final VoidCallback onRefresh;
  final VoidCallback onFilter;
  final VoidCallback onAdd;

  const CustomFloatingActions({
    required this.onRefresh,
    required this.onFilter,
    required this.onAdd,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomFloatingActions> createState() => _CustomFloatingActionsState();
}

class _CustomFloatingActionsState extends State<CustomFloatingActions> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 70.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isExpanded) ...[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(45, 45),
                backgroundColor: redColorButton.withOpacity(0.8),
                shape: const CircleBorder(),
              ),
              onPressed: widget.onRefresh,
              child: const Icon(Icons.refresh, color: Colors.white),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(45, 45),
                backgroundColor: mainGreenColorButton.withOpacity(0.8),
                shape: const CircleBorder(),
              ),
              onPressed: widget.onFilter,
              child: const Icon(Icons.calendar_month_outlined,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(45, 45),
                backgroundColor: mainColorBlue.withOpacity(0.8),
                shape: const CircleBorder(),
              ),
              onPressed: widget.onAdd,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            const SizedBox(height: 10),
          ],
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(50, 50),
              backgroundColor: mainGreenColorButton,
              shape: const CircleBorder(),
            ),
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Icon(
              _isExpanded ? Icons.close : Icons.filter_list,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
