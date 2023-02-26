import 'package:get/get.dart';
import 'package:music_player_design/ui/screens/layout.dart';
import 'package:music_player_design/routes/app_routes.dart';
import 'package:music_player_design/bindings/layout_binding.dart';




class AppPages {
  static final pages = [
    GetPage(name: Routes.HOME, page: () => LayoutPage(), binding: LayoutBinding()),
  ];
}
