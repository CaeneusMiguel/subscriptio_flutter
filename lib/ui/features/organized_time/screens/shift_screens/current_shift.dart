import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/ui/theme/colors.dart';

class CurrentShift extends StatefulWidget {
  const CurrentShift({super.key});

  @override
  State<CurrentShift> createState() => _CurrentShiftState();
}

class _CurrentShiftState extends State<CurrentShift> {
  final ScrollController _scrollController = ScrollController();

  List<MyObject> myObjectList = [
    MyObject(
        startTime: DateTime.utc(2024, 3, 8, 8, 0),
        // Ejemplo de fecha y hora de inicio
        endTime: DateTime.utc(2024, 3, 8, 17, 0),
        color: mainColorBlue),
    MyObject(
        startTime: DateTime.utc(2024, 3, 8, 20, 0),
        endTime: DateTime.utc(2024, 3, 8, 5, 0),
        color: mainColorBlue),
    MyObject(
        startTime: DateTime.utc(2024, 3, 9, 10, 0),
        endTime: DateTime.utc(2024, 3, 9, 10, 0),
        color: mainColorBlue),
    MyObject(
        startTime: DateTime.utc(2024, 3, 9, 21, 0),
        endTime: DateTime.utc(2024, 3, 9, 7, 0),
        color: mainColorBlue),
    MyObject(
        startTime: DateTime.utc(2024, 3, 11, 12, 0),
        endTime: DateTime.utc(2024, 3, 11, 12, 0),
        color: mainColorBlue),
    MyObject(
        startTime: DateTime.utc(2024, 3, 11, 13, 0),
        endTime: DateTime.utc(2024, 3, 11, 21, 0),
        color: mainColorBlue),
    MyObject(
        startTime: DateTime.utc(2024, 3, 13, 14, 0),
        endTime: DateTime.utc(2024, 3, 13, 20, 0),
        color: mainColorBlue),
    MyObject(
        startTime: DateTime.utc(2024, 3, 13, 21, 0),
        endTime: DateTime.utc(2024, 3, 13, 8, 0),
        color: mainColorBlue),
    MyObject(
        startTime: DateTime.utc(2024, 3, 15, 9, 0),
        endTime: DateTime.utc(2024, 3, 15, 18, 0),
        color: mainColorBlue),
    MyObject(
        startTime: DateTime.utc(2024, 3, 16, 9, 0),
        endTime: DateTime.utc(2024, 3, 16, 18, 0),
        color: mainColorBlue),
    MyObject(
        startTime: DateTime.utc(2024, 3, 17, 9, 0),
        endTime: DateTime.utc(2024, 3, 17, 18, 0),
        color: mainColorBlue),
    MyObject(
        startTime: DateTime.utc(2024, 3, 18, 9, 0),
        endTime: DateTime.utc(2024, 3, 18, 18, 0),
        color: mainColorBlue),
    MyObject(
        startTime: DateTime.utc(2024, 3, 19, 9, 0),
        endTime: DateTime.utc(2024, 3, 19, 18, 0),
        color: mainColorBlue),
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
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                       vertical: 15),
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
                              style:  TextStyle(
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
                                        borderRadius: BorderRadius.circular(8))),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      left: BorderSide(
                                          color: element.color,
                                          width: 6),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 20),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  DateFormat('HH:mm')
                                                      .format(element.startTime),
                                                  style:  TextStyle(
                                                    fontFamily: "Anta",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22.0,
                                                    color: Colors.black.withOpacity(0.6),
                                                  ),
                                                ),
                                                 Text(
                                                  " - ",
                                                  style: TextStyle(
                                                    fontFamily: "Anta",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22.0,
                                                    color: Colors.black.withOpacity(0.6),
                                                  ),
                                                ),
                                                Text(
                                                  DateFormat('HH:mm').format(
                                                      element.endTime),
                                                  style:  TextStyle(
                                                    fontFamily: "Anta",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22.0,
                                                    color: Colors.black.withOpacity(0.6),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                 Icon(Icons.remove_red_eye,color: Colors.black.withOpacity(0.6),),
                                                10.width,
                                                 Icon(
                                                    Icons.change_circle_outlined,color: Colors.black.withOpacity(0.6),)
                                              ],
                                            ),
                                          ],
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
