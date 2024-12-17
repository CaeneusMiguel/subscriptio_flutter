import 'package:flutter/material.dart';
import 'package:gradient_progress_indicator/widget/gradient_progress_indicator_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:subcript/ui/theme/colors.dart';

class ShimmerPlayPauseButton extends StatefulWidget {
  final bool isPlaying;
  final bool isPause;

  ShimmerPlayPauseButton({super.key, required this.isPlaying, required this.isPause});

  @override
  State<ShimmerPlayPauseButton> createState() => _ShimmerPlayPauseButtonState();
}

class _ShimmerPlayPauseButtonState extends State<ShimmerPlayPauseButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.6),
            highlightColor: Colors.grey,
            child: ShimmerLayout(num: 140, expan: false),
          ),
          Positioned(
            child: GestureDetector(
              onTap: () {
                // Agrega tu lógica aquí al hacer clic en el botón de reproducción/pausa
              },
              child: GradientProgressIndicator(
                radius: 140,
                duration: 5,
                strokeWidth: 12,
                gradientStops: [0.8, 0.9],
                gradientColors: [
                  widget.isPlaying ? redColorButton : greenColorButton,
                  mainColorBlue,
                ],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.isPlaying ? Icons.stop : Icons.play_arrow,
                      size: 90,
                      color: widget.isPlaying ? redColorButton : greenColorButton,
                    ),
                    // Otras partes del contenido si es necesario
                  ],
                ),
              ),
            ),
          ),
          if (!widget.isPause)
            Positioned(
              bottom: -0.00 * MediaQuery.of(context).size.height,
              right: MediaQuery.of(context).size.height * 0.10,
              child: Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(0.6),
                highlightColor: Colors.grey,
                child: ShimmerLayout(num: 80, expan: true),
              ),
            ),
        ],
      ),
    );
  }
}

class ShimmerLayout extends StatefulWidget {
  final double num;
  final bool expan;

  ShimmerLayout({super.key, required this.num, required this.expan});

  @override
  State<ShimmerLayout> createState() => _ShimmerLayoutState();
}

class _ShimmerLayoutState extends State<ShimmerLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!widget.expan)
            Container(
              height: 70,
              width: widget.num,
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.circular(8),
              ),
            )
          else
            Expanded(
              child: Container(
                height: 70,
                width: widget.num,
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
