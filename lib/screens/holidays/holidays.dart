import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:subcript/screens/holidays/screens/requestHolidays.dart';
import 'package:subcript/service/models/holidaysData.dart';
import 'package:subcript/service/controller/holidays_controller.dart';
import 'package:subcript/service/models/userLogin.dart';
import 'package:subcript/utils/colors.dart';

class Holidays extends StatefulWidget {
  const Holidays({super.key});

  @override
  State<Holidays> createState() => _HolidaysState();
}

class _HolidaysState extends State<Holidays>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final ScrollController _scrollController = ScrollController();
  HolidaysController con = Get.put(HolidaysController());
  HawkFabMenuController hawkFabMenuController = HawkFabMenuController();
  UserLogin? userSession;
  int _currentPage = 1;
  String? status;
  bool _dataCharged = false;
  int? _opcionSeleccionada = 4;
  bool _isLoading = false;
  bool _hasMoreData = true;
  List<Map<String, dynamic>> listHolidays = [];

  final _noScreenshot = NoScreenshot.instance;

  @override
  void initState() {
    userSession = UserLogin.fromJson(GetStorage().read('user'));
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _hasMoreData) {
        _loadMoreData();
      }
    });
    tabController = TabController(length: 3, vsync: this);
    _loadMoreData();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreData() async {
    await _noScreenshot.screenshotOff();
    if (_isLoading) return;

    try {
      setState(() {
        _isLoading = true;
      });

      List<HolidaysData> newListHollidays =
          await con.getHolidaysList(_currentPage, status, userSession!.userId);
      //List<ListCheking> newChekings = await con.chekingList(_currentPage,monthFinal,yearFinal);
      if (newListHollidays.isEmpty) {
        setState(() {
          _hasMoreData = false;
        });
        return;
      }

      _currentPage++;

      setState(() {
        _transformAndAddData(newListHollidays);
      });
    } finally {
      setState(() {
        _dataCharged = true;
        _isLoading = false;
      });
    }
  }

  void _transformAndAddData(List<HolidaysData> newListHollidays) {
    newListHollidays.forEach((holidays) {
      String? status;
      Color cardColor = Colors.white;
      if (holidays.accepted == true) {
        status = "Aceptada";

        cardColor = greenColorButton;
      } else if (holidays.accepted == false) {
        status = "Denegada";
        cardColor = redColorButton;
      } else {
        status = "En revisión";
        cardColor = Colors.grey;
      }

      Duration difference =
          holidays.endDate.date.difference(holidays.startDate.date);
      int differenceInDays = difference.inDays;
      if (differenceInDays == 0) {
        differenceInDays = 1;
      }

      listHolidays.add({
        'startDate': DateFormat('yyyy-MM-dd').format(holidays.startDate.date),
        'endDate': DateFormat('yyyy-MM-dd').format(holidays.endDate.date),
        'status': status,
        'numDays': differenceInDays,
        'color': cardColor
      });
    });

    listHolidays.sort((a, b) {
      DateTime startDateA = DateTime.parse(a['startDate']);
      DateTime startDateB = DateTime.parse(b['startDate']);
      return startDateA.compareTo(startDateB);
    });
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
          : SafeArea(
              top: true,
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: mainColorBlue,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      width: double.infinity,
                      height: 58,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Solicitudes de Vacaciones",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              const RequestHolidays()
                                  .launch(context)
                                  .then((value) {
                                _currentPage = 1;
                                listHolidays = [];
                                status = null;
                                _loadMoreData();
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: SvgPicture.asset(
                                "resources/add2.svg",
                                height: 30,
                                width: 30,
                                fit: BoxFit.fill,
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: listHolidays.isEmpty
                          ? const Center(
                              child: Text(
                                "No tienes ninguna solicitud de vacaciones",
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: listHolidays.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> element =
                                    listHolidays[index];

                                return GestureDetector(
                                  onTap: () {},
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text(
                                                      "Fecha de inicio: ",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      element['startDate'],
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            10.height,
                                            Row(
                                              children: [
                                                const Text(
                                                  "Fecha de finalización: ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  element['endDate'],
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            10.height,
                                            Row(
                                              children: [
                                                const Text(
                                                  "Dias solicitados: ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  "${element['numDays']}",
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            10.height,
                                            Row(
                                              children: [
                                                const Text(
                                                  "Estado:  ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Container(
                                                  width: 110,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                      color: element['color'],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              36)),
                                                  child: Center(
                                                    child: Text(
                                                      element['status'],
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16.0,
                                                        color: Colors.white,
                                                      ),
                                                    ),
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
                              }),
                    )
                  ],
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
                listHolidays = [];
                status = null;

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
              _mostrarDialogo(context);
            },
            icon: const Icon(Icons.menu_rounded, size: 28),
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

  void _mostrarDialogo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext builder) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                  child: Text(
                'Filtro de vacaciones ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
              5.height,
              Divider(
                color: Colors.black,
              ),
              _crearOpcion(1, 'Denegadas'),
              _crearOpcion(2, 'Aceptadas'),
              _crearOpcion(3, 'En revisión'),
              _crearOpcion(4, 'Todas'),
            ],
          ),
        );
      },
    );
  }

  Widget _crearOpcion(int valor, String texto) {
    return OpcionWidget(
      valor: valor,
      texto: texto,
      seleccionada: _opcionSeleccionada == valor,
      onSelected: () async {
        _opcionSeleccionada = valor;

        if (_opcionSeleccionada == 1) {
          status = "0";
        } else if (_opcionSeleccionada == 2) {
          status = "1";
        } else if (_opcionSeleccionada == 3) {
          status = "2";
        } else {
          status = null;
        }
        _currentPage = 1;
        listHolidays = [];
        await _loadMoreData().then((value) {
          Navigator.pop(context);
        });
      },
    );
  }
}

class OpcionWidget extends StatefulWidget {
  final int valor;
  final String texto;
  final bool seleccionada;
  final VoidCallback onSelected;

  const OpcionWidget({
    required this.valor,
    required this.texto,
    required this.seleccionada,
    required this.onSelected,
  });

  @override
  _OpcionWidgetState createState() => _OpcionWidgetState();
}

class _OpcionWidgetState extends State<OpcionWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Radio<int>(
            activeColor: mainGreenColorButton,
            value: widget.valor,
            groupValue: widget.seleccionada ? widget.valor : null,
            onChanged: (_) {
              widget.onSelected();
            },
          ),
          Text(widget.texto),
        ],
      ),
      onTap: () {
        widget.onSelected();
      },
    );
  }
}
