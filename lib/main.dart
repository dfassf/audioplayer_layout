import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_design/routes/app_pages.dart';
import 'package:music_player_design/routes/app_routes.dart';


void main() async {
  runApp(GetMaterialApp(
    title: 'Music Player Design',
    theme: ThemeData(
      fontFamily: 'Inter_Regular',
    ),
    initialRoute: Routes.HOME,
    getPages: AppPages.pages,
    defaultTransition: Transition.fade,
    fallbackLocale: const Locale('en', 'US'),
  ));
}