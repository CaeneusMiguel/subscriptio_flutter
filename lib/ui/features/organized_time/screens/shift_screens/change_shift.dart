import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/ui/theme/colors.dart';

class ChangeShift extends StatefulWidget {
  const ChangeShift({super.key});

  @override
  State<ChangeShift> createState() => _ChangeShiftState();
}

class _ChangeShiftState extends State<ChangeShift> {
  final ScrollController _scrollController = ScrollController();

  List<MyObject> myObjectList = [
    MyObject(
        startTime: DateTime.utc(2024, 3, 8, 8, 0),
        // Ejemplo de fecha y hora de inicio
        endTime: DateTime.utc(2024, 3, 8, 17, 0),
        color: orangeColorButton),
    MyObject(
        startTime: DateTime.utc(2024, 3, 9, 9, 0),
        endTime: DateTime.utc(2024, 3, 9, 18, 0),
        color: mainGreenColorButton),
    MyObject(
        startTime: DateTime.utc(2024, 3, 9, 10, 0),
        endTime: DateTime.utc(2024, 3, 9, 10, 0),
        color: mainGreenColorButton),
    MyObject(
        startTime: DateTime.utc(2024, 3, 10, 11, 0),
        endTime: DateTime.utc(2024, 3, 10, 11, 0),
        color: mainGreenColorButton),
    MyObject(
        startTime: DateTime.utc(2024, 3, 17, 9, 0),
        endTime: DateTime.utc(2024, 3, 17, 18, 0),
        color: redColorButton),
    MyObject(
        startTime: DateTime.utc(2024, 3, 18, 9, 0),
        endTime: DateTime.utc(2024, 3, 18, 18, 0),
        color: redColorButton),
    MyObject(
        startTime: DateTime.utc(2024, 3, 19, 9, 0),
        endTime: DateTime.utc(2024, 3, 19, 18, 0),
        color: mainGreenColorButton),
  ];

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0,right: 5,left: 5),
          child: Column(
            children: [

              Expanded(
                child: GroupedListView<dynamic, String>(
                    controller: _scrollController,
                    stickyHeaderBackgroundColor: Colors.white,
                    useStickyGroupSeparators: true,
                    elements: myObjectList,
                    groupBy: (element) => formatSpanishDate(element.startTime),
                    groupSeparatorBuilder: (String value) {
                      return Container(
                        decoration: const BoxDecoration(
                            color: Colors.transparent,
                            borderRadius:
                            BorderRadius.all(Radius.circular(6))),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            value,
                            style:  const TextStyle(
                              color: mainColorBlue,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                    itemBuilder: (context, dynamic element) {
                      return Column(
                        children: [
                          Card(
                            elevation: 2,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ClipPath(
                              clipper: ShapeBorderClipper(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(8))),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    left: BorderSide(
                                        color: element.color,
                                        width: 8),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0, vertical: 10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${DateFormat('HH:mm').format(element.startTime)} - ${DateFormat('HH:mm').format(
                                            element.endTime)}",
                                        style:  TextStyle(
                                          fontFamily: "Anta",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22.0,
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                      ),

                                      15.height,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor: mainColorBlue,
                                            // Color del fondo del avatar
                                            child: Image.asset(
                                              "resources/defaultImage.png",
                                              color: Colors.white,
                                            ), // Ícono dentro del avatar
                                          ),
                                          Icon(
                                            Icons.change_circle_outlined,
                                            size: 40,
                                            color:
                                                Colors.black.withOpacity(0.6),
                                          ),
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.white,
                                            // Color del fondo del avatar
                                            child: Image.asset(
                                              "resources/defaultImage.png",
                                              color: mainColorBlue,
                                            ), // Ícono dentro del avatar
                                          ),
                                        ],
                                      ),
                                      15.height,
                                      Text(
                                        "${DateFormat('HH:mm').format(element.startTime)} - ${DateFormat('HH:mm').format(
                                            element.endTime)}",
                                        style:  TextStyle(
                                          fontFamily: "Anta",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22.0,
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          15.height
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyObject {
  final DateTime startTime;
  final DateTime endTime;
  final Color color;

  MyObject(
      {required this.startTime, required this.endTime, required this.color});
}
