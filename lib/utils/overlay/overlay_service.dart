import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_design/utils/overlay/audios_title_overlay_widget.dart';
import 'overlay_handler.dart';

class OverlayService {
  addAudioTitleOverlay(BuildContext context, Widget widget) {
    final overlayHandler = Get.put(OverlayHandler());
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => AudioTitleOverlayWidget(
        onClear: () {
          overlayHandler.removeOverlay(context);
        },
        widget: widget,
      ),
    );
    overlayHandler.insertOverlay(context, overlayEntry);
  }

}