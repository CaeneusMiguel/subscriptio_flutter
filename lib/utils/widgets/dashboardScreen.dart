import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subcript/Screens/home/homeScreen.dart';
import 'package:subcript/Screens/payroll/payroll.dart';
import 'package:subcript/Screens/profile/profileUser.dart';
import 'package:subcript/Screens/register/registerAdminScreen.dart';
import 'package:subcript/Screens/prototype.dart';
import 'package:subcript/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:subcript/utils/widgets/curvedNavigationbar.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {

  int selectedTab = 0;
  late final PageController _pageController;
  late final List<Widget> _fragments;

  @override
  void initState() {
    _pageController = PageController(initialPage: selectedTab );
    _fragments = [
      const HomeScreen(),
      //const RegisterScreen(),
      const Prototype(),
      const PayRoll(),
      const ProfileUser()

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
            selectedTab = index;
          });
        },
      ),
      bottomNavigationBar: Container(
        height: 100,
        color: context.scaffoldBackgroundColor,
        child: CurvedNavigationBar(
          backgroundColor: context.scaffoldBackgroundColor,
          buttonBackgroundColor: mainGreenColorButton,
          color: mainColorBlue,
          items: <Widget>[
            SvgPicture.asset("resources/t3_ic_home.svg", height: 24, width: 24, fit: BoxFit.none,colorFilter: const ColorFilter.mode(Colors.white,BlendMode.srcIn), ),
            SvgPicture.asset("resources/t3_ic_msg.svg", height: 24, width: 24, fit: BoxFit.none, colorFilter: const ColorFilter.mode(Colors.white,BlendMode.srcIn),),
            SvgPicture.asset("resources/document.svg", height: 24, width: 24, fit: BoxFit.none,colorFilter: const ColorFilter.mode(Colors.white,BlendMode.srcIn), ),
            SvgPicture.asset("resources/t3_ic_user.svg", height: 24, width: 24, fit: BoxFit.none,colorFilter: const ColorFilter.mode(Colors.white,BlendMode.srcIn),),
          ],
          onTap: (index) {
            setState(() {
              selectedTab = index;
              _pageController.jumpToPage(index);
            });
          },
        ),
      ),
    );
  }
}
