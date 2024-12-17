import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

//import 'package:no_screenshot/no_screenshot.dart';
import 'package:subcript/data/auth/model/userLogin.dart';
import 'package:subcript/data/organized_time/model/holidaysData.dart';
import 'package:subcript/data/organized_time/repository/controller/holidays_controller.dart';
import 'package:subcript/ui/features/organized_time/screens/holidays_screens/requestHolidays.dart';
import 'package:subcript/ui/theme/colors.dart';

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
  int animationValue = 0;
  bool _isExpanded = false;


  //final _noScreenshot = NoScreenshot.instance;

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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          Brightness.dark,
    ));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreData() async {
    if (_isLoading) return;

    try {
      setState(() {
        _isLoading = true;
      });

      List<HolidaysData> newListHollidays =
          await con.getHolidaysList(_currentPage, status, userSession!.userId);
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
        cardColor = orangeColorButton;
      }

      listHolidays.add({
        'startDate': DateFormat('yyyy-MM-dd').format(holidays.startDate.date),
        'endDate': DateFormat('yyyy-MM-dd').format(holidays.endDate.date),
        'status': status,
        'color': cardColor,
        'responseComment': holidays.responseComment
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
          : SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: mainColorBlue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 0,
                      blurRadius: 3,
                      offset: Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                width: double.infinity,
                height: 58,
                child: GestureDetector(
                  onTap: () {
                    const RequestHolidays().launch(context).then((value) {
                      _currentPage = 1;
                      listHolidays = [];
                      status = null;
                      _loadMoreData();
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      20.width,
                      const Expanded(
                        child: Text(
                          "Solicitudes de Vacaciones",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SvgPicture.asset(
                          "resources/add2.svg",
                          height: 24,
                          width: 24,
                          fit: BoxFit.fill,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                      ),
                    ],
                  ),
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
                      animationValue = animationValue + 100;
                      Widget separatorWidget = GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 10, left: 10, top: 10),
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
                                        color: element['color'],
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
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                "resources/calendar.png",
                                                height: 18,
                                                color: Colors.black
                                                    .withOpacity(0.7),
                                              ),
                                              15.width,
                                              const Text(
                                                "Fecha de inicio: ",
                                                style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                  DateFormat('dd-MM-yyyy').format(DateTime.parse(element['startDate'])),
                                                  style:
                                                  const TextStyle(
                                                    fontSize: 15.0,
                                                    color:
                                                    Colors.black,
                                                  ),
                                                  softWrap: true),
                                            ],
                                          ),
                                        ],
                                      ),
                                      10.height,
                                      Row(
                                        children: [
                                          Image.asset(
                                            "resources/calendar4.png",
                                            height: 18,
                                            color: Colors.black
                                                .withOpacity(0.7),
                                          ),
                                          15.width,
                                          const Text(
                                            "Fecha de finalización: ",
                                            style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize: 15.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(element['endDate'])),
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black,
                                              ),
                                              softWrap: true),
                                        ],
                                      ),

                                      10.height,
                                      Row(
                                        children: [
                                          Image.asset(
                                            "resources/status.png",
                                            height: 18,
                                            color: Colors.black
                                                .withOpacity(0.7),
                                          ),
                                          15.width,
                                          const Text(
                                            "Estado:  ",
                                            style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize: 15.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Container(
                                            width: 100,
                                            height: 27,
                                            decoration: BoxDecoration(
                                                color:
                                                element['color'],
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    36)),
                                            child: Center(
                                              child: Text(
                                                element['status'],
                                                style:
                                                const TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 15.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      10.height,
                                      element['responseComment'] !=
                                          null
                                          ? Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          Image.asset(
                                            "resources/denegado.png",
                                            height: 18,
                                            color: Colors.black
                                                .withOpacity(
                                                0.7),
                                          ),
                                          15.width,
                                          const Text(
                                            "Motivo: ",
                                            style: TextStyle(
                                              fontWeight:
                                              FontWeight
                                                  .bold,
                                              fontSize: 15.0,
                                              color:
                                              Colors.black,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                                "${element['responseComment']}",
                                                style:
                                                const TextStyle(
                                                  fontSize:
                                                  15.0,
                                                  color: Colors
                                                      .black,
                                                ),
                                                softWrap: true),
                                          ),
                                        ],
                                      )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
                    }),
              )
            ],
          ),
        ),
      ),
      // Sistema de botones superpuestos
      floatingActionButton: CustomFloatingActions(
        onRefresh: () async {
          setState(() async {
            _currentPage = 1;
            listHolidays = [];
            status = null;

            await _loadMoreData().then((value) {
              setState(() {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Filtro eliminado')),

                );
                _isExpanded = false;
              });
            });
          },);},
        onFilter: () {
          _mostrarDialogo(context);

          setState(() {
            _isExpanded = false;
          });
        },

      ).animate().fade(delay: 1200.ms).slideX(),
    );
  }


  void _mostrarDialogo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext builder) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Center(
                  child: Text(
                'Filtro de vacaciones ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
              5.height,
              const Divider(
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
              child: const Icon(Icons.format_list_bulleted_rounded, color: Colors.white),
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
