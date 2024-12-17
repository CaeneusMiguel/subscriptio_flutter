import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subcript/ui/features/organized_time/screens/shift_screens/change_shift.dart';
import 'package:subcript/ui/features/organized_time/screens/shift_screens/current_shift.dart';
import 'package:subcript/ui/theme/colors.dart';

class Turne extends StatefulWidget {
  const Turne({super.key});

  @override
  State<Turne> createState() => _TurneState();
}

class _TurneState extends State<Turne> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabBar(

                    indicatorColor: mainColorBlue,
                    labelColor: mainColorBlue,
                    dividerHeight: 0,
                    controller: _tabController,
                    tabs:  const [
                      Tab(
                        child: Text(
                          "Actuales",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
                        ),

                      ),
                      Tab(
                        child: Text(
                          "Solicitados",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),

                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height -250,
                    // Ajusta la altura del TabBarView según sea necesario
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        // Contenido de la primera página del TabBarView
                        CurrentShift(),
                        // Contenido de la segunda página del TabBarView
                        ChangeShift(),
                        // Contenido de la tercera página del TabBarView

                      ],
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
