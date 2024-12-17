import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/ui/features/login/screens/login_page.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'resources/splash_video.mp4', // Ruta del archivo de video
    )..initialize().then((_) {
      // Reproduce el video una vez que está inicializado
      _controller.play();
    });

    // Espera unos segundos antes de navegar a la siguiente pantalla
    Future.delayed(
      const Duration(seconds: 6),
          () {
        // Navega a la siguiente pantalla
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => LoginScreen(),
          ),
        );
      },
    );

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent, // Cambia el color de fondo de la barra de estado
      statusBarIconBrightness: Brightness.light, // Cambia el color del texto en la barra de estado
    ));
  }

  @override
  void dispose() {
    // Libera los recursos del controlador de video
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Transform.scale(
              scaleX: 2,
              scaleY: 1.2, // Factor de escala para aplicar zoom
              child: VideoPlayer(_controller),
            ),
          ),
          40.height
        ],
      ),
    );
  }
}
