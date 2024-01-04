import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:subcript/service/controller/cheking_controller.dart';
import 'package:subcript/service/models/listCheking.dart';
import 'package:subcript/service/models/userLogin.dart';
import 'package:subcript/utils/colors.dart';

class Chekings extends StatefulWidget {
  const Chekings({Key? key}) : super(key: key);

  @override
  State<Chekings> createState() => _ChekingsState();
}

class _ChekingsState extends State<Chekings> {
  List<ListCheking> chekings = [];
  UserLogin? userSession;
  ChekingController con = Get.put(ChekingController());

  @override
  void initState() {
    userSession = UserLogin.fromJson(GetStorage().read('user'));
    getlistCheking();
    super.initState();
  }

  getlistCheking() async {
    chekings = await con.chekingList();
    chekings = chekings.reversed.toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final groupedCheckings = groupBy(chekings, (ListCheking checking) {
      final date =
      checking.checkedIn.date.toLocal(); // Convertir a la zona horaria local
      return '${date.year}-${date.month.toString().padLeft(2, '0')}';
    });

    final sortedDates = groupedCheckings.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    List<Map<String, dynamic>> transformedList = [];

    sortedDates.forEach((dateKey) {
      groupedCheckings[dateKey]!.forEach((checking) {
        String formattedCheckedInTime =
        DateFormat('HH:mm').format(checking.checkedIn.date);
        String formattedCheckedOutTime = checking.checkedOut != null
            ? DateFormat('HH:mm').format(checking.checkedOut!.date)
            : '';

        transformedList.add({
          'date': DateFormat('yyyy-MM-dd').format(checking.checkedIn.date),
          'checkedIn': formattedCheckedInTime,
          'checkedOut': formattedCheckedOutTime,
          'totalhours': checking.numberOfHours,
        });
      });
    });

    return Scaffold(
      
      extendBody: true,
      body: transformedList.isEmpty
          ? const Center(
        child: Text(
          "No tienes ningún registro horario",
          style: TextStyle(fontSize: 18),
        ),
      )
          : userSession?.companyChekingList == true
          ? SafeArea(
        top: true,
            bottom: false
        ,
            child: GroupedListView<dynamic, String>(
        useStickyGroupSeparators: true,
        elements: transformedList,
        groupBy: (element) => element['date'],
        groupSeparatorBuilder: (String value) => Container(
            padding: const EdgeInsets.all(16),
            color: mainColorBlue,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
        ),
        itemBuilder: (context, dynamic element) {
            return Card(
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Inicio: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              element['checkedIn'],
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                        if (element['checkedOut'] != null)
                          Row(
                            children: [
                              const Text(
                                "Finalización: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                element['checkedOut'],
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),

                    const SizedBox(height: 10.0),
                    if (element['totalhours'] != null)
                      Row(
                        children: [
                          const Text(
                            "Tiempo trabajado: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '${element['totalhours']} h',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
        },
        order: GroupedListOrder.DESC,
      ),
          )
          : const Center(
        child: Text(
          "Deshabilitado registro de horarios",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
