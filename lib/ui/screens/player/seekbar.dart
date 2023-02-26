import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration? position;
  final Duration? bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar({
    Key? key,
    required this.duration,
    this.position,
    this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);

  @override
  SeekBarState createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: 50,
      child: Column(
        children: [
          SizedBox(
            height: 30,
            child: Stack(
                children: [
                  SliderTheme(
                    data: _sliderThemeData.copyWith(
                      trackShape: const RectangularSliderTrackShape(),
                      thumbShape: HiddenThumbComponentShape(),
                      activeTrackColor: Colors.grey.shade300,
                      inactiveTrackColor: Colors.grey.shade500,
                      trackHeight: 1.5,
                    ),
                    child: ExcludeSemantics(
                      child: Slider(
                        min: 0.0,
                        max: widget.duration.inMilliseconds.toDouble(),
                        value: min(0,
                            widget.duration.inMilliseconds.toDouble()),
                        onChanged: (value) {
                          setState(() {
                            _dragValue = value;
                          });
                          if (widget.onChanged != null) {
                            widget.onChanged!(Duration(milliseconds: value.round()));
                          }
                        },
                        onChangeEnd: (value) {
                          if (widget.onChangeEnd != null) {
                            widget.onChangeEnd!(Duration(milliseconds: value.round()));
                          }
                          _dragValue = null;
                        },
                      ),
                    ),
                  ),
                  SliderTheme(
                    data: _sliderThemeData.copyWith(
                      trackShape: const RectangularSliderTrackShape(),
                      inactiveTrackColor: Colors.transparent,
                      activeTrackColor: Colors.white,
                      thumbColor: Colors.white,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                      trackHeight: 1.5,
                    ),
                    child: Slider(
                      min: 0.0,
                      max: widget.duration.inMilliseconds.toDouble(),
                      value: min(_dragValue ?? 0,
                          widget.duration.inMilliseconds.toDouble()),
                      onChanged: (value) {
                        setState(() {
                          _dragValue = value;
                        });
                        if (widget.onChanged != null) {
                          widget.onChanged!(Duration(milliseconds: value.round()));
                        }
                      },
                      onChangeEnd: (value) {
                        if (widget.onChangeEnd != null) {
                          widget.onChangeEnd!(Duration(milliseconds: value.round()));
                        }
                        _dragValue = null;
                      },
                    ),
                  ),
                ]
            ),
          ),
          SizedBox(
            height: 20,
            child: Stack(
              children: [
                Positioned(
                    left: 26.0,
                    bottom: 0.0,
                    child: Text(
                        widget.position != null
                        ? RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                            .firstMatch("${widget.position}")
                            ?.group(1) ??
                            '${widget.position}'
                        : '00:00',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter_Regular',
                          fontSize: 15,
                        )
                    )
                ),
                Positioned(
                    right: 26.0,
                    bottom: 0.0,
                    child: Text(
                        RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                            .firstMatch("${widget.duration}")
                            ?.group(1) ??
                            '${widget.duration}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter_Regular',
                          fontSize: 15,
                        )
                    )
                ),
              ],
            )
          )
        ]
      )
    );
  }
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => SizedBox(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: const TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? 1.0,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}