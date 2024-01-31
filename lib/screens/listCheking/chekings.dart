import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:intl/intl.dart';
import 'package:subcript/service/controller/cheking_controller.dart';
import 'package:subcript/service/models/listCheking.dart';
import 'package:subcript/service/models/userLogin.dart';
import 'package:subcript/utils/colors.dart';
import 'package:subcript/utils/common/showOptions.dart';
import 'package:intl/date_symbol_data_local.dart';

class Chekings extends StatefulWidget {
  const Chekings({Key? key}) : super(key: key);

  @override
  State<Chekings> createState() => _ChekingsState();
}

class _ChekingsState extends State<Chekings> with TickerProviderStateMixin {
  List<ListCheking> chekings = [];
  UserLogin? userSession;
  ChekingController con = Get.put(ChekingController());
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
        _loadMoreData();
      }
    });

    userSession = UserLogin.fromJson(GetStorage().read('user'));
    _loadMoreData();

    super.initState();
  }

  Future<void> _loadMoreData() async {
    if (_isLoading) return;

    try {
      setState(() {
        _isLoading = true;
      });

      List<ListCheking> newChekings =
          await con.chekingList(_currentPage, monthFinal, yearFinal);
      if (newChekings.isEmpty) {
        setState(() {
          _hasMoreData = false;
        });
        return;
      }

      _currentPage++;

      setState(() {
        _transformAndAddData(newChekings);
      });
    } finally {
      setState(() {
        _dataCharged = true;
        _isLoading = false;
      });
    }
  }

  void _transformAndAddData(List<ListCheking> newChekings) {
    newChekings.forEach((checking) {
      String formattedCheckedInTime =
          DateFormat('HH:mm').format(checking.checkedIn.date);
      String formattedCheckedOutTime = checking.checkedOut != null
          ? DateFormat('HH:mm').format(checking.checkedOut!.date)
          : '';

      transformedList.add({
        'date': DateFormat('yyyy-MM-dd').format(checking.checkedIn.date),
        'checkedIn': formattedCheckedInTime,
        'checkedOut': formattedCheckedOutTime,
        'totalhours': checking.numberOfHours,
        'purposes': checking.purposes,
        'totalBreakPurposes': checking.totalBreakPurposes
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
  void dispose() {
    super.dispose();
  }

  String _convertToHoursAndMinutes(double totalMinutes) {
    int totalMinutesInt = totalMinutes.toInt();
    int hours = totalMinutesInt ~/ 60;
    int minutes = totalMinutesInt % 60;

    return '$hours h  $minutes m';
  }

  @override
  Widget build(BuildContext context) {
    final sortedDates = transformedList
        .map((element) => element['date'] as String)
        .toList()
      ..sort((a, b) => b.compareTo(a));

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
                    "No tienes ningún registro horario",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              :  SafeArea(
                      top: true,
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
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
                              onTap: () {
                                if (element['totalhours'] != null) {
                                  showPurposesBreaks(
                                      context, element['purposes']);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 2),
                                child: Card(
                                  elevation: 4,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  "Inicio: ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  element['checkedIn'],
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (element['checkedOut'] != null)
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Finalización: ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    element['checkedOut'],
                                                    style: const TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 10.0),
                                        if (element['totalhours'] != null)
                                          Row(
                                            children: [
                                              const Text(
                                                "Tiempo trabajado: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                _convertToHoursAndMinutes(
                                                    element['totalhours']),
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        const SizedBox(height: 10.0),
                                        if (element['totalBreakPurposes'] !=
                                            null)
                                          Row(
                                            children: [
                                              const Text(
                                                "Tiempo de pausa: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                _convertToHoursAndMinutes(
                                                    element[
                                                        'totalBreakPurposes']),
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
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
                await _loadMoreData().then((value) {
                  setState(() {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Filtro eliminado')),
                    );
                  });
                });
              },
              icon: const Icon(Icons.refresh, size: 30),
              color: Colors.red.withOpacity(0.8),
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
                    await _loadMoreData().then((value) {
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
            icon: const Icon(Icons.calendar_today, size: 22),
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
