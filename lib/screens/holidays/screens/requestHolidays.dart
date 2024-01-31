import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:subcript/service/controller/holidays_controller.dart';

import 'package:subcript/utils/colors.dart';

import 'package:board_datetime_picker/board_datetime_picker.dart';

class RequestHolidays extends StatefulWidget {
  const RequestHolidays({super.key});

  @override
  State<RequestHolidays> createState() => _RequestHolidaysState();
}

class _RequestHolidaysState extends State<RequestHolidays> {
  HolidaysController con = Get.put(HolidaysController());

  FocusNode newPassword = FocusNode();
  FocusNode confirmPassword = FocusNode();

  final controller = BoardDateTimeController();

  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  20.height,
                  const Text('Solicitud de vacaciones',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold))
                      .paddingSymmetric(horizontal: 0)
                      .center(),
                  10.height,
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  20.height,
                  const Center(
                    child: Text(
                      'Selecciona las fechas en las que deseas solicitar tus vacaciones.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  30.height,
                  const ModalItem(type: 1, message: "Fecha de inicio"),
                  20.height,
                  const ModalItem(type: 2, message: "Fecha de finalización"),
                  30.height,
                  Container(
                    height: 250.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: con.petition_comment,
                        maxLines: null,
                        autofocus: false,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '(Opcional) Motivo de la solicitud...',
                        ),
                      ),
                    ),
                  )
                ],
              ).paddingSymmetric(horizontal: 30),
            ).expand()
          ],
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: mainColorBlue.withAlpha(70),
                  borderRadius: radius(100)),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  finish(context);
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: mainColorBlue, borderRadius: radius(100)),
              child: IconButton(
                icon: const Icon(Icons.check, color: Colors.white),
                onPressed: () {
                  con.requestHolidays(context);

                },
              ),
            )
          ],
        ).paddingSymmetric(horizontal: 30, vertical: 30),
      ),
    );
  }
}

class ModalItem extends StatefulWidget {
  final int type;
  final String message;

  const ModalItem({Key? key, required this.type, required this.message})
      : super(key: key);

  @override
  State<ModalItem> createState() => _ModalItemState();
}

class _ModalItemState extends State<ModalItem> {
  DateTime d = DateTime.now();
  HolidaysController con = Get.put(HolidaysController());

  @override
  Widget build(BuildContext context) {

    return Material(
      borderRadius: BorderRadius.circular(8),
      color: Theme.of(context).cardColor,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          final result = await showBoardDateTimePicker(
            context: context,
            pickerType: DateTimePickerType.date,
            options: BoardDateTimeOptions(
              showDateButton: false,
              activeColor: mainColorBlue,
              languages: const BoardPickerLanguages.es(),
              startDayOfWeek: DateTime.sunday,
              pickerFormat: PickerFormat.ymd,
              boardTitle: widget.message,
              pickerSubTitles: const BoardDateTimeItemTitles(
                  year: 'Año', month: 'Mes', day: 'Dia'),
            ),
            onResult: (val) {},
          );
          if (result != null) {
            setState(() => d = result);
            //print(result);
            if (widget.type == 1) {
              String formattedDate = DateFormat('dd/MM/yyyy').format(d);
              con.startHolidays = formattedDate;
            } else {
              String formattedDate = DateFormat('dd/MM/yyyy').format(d);
              con.endHolidays = formattedDate;
            }
            setState(() {});
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              Material(
                color: mainColorBlue,
                borderRadius: BorderRadius.circular(4),
                child: const SizedBox(
                  height: 36,
                  width: 36,
                  child: Center(
                    child: Icon(
                      Icons.date_range,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  BoardDateFormat('yyyy/MM/dd ').format(d),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Text(
                widget.message,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
