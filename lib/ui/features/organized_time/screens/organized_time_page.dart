import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subcript/ui/features/organized_time/screens/holidays_screens/holidays.dart';
import 'package:subcript/ui/features/organized_time/screens/shift_screens/shift.dart';
import 'package:subcript/ui/theme/colors.dart';

class OrganizedTime extends StatefulWidget {
  const OrganizedTime({super.key});

  @override
  State<OrganizedTime> createState() => _OrganizedTimeState();
}

class _OrganizedTimeState extends State<OrganizedTime> {
  List<String> tabs = ["Turnos", "Vacaciones"];
  int current = 0;

@override
  void initState() {

    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent, // Cambia el color de fondo de la barra de estado
      statusBarIconBrightness: Brightness.dark, // Cambia el color del texto en la barra de estado
    ));
  }
  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme.bodyLarge;
    final selectedTextStyle = textStyle?.copyWith(fontSize:18,fontWeight: FontWeight.bold);

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,
          extendBody: true,
          body: SafeArea(
            top: true,
            bottom: false,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Material(
                    elevation:3,
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      decoration: BoxDecoration(borderRadius:BorderRadius.circular(50),border: Border.all(color: Colors.transparent,width: 0)) ,
                      child: SegmentedTabControl(
                        barDecoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color:Colors.grey.shade300 ),
                        //indicatorColor: Colors.orange.shade200,
                        tabTextColor: Colors.black45,
                        selectedTabTextColor: Colors.white,
                        squeezeIntensity: 2,
                        height: 44,
                        tabPadding: const EdgeInsets.symmetric(horizontal: 8),
                        textStyle: selectedTextStyle,
                        selectedTextStyle: selectedTextStyle,
                        // Options for selection
                        // All specified values will override the [SegmentedTabControl] setting
                        tabs:  [
                          SegmentTab(
                            splashHighlightColor: Colors.transparent,
                            label: 'Turnos',
                            // For example, this overrides [indicatorColor] from [SegmentedTabControl]
                            color: mainColorBlue,
                            selectedTextColor: Colors.white,
                            backgroundColor: Colors.white,
                            textColor: Colors.black.withOpacity(0.7),
                          ),
                          SegmentTab(
                            label: 'Vacaciones',
                            color: mainColorBlue,
                            backgroundColor: Colors.white,
                            selectedTextColor: Colors.white,
                            textColor: Colors.black.withOpacity(0.7),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                // Sample pages
                const Padding(
                  padding: EdgeInsets.only(top: 90),
                  child: TabBarView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Turne(),
                      Holidays()

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  }
}


class SampleWidget extends StatelessWidget {
  const SampleWidget({
    Key? key,
    required this.label,
    required this.color,
  }) : super(key: key);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Text(label),
    );
  }
}
