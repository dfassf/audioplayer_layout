import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:music_player_design/controller/navigation_controller.dart';
import 'package:music_player_design/ui/bottom_tabs/page_one.dart';
import 'package:music_player_design/ui/bottom_tabs/page_two.dart';
import 'package:music_player_design/ui/bottom_tabs/page_three.dart';


class LayoutPage extends StatefulWidget {
  LayoutPage({Key? key}) : super(key: key);
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  LayoutState createState() => LayoutState();
}

class LayoutState extends State<LayoutPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.light));
    return GetBuilder<NavigationController>(
        builder: (controller)
        {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: IndexedStack(
                index: controller.tabIndex,
                children: const [
                  PageOne(),
                  PageTwo(),
                  PageThree(),
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: SizedBox(
                height: 69,
                child: BottomNavigationBar(
                  elevation: 0.0,
                  type: BottomNavigationBarType.fixed,
                  iconSize: 30,
                  backgroundColor: Colors.white,
                  selectedItemColor: Colors.black,
                  unselectedItemColor: Colors.black,
                  selectedLabelStyle: const TextStyle(fontSize: 12, color: Colors.black),
                  currentIndex: controller.tabIndex,
                  onTap: controller.changeTabIndex,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined),
                        activeIcon: Icon(Icons.home),
                        label: 'Home'
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.explore_outlined),
                        activeIcon: Icon(Icons.explore),
                        label: 'Explore'
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.library_music_outlined),
                        activeIcon: Icon(Icons.library_music),
                        label: 'Library'
                    )
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.white,
          );
        }

    );
  }
}