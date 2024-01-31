import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gradient_progress_indicator/widget/gradient_progress_indicator_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/service/controller/cheking_controller.dart';
import 'package:subcript/service/models/checkinDataCont.dart';
import 'package:subcript/service/models/companyConfi.dart';
import 'package:subcript/service/models/purpose.dart';
import 'package:subcript/service/models/purposeDataCont.dart';
import 'package:subcript/service/models/userLogin.dart';
import 'package:subcript/service/provider/device_provider.dart';
import 'package:subcript/utils/colors.dart';
import 'package:subcript/utils/common/showOptions.dart';
import 'package:subcript/utils/widgets/customAlertDialogInfo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime dateNow = DateTime.now();

  late int day;
  late String month;
  late String year;
  bool isPlaying = false;
  bool isPause = true;
  bool active = true;
  bool isVisibleTemp = false;
  bool isVisibleTempCheckin = false;
  Color buttonColorPlay = Colors.grey;
  Color buttonColorPause = Colors.grey;
  Color buttonColorTemp = Colors.grey;
  IconData iconDataPlay = Icons.play_arrow;
  IconData iconDataPause = Icons.pause;
  int elapsedTime = 0;
  bool isDataCarged = false;
  UserLogin? userSession;
  String? name;
  bool action = false;
  List<Purpose> opciones = [];
  Timer? _timer;
  Timer? _timerCheckin;
  int _totalSeconds = 0;
  int _elapsedSeconds = 0;
  int _elapsedSecondsCheckin = 0;
  bool _isTimerRunning = false;
  late Purpose purposeSelected;
  late int timeAnimationButton;
  String status = "Activa";
  late String purposeName = '';
  PurposeDataCont? purposeDataCont;
  double? latitude;
  double? longitude;
  CompanyConfi? configCompany;

  ChekingController con = Get.put(ChekingController());

  @override
  void initState() {
    day = dateNow.day;
    year = dateNow.year.toString();
    userSession = UserLogin.fromJson(GetStorage().read('user'));
    name = userSession?.userName ?? '';
    _getConfig();
    getIsCheking();

    super.initState();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
  }

  Future<void> _getConfig() async {
    configCompany = await con.getConfigCompany();
  }

  void _startTimerCheckin() {
    _timerCheckin = Timer.periodic(Duration(seconds: 1), _updateTimerChekin);
  }

  void _updateTimer(Timer timer) {
    setState(() {
      if (_elapsedSeconds < _totalSeconds) {
        _elapsedSeconds++;
      } else {
        _timer?.cancel();
        _isTimerRunning = false;
        // Puedes realizar acciones adicionales cuando el temporizador llega a cero
      }
    });
  }

  void _updateTimerChekin(Timer timer) {
    setState(() {
      _elapsedSecondsCheckin++;
    });
  }

  String _formatTime(int timeInSeconds) {
    int hours = timeInSeconds ~/ 3600;
    int minutes = (timeInSeconds % 3600) ~/ 60;
    int seconds = timeInSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}'
        ':${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatTimeCheckin(int timeInSeconds) {
    int hours = timeInSeconds ~/ 3600;
    int minutes = (timeInSeconds % 3600) ~/ 60;
    int seconds = timeInSeconds % 60;

    String formattedTime = '${hours.toString().padLeft(2, '0')}'
        ':${minutes.toString().padLeft(2, '0')}'
        ':${seconds.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  void _toggleTimer() {
    setState(() {
      if (_isTimerRunning) {
        _timer?.cancel();
      } else {
        _startTimer();
      }
      _isTimerRunning = !_isTimerRunning;
    });
  }

  void _resetTimer() {
    setState(() {
      _timer?.cancel();
      _elapsedSeconds = 0;
      _isTimerRunning = false;
    });
  }

  void _resetTimerCheckin() {
    setState(() {
      _timerCheckin?.cancel();
      _elapsedSecondsCheckin = 0;
      _isTimerRunning = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timerCheckin?.cancel();
    super.dispose();
  }

  Future<void> getIsCheking() async {
    await con.getIsCheking().then((value) async {
      if (value.body['data']['isCheckIn'] == false) {
        isDataCarged = true;
        isPlaying = false;
        isVisibleTempCheckin = false;
        buttonColorPlay = Colors.grey;
        iconDataPlay = Icons.play_arrow;
        status = "Inactiva";
        timeAnimationButton = 0;
        DeviceProvider()
            .postTokenFireBase(GetStorage().read('tokenMessage') ?? '');
      } else {
        isDataCarged = true;
        isPlaying = true;
        buttonColorPlay = greenColorButton;

        iconDataPlay = Icons.stop;
        CheckinDataCont chekingHour =
            CheckinDataCont.fromJson(value.body['data']['creationCheking']);
        DateTime now = DateTime.now();
        _elapsedSecondsCheckin =
            now.difference(chekingHour.creationDate.date).inSeconds;
        _startTimerCheckin();
        status = "Activa";
        timeAnimationButton = 3;
        await con.getIsBreakIn().then((value) {
          if (value.body['data']['isBreakIn'] == false) {
            isVisibleTempCheckin = true;
            isVisibleTemp = false;
            isPause = false;
            buttonColorPause = Colors.grey;
          } else {
            isVisibleTemp = true;
            isVisibleTempCheckin = false;
            purposeDataCont =
                PurposeDataCont.fromJson(value.body['data']['dataPurpose']);

            _totalSeconds = (purposeDataCont!.estimatedTime! * 60).toInt();
            status = "Pausa";
            isPause = true;
            buttonColorTemp = orangeColorButton;
            buttonColorPlay = orangeColorButton;
            purposeName = purposeDataCont?.purpose ?? '';
            DateTime now = DateTime.now();
            _elapsedSeconds =
                now.difference(purposeDataCont!.breakIn.date).inSeconds;
            if (_elapsedSeconds >= _totalSeconds) {
              // Si ya ha pasado el tiempo total, cancela el temporizador
              _elapsedSeconds = _totalSeconds;
            }

            if (_elapsedSeconds < _totalSeconds) {
              // Si hay tiempo restante, inicia el temporizador
              _startTimer();
            }

            _isTimerRunning = _elapsedSeconds < _totalSeconds;
          }
        });
      }
      opciones = await con.getPurposeList();

      action = true;
      setState(() {});
    });
  }

  String getCurrentTime() {
    final now = DateTime.now();

    String formattedTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  void togglePlayClose() {
    setState(() {
      if (action != false) {
        isPlaying = !isPlaying;

        if (isPlaying) {
          isPause = !isPause;
          con.cheking(latitude, longitude);
          GetStorage().write("activeCheking", isPlaying);
          isVisibleTempCheckin = true;
          buttonColorPlay = isPlaying ? greenColorButton : Colors.grey;
          iconDataPlay = isPlaying ? Icons.stop : Icons.play_arrow;
          status = "Activa";
          timeAnimationButton = 3;
          _startTimerCheckin();
        } else {
          if (isPause) {
            con.pause(null);
            isPause = !isPause;
            buttonColorPlay = greenColorButton;
            isPlaying = !isPlaying;
            _totalSeconds = 0;
            _resetTimer();
            status = "Activa";
            buttonColorTemp = Colors.grey;
            isVisibleTemp = false;
            isVisibleTempCheckin = true;
          } else {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => CustomAlertDialogInfo(
                title: "Terminar jornada",
                message:
                    "¿Estas seguro de que deseas terminar la jornada laboral?",
                onConfirm: () {
                  con.cheking(latitude, longitude);
                  setState(() {
                    GetStorage().write("activeCheking", isPlaying);
                    isPause = !isPause;
                    buttonColorPlay =
                        isPlaying ? greenColorButton : Colors.grey;
                    iconDataPlay = isPlaying ? Icons.stop : Icons.play_arrow;
                    status = "Inactiva";
                    isVisibleTempCheckin = false;
                    timeAnimationButton = 0;
                    _resetTimerCheckin();
                  });

                  Navigator.of(context).pop();
                },
                onCancel: () {
                  timeAnimationButton = 3;
                  setState(() {
                    isPlaying = !isPlaying;
                  });
                  Navigator.of(context).pop();
                },
              ),
            );
          }
        }
      }
    });
  }

  void togglePause() {
    setState(() {
      showOptionParameter(
          context, opciones, _onButtonSelected, _onOptionSelected);
    });
  }

  void _onButtonSelected(bool selectedOption) {
    setState(() {
      isPause = selectedOption;
      buttonColorPlay = orangeColorButton;
    });
  }

  void _onOptionSelected(Purpose selectedOption) {
    setState(() {
      purposeSelected = selectedOption;

      status = "Pausa";
      buttonColorTemp = orangeColorButton;
      isVisibleTemp = true;
      _totalSeconds = (purposeSelected.estimatedTime! * 60).toInt();

      purposeName = purposeSelected.purpose;
      isVisibleTempCheckin = false;
      _toggleTimer();
    });
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CustomAlertDialogInfo(
            title: "Error al obtener ubicación",
            message:
                "Para realizar el inicio de su jornada es necesario que acepte los permisos de geolocalización",
            onConfirm: () async {
              permission = await Geolocator.requestPermission();
              setState(() {});

              Navigator.of(context).pop();
            },
            onCancel: () {
              Navigator.of(context).pop();
            },
          ),
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CustomAlertDialogInfo(
          title: "Error al obtener ubicación",
          message:
              "Para realizar el inicio de su jornada es necesario que acepte los permisos de geolocalización",
          onConfirm: () async {
            Geolocator.openLocationSettings();
            setState(() {});

            Navigator.of(context).pop();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        ),
      );
    }

    Position position = await Geolocator.getCurrentPosition();

    latitude = position.latitude;

    longitude = position.longitude;

    togglePlayClose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isDataCarged == false
            ? const Center(
                child: SizedBox(
                  width: 80, // Ajusta el ancho según tus necesidades
                  height: 80, // Ajusta la altura según tus necesidades
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                  ),
                ),
              )
            : Column(
                children: [
                  20.height,
                  Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'resources/logo_name.png',
                        width: 150,
                        fit: BoxFit.fitWidth,
                      )),
                  60.height,
                  10.height,
                  isVisibleTempCheckin == false && isVisibleTemp == false
                      ? Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Jornada sin iniciar',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color:
                                  buttonColorPlay, // Color del texto del contador
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(10),
                          child: status == "Activa"
                              ? Text(
                                  'Jornada iniciada',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color:
                                        buttonColorPlay, // Color del texto del contador
                                  ),
                                )
                              : Column(
                                  children: [
                                    Text(
                                      'Jornada pausada',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        color:
                                            buttonColorPlay, // Color del texto del contador
                                      ),
                                    ),
                                    10.height,
                                    Text(
                                      '$purposeName',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color:
                                            buttonColorPlay, // Color del texto del contador
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                  10.height,
                  isVisibleTemp == true
                      ? Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            _formatTime(_totalSeconds - _elapsedSeconds),
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: buttonColorTemp),
                          ),
                        )
                      : Container(),
                  isVisibleTempCheckin == true
                      ? Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            _formatTimeCheckin(_elapsedSecondsCheckin),
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: buttonColorPlay),
                          ),
                        )
                      : Container(),
                  isVisibleTempCheckin == false && isVisibleTemp == false
                      ? Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            _formatTimeCheckin(_elapsedSecondsCheckin),
                            style: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.transparent),
                          ),
                        )
                      : Container(),
                  30.height,
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GestureDetector(
                          onTap: () {

                            if (configCompany?.includeCheckinLocation == true) {
                              _determinePosition();
                            } else {
                              togglePlayClose();
                            }
                          },
                          child: isPlaying != false
                              ? GradientProgressIndicator(
                                  radius: 140,
                                  duration: 3,
                                  strokeWidth: 14,
                                  gradientStops: const [
                                    0.8,
                                    0.9,
                                  ],
                                  gradientColors: [
                                    buttonColorPlay,
                                    mainColorBlue,
                                  ],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        iconDataPlay,
                                        size: 90,
                                        color: buttonColorPlay,
                                      ),
                                      // Otras partes del contenido si es necesario
                                    ],
                                  ),
                                )
                              : Center(
                                  child: Container(
                                    width: 280,
                                    height: 280,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: buttonColorPlay,
                                        // Puedes cambiar a tu color deseado
                                        width: 14,
                                      ),
                                      borderRadius: BorderRadius.circular(140),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.play_arrow,
                                        size: 90,
                                        color:
                                            buttonColorPlay, // Puedes ajustar el color según tus necesidades
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      isPause != true
                          ? Positioned(
                              bottom:
                                  -0.00 * MediaQuery.of(context).size.height,
                              right: MediaQuery.of(context).size.height * 0.10,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  // Ajusta el radio según tus necesidades
                                  border: Border.all(
                                    color:
                                        Colors.white, // Color del borde blanco
                                    width: 4.0, // Ancho del borde
                                  ),
                                ),
                                child: FloatingActionButton(
                                  elevation: 2,
                                  onPressed: () {
                                    togglePause();
                                  },
                                  backgroundColor: buttonColorPause,
                                  child: const Icon(Icons.pause,
                                      size:
                                          35), // Ajusta el color del botón según tus necesidades
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
