import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:music_player_design/controller/page_two_controller.dart';
import 'package:music_player_design/ui/screens/player/audioplayer.dart';

class PageTwo extends GetView<PageTwoController> {
  const PageTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Obx(() => SafeArea(
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                    preferredSize: Size(Get.width, 1),
                    child: AppBar(
                      systemOverlayStyle:
                      const SystemUiOverlayStyle(
                        statusBarColor: Colors.white,
                      ),
                      backgroundColor: Colors.white,
                      centerTitle: true,
                      elevation: 0.0,
                    )
                ),
                body: Container(
                    margin:
                    overlayController.isOverlayExisting.value
                        ? const EdgeInsets.fromLTRB(0,0,0,80)
                        : const EdgeInsets.fromLTRB(0,0,0,0),
                    child: ListView(
                        children: const [
                          Text('Page2')
                        ]
                    )
                )
            )
          ),
          ),
        )
    );
  }

}