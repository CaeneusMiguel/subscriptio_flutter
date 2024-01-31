import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
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
  List<Document?> payroll = [];
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
  }

  Future<void> _getlistPayRoll() async {
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

      setState(() {
        _transformAndAddData(newDocuments);
      });
    } finally {
      setState(() {
        _dataCharged = true;
        _isLoading = false;
      });
    }
  }

  void _transformAndAddData(List<Document> newDocument) {
    newDocument.forEach((document) {
      String formattedCreateDate =
          DateFormat('HH:mm').format(document.createDate.date);

      transformedList.add({
        'date': DateFormat('yyyy-MM-dd').format(document.createDate.date),
        'create_date': formattedCreateDate,
        'name': document.nombre,
        'file_path': document.file,
        'id_document': document.id
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
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: _dataCharged == false
          ? const Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
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
                            horizontal: 10, vertical: 2),
                        child: GroupedListView<dynamic, String>(
                          controller: _scrollController,
                          useStickyGroupSeparators: true,
                          elements: transformedList,
                          groupBy: (element) => element['date'],
                          groupSeparatorBuilder: (String value) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: mainColorBlue,
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  formatSpanishDate(DateTime.parse(value)),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          itemBuilder: (context, dynamic element) {
                            return GestureDetector(
                              onTap: () async {
                                Uint8List document = await DocumentProvider()
                                    .getDownloadDocument(
                                        element['id_document']);
                                final directorio_en_cache =
                                    await getTemporaryDirectory();
                                final nameDirectory =
                                    'documentos'; // Nombre del directorio
                                final directory = Directory(
                                    '${directorio_en_cache.path}/$nameDirectory');

                                if (!(await directory.exists())) {
                                  await directory.create(recursive: true);
                                }
                                String nombreArchivo = element['name']
                                    .replaceAll(' ', '_')
                                    .replaceAll('/', '-');
                                File documentPayrol = await File(
                                    '${directory.path}/$nombreArchivo.pdf');
                                documentPayrol.writeAsBytesSync(document);
                                OpenFile.open(documentPayrol.path);
                              },
                              child: Card(
                                elevation: 4,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: const Icon(
                                          Icons.description,
                                          color: mainColorBlue,
                                          size: 40,
                                        ),
                                        title: Text(
                                          element['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          order: GroupedListOrder.DESC,
                          floatingHeader: false,
                        ),
                      ),
                    ),

      floatingActionButton: HawkFabMenu(
        openIcon: Icons.filter_list,
        closeIcon: Icons.close_rounded,
        fabColor: mainGreenColorButton,
        iconColor: Colors.white,
        hawkFabMenuController: hawkFabMenuController,
        items: [
          HawkFabMenuItem(
              label: '',
              ontap: () async {
                _currentPage = 1;
                transformedList = [];
                monthFinal = null;
                yearFinal = null;
                await _getlistPayRoll().then((value) {
                  setState(() {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Filtro eliminado')),
                    );
                  });
                });
              },
              icon: const Icon(Icons.refresh, size: 30),
              color: Colors.red,
              labelColor: Colors.blue,
              labelBackgroundColor: Colors.transparent),
          HawkFabMenuItem(
            label: '',
            ontap: () {
              showMonthPicker(
                context,
                onSelected: (month, year) async {
                  if (kDebugMode) {
                    print('Selected month: $month, year: $year');
                  }
                  setState(() {
                    this.month = month;
                    this.year = year;
                    monthFinal = month;
                    yearFinal = year;
                  });

                  if (monthFinal != null) {
                    _currentPage = 1;
                    transformedList = [];
                    await _getlistPayRoll().then((value) {
                      setState(() {});
                    });
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
            icon: const Icon(Icons.calendar_today),
            color: mainGreenColorButton.withOpacity(0.8),
            labelColor: Colors.white,
            labelBackgroundColor: Colors.transparent,
          ),
        ],
        body: const Center(
          child: Text(''),
        ),
      ),
    );
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final FloatingActionButtonLocation delegate;
  final double offsetY;

  CustomFloatingActionButtonLocation(this.delegate, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    var offset = delegate.getOffset(scaffoldGeometry);
    return Offset(offset.dx, offset.dy + offsetY);
  }

  @override
  String toString() => '$delegate, $offsetY';
}
