import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/data/auth/model/companyConfi.dart';
import 'package:subcript/data/auth/model/userLogin.dart';
import 'package:subcript/data/check_in/repository/controller/cheking_controller.dart';
import 'package:subcript/ui/features/check_in/screens/check_in_page.dart';
import 'package:subcript/ui/features/common/widgets/curvedNavigationbar.dart';
import 'package:subcript/ui/features/document/screens/document_page.dart';
import 'package:subcript/ui/features/list_check_in/screens/list_check_in_page.dart';
import 'package:subcript/ui/features/organized_time/screens/holidays_screens/holidays.dart';
import 'package:subcript/ui/features/profile/screens/profile_user_page.dart';
import 'package:subcript/ui/theme/colors.dart';


class DashBoardScreen extends StatefulWidget {
  int? indexBar;
   DashBoardScreen({Key? key,required this.indexBar}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> with WidgetsBindingObserver{
  late final PageController _pageController;
  late final List<Widget> _fragments;
  UserLogin? userSession;

  late final CurvedNavigationBarController _navigationController;
  ChekingController con = Get.put(ChekingController());

  CompanyConfi? configCompany;
  @override
  void initState() {
    _getConfig();

    _navigationController = CurvedNavigationBarController();
    _pageController = PageController(initialPage: widget.indexBar ?? 0);
    userSession = UserLogin.fromJson(GetStorage().read('user'));
    _fragments = [
      const CheckinPage(),
      const Chekings(),
      if (userSession?.companyHolidays ?? false) const Holidays(),
      const PayRoll(),
      const ProfileUser(),
    ];

    super.initState();
    _navigationController.setInitialIndex(_pageController.initialPage ?? 0);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _getConfig();

    }
  }

  Future<void> _getConfig() async {
    configCompany = await con.getConfigCompany();

    if(configCompany?.holidaysManagement != userSession?.companyHolidays){
      GetStorage().erase();
      Get.offNamedUntil('/', (route) => false);
    }
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
          _getConfig();
          setState(() {
            _navigationController.index = index;
             // Nuevo
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
          buttonBackgroundColor: mainGreenColorButton.withOpacity(0.9),
          color: mainColorBlue,
          items: <Widget>[
            SvgPicture.asset(
              "resources/t3_ic_home.svg",
              height: 24,
              width: 24,
              fit: BoxFit.none,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            if (userSession?.companyChekingList ?? false)
            SvgPicture.asset(
              "resources/t3_ic_msg.svg",
              height: 24,
              width: 24,
              fit: BoxFit.none,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            if (userSession?.companyHolidays ?? false)
            SvgPicture.asset(
              "resources/calendar.svg",
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
