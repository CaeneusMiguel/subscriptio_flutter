import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/data/auth/model/userLogin.dart';
import 'package:subcript/data/check_in/model/listCheking.dart';
import 'package:subcript/data/check_in/repository/controller/cheking_controller.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subcript/ui/features/common/showOptions.dart';
import 'package:subcript/ui/theme/colors.dart';

class Chekings extends StatefulWidget {
  const Chekings({Key? key}) : super(key: key);

  @override
  State<Chekings> createState() => _ChekingsState();
}

class _ChekingsState extends State<Chekings> with TickerProviderStateMixin {
  List<ListCheking> chekings = [];
  UserLogin? userSession;
  ChekingController con = Get.put(ChekingController());
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
        _loadMoreData();
      }
    });

    userSession = UserLogin.fromJson(GetStorage().read('user'));
    _loadMoreData();

    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          Brightness.dark,
    ));
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
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          _dataCharged == false
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
                        "No tienes ningún registro horario",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : SafeArea(
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
                          groupSeparatorBuilder: (String value) {
                            animationValue = animationValue + 100;

                            Widget separatorWidget = Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: mainColorBlue,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 0,
                                      blurRadius: 3,
                                      offset: Offset(0, 3),
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
                              separatorWidget = separatorWidget
                                  .animate()
                                  .fade(duration: animationValue.ms)
                                  .slideY();
                            }
                            return separatorWidget;
                          },
                          itemBuilder: (context, dynamic element) {
                            Widget cardWidget = GestureDetector(
                              onTap: () {
                                if (element['totalhours'] != null) {
                                  showPurposesBreaks(
                                      context, element['purposes']);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, bottom: 10, right: 16),
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
                                              color:
                                                  element['totalhours'] != null
                                                      ? mainColorBlue
                                                          .withOpacity(0.9)
                                                      : mainGreenColorButton,
                                              width: 6),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "resources/play3.png",
                                                  height: 16,
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                ),
                                                20.width,
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
                                            const SizedBox(height: 10.0),
                                            if (element['checkedOut'] != null)
                                              Row(
                                                children: [
                                                  Image.asset(
                                                      "resources/parada.png",
                                                      height: 16,
                                                      color: Colors.black
                                                          .withOpacity(0.7)),
                                                  20.width,
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
                                            if (element['totalhours'] != null)
                                              Column(
                                                children: [
                                                  const SizedBox(height: 10.0),
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        "resources/time.png",
                                                        height: 20,
                                                        color: Colors.black
                                                            .withOpacity(0.7),
                                                      ),
                                                      15.width,
                                                      const Text(
                                                        "Tiempo trabajado: ",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16.0,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        _convertToHoursAndMinutes(
                                                            element[
                                                                'totalhours']),
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
                                            if (element['totalBreakPurposes'] !=
                                                null)
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    "resources/time2.png",
                                                    height: 20,
                                                    color: Colors.black
                                                        .withOpacity(0.7),
                                                  ),
                                                  15.width,
                                                  const Text(
                                                    "Tiempo de pausa: ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
        ],
      ),
      floatingActionButton: CustomFloatingActions(
        onRefresh: () async {
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
              _isExpanded = false;
            });
          });},
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
          setState(() {
            _isExpanded = false;
          });
          setState(() {
            _isExpanded = false;
          });
        },

      ).animate().fade(delay: 1200.ms).slideX(),
    );
  }
}


class CustomFloatingActions extends StatefulWidget {
  final VoidCallback onRefresh;
  final VoidCallback onFilter;

  const CustomFloatingActions({
    required this.onRefresh,
    required this.onFilter,
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
              child: const Icon(Icons.calendar_month_outlined, color: Colors.white),
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
