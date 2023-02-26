import 'package:get/get.dart';
import 'package:music_player_design/controller/page_one_controller.dart';
import 'package:music_player_design/controller/page_two_controller.dart';
import 'package:music_player_design/controller/navigation_controller.dart';
import 'package:music_player_design/controller/page_three_controller.dart';

class LayoutBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(NavigationController());
    Get.put(PageOneController());
    Get.put(PageTwoController());
    Get.put(PageThreeController());
  }
}