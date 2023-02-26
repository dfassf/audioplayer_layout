import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverlayHandler extends GetxController {
  RxBool isOverlayExisting = false.obs;
  OverlayEntry? overlayEntry;
  bool inPipMode = false;
  bool overlayStatus = false;
  RxBool isMenuHid = false.obs;
  RxBool isLyricsFullScreen = false.obs;
  double beforeFullScreenHeight = 0.0;
  double initialBottomPadding = 0.0;
  double lastScrollPosition = 0.0;

  @override
  onInit() {
    beforeFullScreenHeight = Get.height;
    super.onInit();
  }

  ScrollController scrollController = ScrollController();

  enablePip(double aspect) {
    inPipMode = true;
    update();
  }

  disablePip() {
    inPipMode = false;
    update();
  }

  get overlayActive => overlayStatus;

  insertOverlay(BuildContext context, OverlayEntry overlay) {
    if(overlayEntry != null) {
      overlayEntry!.remove();
    }
    overlayEntry = null;
    overlayStatus = true;
    inPipMode = true;
    Overlay.of(context)?.insert(overlay);
    overlayEntry = overlay;
  }

  removeOverlay(BuildContext context) {
    if(overlayEntry != null) {
      overlayEntry!.remove();
    }
    overlayStatus = true;
    overlayEntry = null;
    isOverlayExisting.value = false;
  }

}