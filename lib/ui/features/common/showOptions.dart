import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/data/check_in/model/listCheking.dart';
import 'package:subcript/data/check_in/model/purpose.dart';
import 'package:subcript/data/check_in/repository/controller/cheking_controller.dart';
import 'package:subcript/data/check_in/repository/provider/cheking_provider.dart';
import 'package:subcript/ui/theme/colors.dart';

ChekingController con = Get.put(ChekingController());

void showOptionParameter(BuildContext context, List<Purpose> listOption,
    void Function(bool) callback, void Function(Purpose) callback2) {
  showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
          borderRadius: radiusOnly(topLeft: 30, topRight: 30)),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Tipos de pausas:',
                        style: TextStyle(fontSize: 24)),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        finish(context);
                      },
                      icon:
                          const Icon(Icons.cancel_rounded, color: Colors.black),
                    ),
                  ),
                ],
              ),
              16.height,
              Wrap(
                children: listOption.map((e) {
                  int index = listOption.indexOf(e);
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Response validatorPause = await con.pause(e.id);

                          if (validatorPause.body['data']['id'] != null) {
                            setState(() {
                              Purpose element = e;
                              callback(true);
                              GetStorage().write('startTime', DateTime.now());
                              GetStorage().write('totalTime',
                                  (element.estimatedTime! * 60).toInt());
                              callback2(element);
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                8.width,
                                Text(e.purpose,
                                    style: primaryTextStyle(
                                        color: mainColorBlue,
                                        weight: fontWeightBoldGlobal)),
                              ],
                            ),
                            Text("(${e.estimatedTime?.toStringAsFixed(0)} m)",
                                style: primaryTextStyle(
                                    color: mainColorBlue,
                                    weight: fontWeightBoldGlobal)),

                            /* IconButton(
                                  icon:  const Icon(Icons.check_circle,
                                      color: mainColorBlue),

                                  onPressed: () {

                                  },
                                ),*/
                          ],
                        ),
                      ),
                      20.height
                    ],
                  );
                }).toList(),
              ),
              30.height,
            ],
          ).paddingAll(16);
        });
      });
}

void showOptionParameterCheckInCheckOut(BuildContext context,
    List<Purpose> listOption, String userName, String pin) {
  showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
          borderRadius: radiusOnly(topLeft: 30, topRight: 30)),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Tipos de pausas:',
                        style: TextStyle(fontSize: 24)),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        finish(context);
                      },
                      icon:
                          const Icon(Icons.cancel_rounded, color: Colors.black),
                    ),
                  ),
                ],
              ),
              16.height,
              Wrap(
                children: listOption.map((e) {
                  int index = listOption.indexOf(e);
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await ChekingProvider()
                              .checkInCheckOutPause(pin, userName, e.id, null);

                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                8.width,
                                Text(e.purpose,
                                    style: primaryTextStyle(
                                        color: mainColorBlue,
                                        weight: fontWeightBoldGlobal)),
                              ],
                            ),
                            Text("(${e.estimatedTime?.toStringAsFixed(0)} m)",
                                style: primaryTextStyle(
                                    color: mainColorBlue,
                                    weight: fontWeightBoldGlobal)),

                            /* IconButton(
                                  icon:  const Icon(Icons.check_circle,
                                      color: mainColorBlue),

                                  onPressed: () {

                                  },
                                ),*/
                          ],
                        ),
                      ),
                      20.height
                    ],
                  );
                }).toList(),
              ),
              30.height,
            ],
          ).paddingAll(16);
        });
      });
}

String _convertToHoursAndMinutes(double? totalMinutes) {
  int totalMinutesInt = totalMinutes?.toInt() ?? 0;
  int hours = totalMinutesInt ~/ 60;
  int minutes = totalMinutesInt % 60;

  return '$hours h  $minutes m';
}

void showPurposesBreaks(BuildContext context, List<PurposeElement> listOption) {
  showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
          borderRadius: radiusOnly(topLeft: 30, topRight: 30)),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Pausas:', style: TextStyle(fontSize: 24)),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        finish(context);
                      },
                      icon:
                          const Icon(Icons.cancel_rounded, color: Colors.black),
                    ),
                  ),
                ],
              ),
              16.height,
              Wrap(
                children: listOption.map((e) {
                  int index = listOption.indexOf(e);
                  return e.purpose != null
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(e.purpose ?? '',
                                    style: primaryTextStyle(
                                        color: mainColorBlue,
                                        weight: fontWeightBoldGlobal)),
                                Text(
                                    "${DateFormat('HH:mm').format(e.breakIn!.date)} - ${DateFormat('HH:mm').format(e.breakOut!.date)}" ??
                                        '',
                                    style: primaryTextStyle(
                                        color: mainColorBlue,
                                        weight: fontWeightBoldGlobal)),
                                Text(_convertToHoursAndMinutes(e.timeOfbreak),
                                    style: primaryTextStyle(
                                        color: mainColorBlue,
                                        weight: fontWeightBoldGlobal)),
                              ],
                            ),
                            10.height
                          ],
                        )
                      : Container();
                }).toList(),
              ),
              30.height,
            ],
          ).paddingAll(16);
        });
      });
}
