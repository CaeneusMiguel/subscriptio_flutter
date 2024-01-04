import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subcript/Screens/home/homeScreen.dart';
import 'package:subcript/Screens/payroll/payroll.dart';
import 'package:subcript/Screens/profile/profileUser.dart';
import 'package:subcript/Screens/register/registerAdminScreen.dart';
import 'package:subcript/Screens/listCheking/chekings.dart';
import 'package:subcript/utils/colors.dart';
import 'package:subcript/utils/widgets/curvedNavigationbar.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  late final PageController _pageController;
  late final List<Widget> _fragments;
  late final CurvedNavigationBarController _navigationController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _navigationController = CurvedNavigationBarController(); // Nuevo
    _fragments = [
      const HomeScreen(),
      const Chekings(),
      const PayRoll(),
      const ProfileUser(),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, index) {
          return _fragments[index];
        },
        itemCount: _fragments.length,
        onPageChanged: (index) {
          setState(() {
            _navigationController.index = index; // Nuevo
          });
        },
      ),
      extendBody: true,
      bottomNavigationBar:
      Container(
        height: 100,
        color: Color(0x00ffffff),
        child: CurvedNavigationBar(
          controller: _navigationController, // Nuevo
          backgroundColor: Color(0x00ffffff),
          buttonBackgroundColor: mainGreenColorButton,
          color: mainColorBlue,
          items: <Widget>[
            SvgPicture.asset(
              "resources/t3_ic_home.svg",
              height: 24,
              width: 24,
              fit: BoxFit.none,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            SvgPicture.asset(
              "resources/t3_ic_msg.svg",
              height: 24,
              width: 24,
              fit: BoxFit.none,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            SvgPicture.asset(
              "resources/document.svg",
              height: 24,
              width: 24,
              fit: BoxFit.none,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            SvgPicture.asset(
              "resources/t3_ic_user.svg",
              height: 24,
              width: 24,
              fit: BoxFit.none,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ],
          onTap: (index) {
            setState(() {
              _navigationController.index = index; // Nuevo
              _pageController.jumpToPage(index);
            });
          },
        ),
      ),
    );
  }
}
