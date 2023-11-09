import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/service/controller/cheking_controller.dart';
import 'package:subcript/service/models/userLogin.dart';
import 'package:subcript/utils/colors.dart';
import 'package:subcript/utils/widgets/customAlertDialogInfo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime dateNow = DateTime.now();
  List<String> monthDate = [
    'Ene',
    'Feb',
    'Mar',
    'Abr',
    'May',
    'Jun',
    'Jul',
    'Ago',
    'Sep',
    'Oct',
    'Nov',
    'Dic',
  ];

  late int day;
  late String month;
  late String year;
  bool isPlaying = false;
  bool isPause = true;
  bool active = true;
  Color buttonColorPlay = greenColorButton;
  Color buttonColorPause = greyColorButton;
  IconData iconDataPlay = Icons.play_arrow;
  IconData iconDataPause = Icons.pause;
  int elapsedTime = 0;
  StreamSubscription<int>? timerSubscription;
  String? startTime;
  UserLogin? userSession;
  String? name;
  bool action=false;

  ChekingController con = Get.put(ChekingController());

  @override
  void initState() {
    print(dateNow.day.toString());
    day = dateNow.day;
    month = monthDate[dateNow.month - 1];
    year = dateNow.year.toString();
    startTime=GetStorage().read("cheking");
    userSession = UserLogin.fromJson(GetStorage().read('user'));
    name=userSession?.userName ?? '';
    getIsCheking();

    super.initState();
  }

  @override
  void dispose() {
    // Asegúrate de cancelar la suscripción al destruir el widget
    //_timerController?.close();
    // timerSubscription?.cancel();

    super.dispose();
  }

  Future<void> getIsCheking() async {
    await con.getIsCheking().then((value) {

      if(value.body['data']['isCheckIn']==false){
        isPlaying=false;
        buttonColorPlay=greenColorButton;
        iconDataPlay=Icons.play_arrow;
        }else{
          isPlaying=true;
          buttonColorPlay=redColorButton;
          iconDataPlay=Icons.stop;
        }
      action=true;
      setState(() {

      });
    });
  }

  String getCurrentTime() {
    final now = DateTime.now();

      String formattedTime=
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString()
          .padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  void togglePlayClose() {
    setState(() {
      if(action!=false) {
        isPlaying = !isPlaying;

        if (isPlaying) {
          con.cheking();
          GetStorage().write("activeCheking", isPlaying);
          startTime = getCurrentTime();
          GetStorage().write("cheking", startTime);
          buttonColorPlay = isPlaying ? redColorButton : greenColorButton;
          iconDataPlay = isPlaying ? Icons.stop : Icons.play_arrow;
        } else {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                CustomAlertDialogInfo(
                  title: "Terminar jornada",
                  message:
                  "¿Estas seguro de que deseas terminar la jornada laboral?",
                  onConfirm: () {
                    con.cheking();
                    setState(() {
                      GetStorage().write("activeCheking", isPlaying);
                      startTime = getCurrentTime();
                      GetStorage().write("cheking", startTime);
                      buttonColorPlay =
                      isPlaying ? redColorButton : greenColorButton;
                      iconDataPlay = isPlaying ? Icons.stop : Icons.play_arrow;
                    });

                    Navigator.of(context).pop();
                  },
                  onCancel: () {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                    Navigator.of(context).pop();
                  },
                ),
          );
        }
      }
    });
  }

  void togglePause() {
    setState(() {
      isPause = !isPause;
      if (!isPause) {
        print("Entra en comenzar contador");

        startTimerPause();
      } else {
        print("entra en cancelar stream");
        stopTimerPause();
      }
      buttonColorPause = isPause ? greyColorButton : orangeColorButton;
      iconDataPause = isPause ? Icons.pause : Icons.play_arrow;
    });
  }

  void startTimerPause() {
    // Empezar a emitir eventos en el StreamController

    timerSubscription = Stream.periodic(const Duration(seconds: 1), (x) => x)
        .listen((int tick) {
      //_timerController!.add(tick); // Emitir un evento en el StreamController
      setState(() {
        elapsedTime = tick;
      });
      //print(_timerController.toString());
    });
  }

  void stopTimerPause() {
    // Detener el contador y restablecer el tiempo

    timerSubscription?.cancel();

    elapsedTime = 0;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            20.height,
            Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'resources/logo_name.png',
                  width: 150,
                  fit: BoxFit.fitWidth,
                )),
            60.height, Text(
              'Bienvenid@ $name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            20.height,
            Text(
              '${day} $month. $year',
              style: const TextStyle(fontSize: 18),
            ),
            90.height,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: buttonColorPlay,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: togglePlayClose,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        iconDataPlay,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        isPlaying ? 'Finalizar' : 'Empezar',
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(startTime ?? "00:00:00",
                        style: const TextStyle(fontSize: 18,color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            20.height,
            /*Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: AnimatedOpacity(
                opacity: isPlaying ? 1.0 : 0.0,
                duration: Duration(microseconds: 500),
                child: AnimatedContainer(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  duration: Duration(milliseconds: 500),
                  height: 65,
                  decoration: BoxDecoration(
                    color: buttonColorPause,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: togglePause,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          iconDataPause,
                          size: 50,
                          color: Colors.white,
                        ),

                        Text(
                          isPause ? 'Pausar ' : 'Reanudar ',
                          style: const TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${(elapsedTime ~/ 3600).toString().padLeft(2, '0')}:${((elapsedTime ~/ 60) % 60).toString().padLeft(2, '0')}:${(elapsedTime % 60).toString().padLeft(2, '0')}',
                          style:
                          const TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
