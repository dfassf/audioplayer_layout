import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_design/ui/screens/player/audioplayer.dart';

import 'overlay_handler.dart';

class AudioTitleOverlayWidget extends StatefulWidget {
  final Function onClear;
  final Widget widget;

  const AudioTitleOverlayWidget(
      {Key? key, required this.onClear, required this.widget})
      : super(key: key);

  @override
  _AudioTitleOverlayWidgetState createState() =>
      _AudioTitleOverlayWidgetState();
}

class _AudioTitleOverlayWidgetState extends State<AudioTitleOverlayWidget> {
  bool isInPipMode = false;

  _onExitPipMode() {
    Future.microtask(() {
      setState(() {
        isInPipMode = false;
      });
    });
    Future.delayed(const Duration(milliseconds: 250), () {
      Get.find<OverlayHandler>().disablePip();
    });
  }

  _onPipMode() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        isInPipMode = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    double width = Get.width;
    double height = Get.height;
    return GetBuilder<OverlayHandler>(builder: (context) {
      if (Get.find<OverlayHandler>().inPipMode != isInPipMode) {
        isInPipMode = Get.find<OverlayHandler>().inPipMode;
        if (isInPipMode) {
          _onPipMode();
        } else {
          _onExitPipMode();
        }
      }

      return Positioned(
        // left: 0, // pipah드일 때 pip아닐 때
        top: isInPipMode ? Get.height - 160 + 11 - bottomPadding : 0,
        bottom: isInPipMode ? 69 + bottomPadding : 0,
        child: SizedBox(
          height: height,
          width: width,
          child: const AudioPlayerWidget(),
        ),
      );
    });
  }
}
