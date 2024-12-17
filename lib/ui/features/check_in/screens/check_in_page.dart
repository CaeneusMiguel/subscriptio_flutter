import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart' as geoloc;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gradient_progress_indicator/widget/gradient_progress_indicator_widget.dart';
import 'package:location/location.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/data/auth/model/companyConfi.dart';
import 'package:subcript/data/auth/model/userLogin.dart';
import 'package:subcript/data/check_in/model/checkinDataCont.dart';
import 'package:subcript/data/check_in/model/purpose.dart';
import 'package:subcript/data/check_in/model/purposeDataCont.dart';
import 'package:subcript/data/check_in/repository/controller/cheking_controller.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:subcript/data/common/repository/provider/device_provider.dart';
import 'package:subcript/ui/features/common/showOptions.dart';
import 'package:subcript/ui/features/common/widgets/customAlertDialogComment.dart';
import 'package:subcript/ui/features/common/widgets/customAlertDialogInfo.dart';
import 'package:subcript/ui/theme/colors.dart';


class CheckinPage extends StatefulWidget {
  const CheckinPage({super.key});

  @override
  State<CheckinPage> createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> with WidgetsBindingObserver {
  DateTime dateNow = DateTime.now();
  String? comment;
  late int day;
  late String month;
  late String year;
  bool isPlaying = false;
  bool isPause = true;
  bool active = true;
  bool positionCharged = true;
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
  Location location = Location();
  final GeolocatorPlatform geolocatorAndroid = GeolocatorPlatform.instance;
bool activeButton=true;
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      // Cambia el color de fondo de la barra de estado
      statusBarIconBrightness:
          Brightness.dark, // Cambia el color del texto en la barra de estado
    ));
    WidgetsBinding.instance?.addObserver(this);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
  }

  Future<void> _getConfig() async {
    configCompany = await con.getConfigCompany();
  }

  void _startTimerCheckin() {
    _timerCheckin = Timer.periodic(const Duration(seconds: 1), _updateTimerChekin);
  }

  void _updateTimer(Timer timer) {
    setState(() {
      if (_elapsedSeconds < _totalSeconds) {
        _elapsedSeconds++;
      } else {
        _timer?.cancel();
        _isTimerRunning = false;
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
    WidgetsBinding.instance?.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _getConfig();
      _timer?.cancel();
      _timerCheckin?.cancel();
      isDataCarged = false;
      getIsCheking();
    }
  }

  Future<void> getIsCheking() async {
    await con.getIsCheking().then((value) async {
      if (value.body['data']['isCheckIn'] == false) {
        isPlaying = false;
        isVisibleTempCheckin = false;
        buttonColorPlay = Colors.grey;
        iconDataPlay = Icons.play_arrow;
        status = "Inactiva";
        timeAnimationButton = 0;
        DeviceProvider()
            .postTokenFireBase(GetStorage().read('tokenMessage') ?? '');
      } else {
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
      isDataCarged = true;
      action = true;
      setState(() {});
      opciones = await con.getPurposeList();
      if (configCompany?.includeCheckinLocation == true) {
        if (Platform.isIOS) {
          determinePermision();
          geoloc.Position position = await geoloc.Geolocator.getCurrentPosition(
              forceAndroidLocationManager: true,
              desiredAccuracy: geoloc.LocationAccuracy.low);

          latitude = position.latitude;

          longitude = position.longitude;
        } else {
          final hasPermission = await _handlePermission();

          if (!hasPermission) {
            return;
          }

          final position = await geolocatorAndroid.getCurrentPosition(
              locationSettings:
                  AndroidSettings(accuracy: geoloc.LocationAccuracy.medium));

          longitude = position.longitude;

          latitude = position.latitude;
        }
      }
    });
  }

  String getCurrentTime() {
    final now = DateTime.now();

    String formattedTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  void togglePlayClose() {
    setState(()  {
      positionCharged = true;
      if (action != false) {
        isPlaying = !isPlaying;

        if (isPlaying) {
          isPause = !isPause;

          con.cheking(latitude, longitude,comment);

          GetStorage().write("activeCheking", isPlaying);
          isVisibleTempCheckin = true;
          buttonColorPlay = isPlaying ? greenColorButton : Colors.grey;
          iconDataPlay = isPlaying ? Icons.stop : Icons.play_arrow;
          status = "Activa";
          timeAnimationButton = 3;
          active = !active;
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
            active = !active;
          } else {
            if(((_elapsedSecondsCheckin)~/ 3600)<1) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      CustomAlertDialogComment(
                        title: "Terminar jornada",
                        message: "¿Estas seguro de que quieres finalizar la jornada laboral?. Llevas menos de 1 hora trabajando.",
                        onConfirm: () async {
                          //print('Comentario: $comment');
                          if(activeButton) {
                            activeButton=false;
                            await con.cheking(latitude, longitude, comment);

                            GetStorage().write("activeCheking", isPlaying);
                            isPause = !isPause;
                            buttonColorPlay =
                            isPlaying ? greenColorButton : Colors.grey;
                            iconDataPlay =
                            isPlaying ? Icons.stop : Icons.play_arrow;
                            status = "Inactiva";
                            isVisibleTempCheckin = false;
                            timeAnimationButton = 0;
                            active = !active;
                            _resetTimerCheckin();
                            Navigator.of(context).pop();
                            activeButton=true;
                          }
                        },
                        onCancel: () {
                          timeAnimationButton = 3;
                          setState(() {
                            active = !active;
                            isPlaying = !isPlaying;
                          });
                          Navigator.of(context).pop();
                        },
                        onCommentChanged: (value) {
                          setState(() {
                            comment = value;
                          });
                        },
                      )
              );
            }else{
              if(activeButton) {
                activeButton=false;
                con.cheking(latitude, longitude, comment);
                GetStorage().write("activeCheking", isPlaying);
                isPause = !isPause;
                buttonColorPlay =
                isPlaying ? greenColorButton : Colors.grey;
                iconDataPlay =
                isPlaying ? Icons.stop : Icons.play_arrow;
                status = "Inactiva";
                isVisibleTempCheckin = false;
                timeAnimationButton = 0;
                active = !active;
                _resetTimerCheckin();
                activeButton=true;

              }

            }
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
    //
    positionCharged = false;
    setState(() {});
    if (Platform.isIOS) {
      determinePermision();
      geoloc.Position position = await geoloc.Geolocator.getCurrentPosition(
          forceAndroidLocationManager: true,
          desiredAccuracy: geoloc.LocationAccuracy.medium);

      latitude = position.latitude;

      longitude = position.longitude;
    } else {
      final hasPermission = await _handlePermission();

      if (!hasPermission) {
        return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CustomAlertDialogInfo(
            activeCancel: true,
            title: "Error al obtener ubicación",
            message:
                "Es necesario activar el gps para poder continuar con el cierre o inicio de jornada",
            onConfirm: () async {
              positionCharged = true;
              active = !active;
              setState(() {});
              _openLocationSettings();
              Navigator.of(context).pop();
            },
            onCancel: () {
              positionCharged = true;
              active = !active;
              setState(() {});
              Navigator.of(context).pop();
            },
          ),
        );
      }

      final position = await geolocatorAndroid.getCurrentPosition(
          locationSettings:
              AndroidSettings(accuracy: geoloc.LocationAccuracy.medium));

      longitude = position.longitude;

      latitude = position.latitude;
    }

    togglePlayClose();
  }

  Future<void> determinePermision() async {
    bool serviceEnabled;
    geoloc.LocationPermission permission;
    serviceEnabled = await geoloc.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CustomAlertDialogInfo(
          activeCancel: false,
          title: "Error al obtener ubicación",
          message:
              "Es necesario activar el gps para poder continuar con el cierre o inicio de jornada",
          onConfirm: () async {
            Navigator.of(context).pop();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        ),
      );
    }

    permission = await geoloc.Geolocator.checkPermission();
    if (permission == geoloc.LocationPermission.denied) {
      permission = await geoloc.Geolocator.requestPermission();
      if (permission == geoloc.LocationPermission.denied) {
        return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CustomAlertDialogInfo(
            title: "Error al obtener ubicación",
            activeCancel: true,
            message:
                "Para realizar el inicio de su jornada es necesario que acepte los permisos de geolocalización",
            onConfirm: () async {
              permission = await geoloc.Geolocator.requestPermission();
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
    if (permission == geoloc.LocationPermission.deniedForever) {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CustomAlertDialogInfo(
          title: "Error al obtener ubicación",
          activeCancel: true,
          message:
              "Para realizar el inicio de su jornada es necesario que acepte los permisos de geolocalización",
          onConfirm: () async {
            geoloc.Geolocator.openLocationSettings();
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

  void _openLocationSettings() async {
    await geolocatorAndroid.openLocationSettings();
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await geolocatorAndroid.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //print("permisos desactivados");

      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location service
      return false;
    }
    permission = await geolocatorAndroid.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await geolocatorAndroid.requestPermission();
      if (permission == LocationPermission.denied) {
        //print("permisos denegados");

        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      //print("permisos denegados para siempre");

      return false;
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isDataCarged == false
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
                  40.height,
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
                                fontSize: 34,
                                fontWeight: FontWeight.normal,
                                fontFamily: "Anta",
                                color: buttonColorTemp),
                          )
                              .animate(
                                  target: _totalSeconds - _elapsedSeconds == 0
                                      ? 1
                                      : 0)
                              .then(duration: 1000.ms)
                              .shake(),
                        )
                      : Container(),
                  isVisibleTempCheckin == true
                      ? Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            _formatTimeCheckin(_elapsedSecondsCheckin),
                            style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.normal,
                                fontFamily: "Anta",
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
                                fontSize: 34,
                                fontWeight: FontWeight.normal,
                                fontFamily: "Anta",
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
                          onTap: active
                              ? () {
                                  active = !active;
                                  if (configCompany?.includeCheckinLocation ==
                                      true) {
                                    _determinePosition();
                                  } else {
                                    togglePlayClose();
                                  }
                                }
                              : null,
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
                                      positionCharged == false
                                          ? const CircularProgressIndicator(
                                              strokeWidth: 5,
                                            )
                                          : Icon(
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
                                        width: 14,
                                      ),
                                      borderRadius: BorderRadius.circular(140),
                                    ),
                                    child: Center(
                                      child: positionCharged == false
                                          ? const CircularProgressIndicator(
                                              strokeWidth: 5,
                                            )
                                          : Icon(
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
                                  shape: const CircleBorder(eccentricity: 1),
                                  elevation: 2,
                                  onPressed: () {
                                    togglePause();
                                  },

                                  backgroundColor: buttonColorPause,
                                  child: const Icon(Icons.pause,
                                      size:
                                          35,color: Colors.white,), // Ajusta el color del botón según tus necesidades
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
