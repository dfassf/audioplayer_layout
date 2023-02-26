import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_design/controller/page_one_controller.dart';
import 'package:music_player_design/utils/overlay/overlay_service.dart';

import 'package:music_player_design/utils/overlay/overlay_handler.dart';

import '../screens/player/audioplayer.dart';

class PageOne extends GetView<PageOneController> {
  const PageOne({Key? key}) : super(key: key);

  final double aspectRatio = 16 / 9;
  @override
  Widget build(BuildContext context) {
    final overlayController = Get.put(OverlayHandler());
    addOverlay() {
      OverlayService().addAudioTitleOverlay(context, const AudioPlayerWidget());
      overlayController.isOverlayExisting.value = true;
    }
    return Obx(() => SafeArea(
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
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      addOverlay();
                      Get.find<OverlayHandler>().enablePip(aspectRatio);
                    },
                    child: const Text('CLICK TO OPEN OVERLAY', style: TextStyle(color: Colors.black, fontSize: 30,))
                  )
                )
            )
            )
        )
    );
  }


}
