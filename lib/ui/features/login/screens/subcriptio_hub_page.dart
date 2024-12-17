import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/data/check_in/model/purpose.dart';
import 'package:subcript/data/check_in/repository/controller/checkin_checkout_controllet.dart';
import 'package:subcript/data/check_in/repository/provider/cheking_provider.dart';
import 'package:subcript/ui/features/common/confirmDialogHub.dart';
import 'package:subcript/ui/features/common/showOptions.dart';
import 'package:subcript/ui/features/common/widgets/buttonMaterialCustom.dart';
import 'package:subcript/ui/features/common/widgets/textFieldCustom.dart';
import 'package:subcript/ui/theme/colors.dart';

class SubcriptioHubPage extends StatefulWidget {
  const SubcriptioHubPage({super.key});

  @override
  State<SubcriptioHubPage> createState() => _SubcriptioHubPageState();
}

class _SubcriptioHubPageState extends State<SubcriptioHubPage> {
  FocusNode password = FocusNode();
  FocusNode userName = FocusNode();
  String? currentYear;
  bool _obscurePin = true; // Controla si el PIN está oculto o visible
  ChekingCheckoutController con = Get.put(ChekingCheckoutController());

  @override
  void initState() {
    super.initState();
    currentYear = DateTime.now().year.toString();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: mainColorBlue,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              50.height,
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Image.asset(
                    'resources/logo_light.png',
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ).animate().fade(delay: 400.ms).slideY(),
                ),
              ),
              40.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFieldCustom(
                  controller: con.cifController,
                  color: Colors.white,
                  colorText: Colors.white,
                  textFieldType: TextFieldType.EMAIL,
                  focus: userName,
                  autofocus: false,
                  border: 25.0,
                  nameLabel: "Usuario",
                ).animate().fade(delay: 500.ms).slideY(),
              ),
              30.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  cursorColor: Colors.white,
                  autofocus: false,
                  controller: con.pinController,
                  focusNode: password,
                  obscureText: _obscurePin,
                  decoration: InputDecoration(
                    labelText: "PIN",
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0),
                    contentPadding: EdgeInsets.symmetric(horizontal: 32.0,vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePin ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePin = !_obscurePin;
                        });
                      },
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                ).animate().fade(delay: 600.ms).slideY(),
              ),
              40.height,
              ButtonMaterialCustom(
                      nameButton: 'Fichar',
                      pHorizontal: 80,
                      pVertical: 15,
                      borderSize: 6,
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();

                        await FirebaseMessaging.instance
                            .getToken()
                            .then((value) async {
                          GetStorage().write('tokenMessage', value);
                          await con.chekingCheckout().then((value) {
                            con.cifController.text = '';
                            con.pinController.text = '';
                          });
                        });
                      },
                      colorButton: mainGreenColorButton,
                      textColor: Colors.white,
                      textSize: 16)
                  .animate()
                  .fade(delay: 700.ms)
                  .slideY(),
              20.height,
              ButtonMaterialCustom(
                      nameButton: 'Fichar Pausa',
                      pHorizontal: 55,
                      pVertical: 15,
                      borderSize: 6,
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();

                        int response = await ChekingProvider()
                            .checkInCheckOutPause(con.pinController.text.trim(),
                                con.cifController.text.trim(), null, null);
                        if (response == 1) {
                          List<Purpose> options = await con.pausePurposeList();
                          if (options.isNotEmpty) {
                            showOptionParameterCheckInCheckOut(
                                context,
                                options,
                                con.cifController.text.trim(),
                                con.pinController.text.trim());
                            con.cifController.text = '';
                            con.pinController.text = '';
                          } else {
                            Get.snackbar('Error',
                                'No se han encontrado descansos de empresa',
                                backgroundColor: redColorButton,
                                colorText: Colors.white);
                          }
                        } else {
                          con.cifController.text = '';
                          con.pinController.text = '';
                        }
                      },
                      colorButton: orangeColorButton,
                      textColor: Colors.white,
                      textSize: 16)
                  .animate()
                  .fade(delay: 700.ms)
                  .slideY(),
              40.height,
              GestureDetector(
                onTap: () {
                  Get.toNamed('/recoverPin');
                },
                child: Center(
                  child: const Text('¿Olvidaste tu pin?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white))
                      .animate()
                      .fade(delay: 900.ms)
                      .slideY(),
                ),
              ).animate().fade(delay: 700.ms).slideY(),
              40.height,
              30.height,
              Expanded(child: Container()),
              Center(
                child: Text(
                  "© $currentYear Studio128k.",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ).animate().fade(delay: 1000.ms).slideY(),
              ),
              20.height,
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 10.0, bottom: 20),
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return ConfirmDialogHub(
                    title: "Cerrar Hub",
                    message: "Por favor, introduce tus credenciales.",
                    onConfirm: () {},
                  );
                },
              );
            },
            elevation: 0,
            hoverElevation: 0,
            highlightElevation: 0,
            splashColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            child: SpinningIcon(
              icon: SvgPicture.asset(
                'resources/hub_2.svg',
                width: 62,
                height: 62,
                color: Colors.white,
              ),
              duration: const Duration(seconds: 5),
            ),
          ),
        ),
      ),
    );
  }
}

class SpinningIcon extends StatefulWidget {
  final Widget icon;
  final Duration duration;

  const SpinningIcon({
    Key? key,
    required this.icon,
    this.duration = const Duration(seconds: 5),
  }) : super(key: key);

  @override
  _SpinningIconState createState() => _SpinningIconState();
}

class _SpinningIconState extends State<SpinningIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _startTimer();
  }

  void _startTimer() {
    _controller.forward(from: 0.0).then((_) {
      _controller.stop();
    });

    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _controller.forward(from: 0.0).then((_) {
        _controller.stop();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.icon,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2.0 * 3.141592653589793,
          child: child,
        );
      },
    );
  }
}
