import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marquee/marquee.dart';
import 'package:get/get.dart';
import 'package:music_player_design/data/model/audio_model.dart';
import 'package:music_player_design/ui/screens/player/seekbar.dart';
import 'package:music_player_design/utils/overlay/overlay_handler.dart';


class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({Key? key}) : super(key: key);
  @override
  AudioPlayerState createState() => AudioPlayerState();
}

final overlayController = Get.put(OverlayHandler());

class AudioPlayerState extends State<AudioPlayerWidget>
    with SingleTickerProviderStateMixin {

  double aspectRatio = 16 / 9;
  bool isAnimate = true;
  List<AudioModel> audioModels = [];
  RxInt playMode = 0.obs;
  RxList<Icon> repeatIcons = [
    const Icon(Icons.repeat, color: Colors.grey, size: 30),
    const Icon(Icons.repeat, color: Colors.white, size: 30),
    const Icon(Icons.repeat_one, color: Colors.white, size: 30),
  ].obs;
  late int playIndex;
  RxBool isShuffle = false.obs;
  final AudioModel songInfo = AudioModel();

  @override
  void initState() {

    songInfo.artist = 'Dyno';
    songInfo.imgFileUrl = 'assets/image/cover.png';
    songInfo.duration = '300';
    // songInfo.lyrics = 'abcdefg\n\nabcdefg\nabcdefg\nabcdefg\nabcdefg\n\nabcdefg\nabcdefg\nabcdefg\nabcdefg\n\nabcdefg\nabcdefg\nabcdefg\nabcdefg\n\nabcdefg\nabcdefg\nabcdefg\nabcdefg\n\nabcdefg\nabcdefg\nabcdefg\nabcdefg\n\nabcdefg\n\nabcdefg\nabcdefg\nabcdefg\nabcdefg\n\nabcdefg\nabcdefg\nabcdefg\nabcdefg\n\nabcdefg\nabcdefg\nabcdefg\nabcdefg\n\nabcdefg\nabcdefg\nabcdefg\nabcdefg\n\nabcdefg\nabcdefg\nabcdefg\nabcdefg';
    songInfo.title = 'Mountkid';
    songInfo.name = 'Dyno';

    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("BACK BUTTON!");

    if(overlayController.inPipMode) {
      return false;
    } else {
      overlayController.isLyricsFullScreen.value = false;
      Get.find<OverlayHandler>().enablePip(aspectRatio);
      return true;
    }
  }

  @override
  dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  Widget playerArea() {
    return Obx(()=>GestureDetector(
        child: Stack(
            children: [
              AnimatedOpacity(
                curve: Curves.fastOutSlowIn,
                opacity:
                overlayController.isMenuHid.value
                    ? 1.0 : 0.3,
                duration: const Duration(milliseconds: 800),
                child: Container(
                  width: Get.width,
                  height: overlayController.beforeFullScreenHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                          alignment: FractionalOffset.topCenter,
                          image: AssetImage(songInfo.imgFileUrl),
                          fit: BoxFit.fitHeight
                      )
                  ),
                ),
              ),
              Positioned(
                  top: 20 + MediaQuery.of(context).padding.top,
                  left: Get.width * 0.05,
                  child: AnimatedOpacity(
                    curve: Curves.fastOutSlowIn,
                    opacity:
                    overlayController.isMenuHid.value
                        ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 800),
                    child: IconButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 30,
                          shadows: [
                            Shadow(
                                color: Colors.black,
                                blurRadius: 7,
                                offset: Offset(1, 1)
                            )
                          ],
                        ),
                        color: Colors.white,
                        onPressed: () {
                          if(!overlayController.isMenuHid.value) {
                            Get.find<OverlayHandler>().enablePip(aspectRatio);
                            overlayController.isMenuHid.value = false;
                          }
                        }
                    ),
                  )
              ),
              Positioned(
                top: 20 + MediaQuery.of(context).padding.top,
                right: Get.width * 0.05,
                child: AnimatedOpacity(
                    curve: Curves.fastOutSlowIn,
                    opacity:
                    overlayController.isMenuHid.value
                        ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 800),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 30,
                        shadows: [
                          Shadow(
                              color: Colors.black,
                              blurRadius: 7,
                              offset: Offset(1, 1)
                          )
                        ],
                      ),
                      onPressed: () {
                        if(!overlayController.isMenuHid.value) {
                          Get.find<OverlayHandler>().removeOverlay(context);
                        }
                      },
                      color: Colors.white,
                    )
                ),
              ),
              if(!overlayController.isMenuHid.value)
                Positioned(
                  bottom: 20,
                  child: Container(
                    width: Get.width,
                    padding: EdgeInsets.only(bottom: overlayController.beforeFullScreenHeight * 0.1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: Get.width,
                          height: overlayController.beforeFullScreenHeight * 0.0625,
                        ),
                        infoArea(),
                        seekbarArea(),
                        const SizedBox(height: 20),
                        playBarArea(),
                      ],
                    ),
                  ),
                ),
            ]
        )
    ));
  }

  Widget infoArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: Get.width * 0.9,
            child: Row(
                children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      width: Get.width * 0.7,
                                      height: 35,
                                      child:
                                      songInfo.title.length > 11
                                          ? Marquee(
                                        text:songInfo.title,
                                        style: const TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        velocity: 20,
                                        blankSpace: Get.width * 0.7,
                                      )
                                          : Text(
                                        songInfo.title,
                                        style: const TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ]
                            ),

                            SizedBox(
                              width: Get.width * 0.7,
                              height: 25,
                              child:
                              songInfo.artist.length > 15
                                  ? Marquee(
                                text:songInfo.artist,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                                velocity: 20,
                                blankSpace: Get.width * 0.7,
                              )
                                  : Text(
                                songInfo.artist,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ]
                      )
                  ),
                ]
            )
        )
      ],
    );
  }

  Widget seekbarArea() {
    return const SeekBar(
        duration: Duration(milliseconds: 23000)
    );

  }

  Widget playBarArea() {
    return SizedBox(
        width: Get.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () async {
                  playMode.value = (playMode.value + 1) % repeatIcons.length;
                },
                child: repeatIcons[playMode.value]
            ),
            const SizedBox(width: 10),
            GestureDetector(
                onTap: () async {

                },
                child: Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    child: const Icon(Icons.skip_previous, color: Colors.white, size: 50)
                )
            ),
            GestureDetector(
                onTap: () {

                },
                child: Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.center,
                    decoration:  const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(80)),
                        color: Colors.white
                    ),
                    child: const Icon(Icons.pause, color: Color(0xff2b2b2b), size: 50)
                )
            ),
            GestureDetector(
                onTap: () async {

                },
                child: Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    child: const Icon(Icons.skip_next, color: Colors.white, size: 50)
                )
            ),
            const SizedBox(width: 10),
            GestureDetector(
                onTap: () async {
                  isShuffle.value = !isShuffle.value;
                },
                child:
                  isShuffle.value
                  ? const Icon(Icons.shuffle, color: Colors.white, size: 30)
                  :const Icon(Icons.shuffle, color: Colors.grey, size: 30)
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OverlayHandler>(
        builder: (getContext) {
          if (!Get.find<OverlayHandler>().inPipMode) {
            return Scaffold(
                backgroundColor: Colors.white,
                extendBody: true,
                extendBodyBehindAppBar: true,
                resizeToAvoidBottomInset: false,
                body: Obx(()=> Stack(
                    children: [
                      NotificationListener(
                          onNotification: (ScrollNotification scrollInfo) {
                            if(overlayController.isMenuHid.value) {
                              if(overlayController.scrollController.offset > 80) {
                                overlayController.isMenuHid.value = false;
                              }
                            }
                            return false;
                          },
                          child: SingleChildScrollView(
                              controller: overlayController.scrollController,
                              physics:
                              overlayController.isLyricsFullScreen.value
                                  ? const NeverScrollableScrollPhysics()
                                  : const AlwaysScrollableScrollPhysics(),
                              child: Container(
                                  width: Get.width,
                                  height: songInfo.lyrics.isNotEmpty ?
                                  Get.height + 400 : Get.height,
                                  color: const Color(0xff2c2c2c),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            overlayController.isMenuHid.value = !overlayController.isMenuHid.value;
                                            overlayController.isMenuHid.value && !overlayController.isLyricsFullScreen.value
                                                ? SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky)
                                                : SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                                          },
                                          child: Container(
                                            child: playerArea(),
                                          ),
                                        ),
                                      ),
                                      if(songInfo.lyrics.isNotEmpty)
                                        Positioned(
                                          bottom:
                                          overlayController.isLyricsFullScreen.value
                                              ? 10
                                              : 10 + MediaQuery.of(context).padding.bottom,
                                          child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 500),
                                              curve: Curves.linearToEaseOut,
                                              width: Get.width,
                                              height:
                                              !overlayController.isLyricsFullScreen.value
                                                  ? 450
                                                  : MediaQuery.of(context).size.height - 100,
                                              padding:
                                              overlayController.isLyricsFullScreen.value
                                                  ? const EdgeInsets.all(0)
                                                  : const EdgeInsets.all(20),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                    overlayController.isLyricsFullScreen.value
                                                        ? BorderRadius.circular(0)
                                                        : BorderRadius.circular(10),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(height:
                                                      overlayController.isLyricsFullScreen.value
                                                          ? 30 : 10
                                                      ),
                                                      Row(
                                                          children: [
                                                            const SizedBox(width: 10),
                                                            const Text('Lyrics', style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors.white
                                                            ),),
                                                            const Spacer(),
                                                            GestureDetector(
                                                              child: Container(
                                                                  width: 30,
                                                                  height: 30,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(30),
                                                                    color: Colors.black,
                                                                  ),
                                                                  child: Icon(
                                                                      overlayController.isLyricsFullScreen.value
                                                                          ? Icons.fullscreen_exit
                                                                          : Icons.fullscreen,
                                                                      color: Colors.white, size: 25
                                                                  )
                                                              ),

                                                              onTap: () {
                                                                if(!overlayController.isLyricsFullScreen.value) {
                                                                  overlayController.lastScrollPosition = overlayController.scrollController.offset;
                                                                }
                                                                final position = overlayController.scrollController.position.maxScrollExtent;
                                                                overlayController.scrollController.jumpTo(position);
                                                                overlayController.isLyricsFullScreen.value = !overlayController.isLyricsFullScreen.value;
                                                                overlayController.isMenuHid.value = false;
                                                                overlayController.isMenuHid.value && !overlayController.isLyricsFullScreen.value
                                                                    ? SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky)
                                                                    : SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                                                                if(!overlayController.isLyricsFullScreen.value) {
                                                                  overlayController.scrollController.jumpTo(overlayController.lastScrollPosition);
                                                                }
                                                              },
                                                            ),
                                                            const SizedBox(width: 10),
                                                          ]
                                                      ),
                                                      const SizedBox(height: 10),
                                                      Expanded(
                                                          child: SingleChildScrollView(
                                                              child: Container(
                                                                width: Get.width,
                                                                padding:
                                                                overlayController.isLyricsFullScreen.value
                                                                    ? const EdgeInsets.only(left: 10, right: 10, bottom : 80)
                                                                    : const EdgeInsets.only(left: 10, right: 10, bottom : 10),
                                                                child: Text(
                                                                  songInfo.lyrics,
                                                                  style: const TextStyle(
                                                                    fontSize: 18,
                                                                    color: Colors.grey,
                                                                  ),
                                                                  textAlign: TextAlign.start,
                                                                ),
                                                              )
                                                          )
                                                      )
                                                    ],
                                                  )
                                              )
                                          ),
                                        ),
                                    ],
                                  )
                              )
                          )
                      ),
                      Positioned(
                        top: 0,
                        child: AnimatedContainer(
                            width: Get.width,
                            height:
                            !overlayController.isLyricsFullScreen.value
                                ? 0
                                : 100,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.linearToEaseOut,
                            color: Colors.black,
                            child: FittedBox(
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: Get.width * 0.9,
                                      child: Text(
                                        songInfo.title,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        textAlign: TextAlign.center,),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: Get.width * 0.9,
                                      child: Text(songInfo.artist, style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey
                                      ),
                                          textAlign: TextAlign.center
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                  ]
                              )
                            )
                        ),
                      ),
                    ]
                ))
            );
          } else {
            return Stack(
              children: [
                Positioned(
                    child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {Get.find<OverlayHandler>().disablePip();},
                        child: Column(
                          children: [
                            Container(
                                width: Get.width,
                                height: 80,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 12.0,
                                      color: Colors.black,
                                      spreadRadius: 0.5,
                                      offset: Offset(0, -10),
                                    ),
                                  ],
                                ),
                                child: Material(
                                    color: Colors.transparent,
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                          height: 50,
                                        ),
                                        Container(
                                            width: 65,
                                            height: 65,
                                            decoration: BoxDecoration(
                                                border: Border.all(color: const Color(0xff494949), width: 1),
                                                image:
                                                DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: AssetImage(songInfo.imgFileUrl),
                                                )
                                            )
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.translucent,
                                            onTap: () {
                                              Get.find<OverlayHandler>().disablePip();
                                            },
                                            child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      songInfo.title,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w800,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      songInfo.artist,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                )
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                            behavior: HitTestBehavior.translucent,
                                            onTap: () async {
                                            },
                                            child: Container(
                                                width: 40,
                                                height: 70,
                                                alignment: Alignment.center,
                                                child: Container(
                                                    width: 35,
                                                    height: 35,
                                                    alignment: Alignment.center,
                                                    decoration:  const BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(35)),
                                                        color: Colors.black,
                                                    ),
                                                    child: const Icon(Icons.skip_previous, color: Colors.white, size: 25)
                                                )
                                            )
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                            onTap: () async {

                                            },
                                            child: Container(
                                                width: 40,
                                                height: 70,
                                                alignment: Alignment.center,
                                                child: Container(
                                                    width: 35,
                                                    height: 35,
                                                    alignment: Alignment.center,
                                                    decoration:  const BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(35)),
                                                        color: Colors.black
                                                    ),
                                                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 25)
                                                )
                                            )
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                            onTap: () async {
                                            },
                                            child: Container(
                                                width: 40,
                                                height: 70,
                                                alignment: Alignment.center,
                                                child: Container(
                                                    width: 35,
                                                    height: 35,
                                                    alignment: Alignment.center,
                                                    decoration:  const BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(35)),
                                                        color: Colors.black
                                                    ),
                                                    child: const Icon(Icons.skip_next, color: Colors.white, size: 25)
                                                )
                                            )
                                        ),
                                        const SizedBox(width: 20),
                                      ],
                                    )
                                )
                            ),
                          ],
                        )
                    )
                ),
              ],
            );
          }
        },

    );
  }
}

String transformString(int seconds) {
  String minuteString = '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
  String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
  return '$minuteString:$secondString';
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}



