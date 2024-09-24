import 'dart:math';

import 'package:flutter/material.dart';
import 'package:third_eye/constants/app_colors.dart';

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;
  final bool isBlinded;
  final bool isConnected;

  const SeekBar({
    Key key,
    this.duration,
    this.position,
    this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
    this.isBlinded,
    this.isConnected,
  }) : super(key: key);

  @override
  SeekBarState createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double _dragValue;
  SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  void resetSeekBar() {
    setState(() {
      _dragValue = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SliderTheme(
          data: _sliderThemeData.copyWith(
            overlappingShapeStrokeColor: AppColors.PRIMARY_RED,
            thumbColor: AppColors.PRIMARY_RED,
            activeTrackColor: AppColors.PRIMARY_RED,
            inactiveTrackColor: AppColors.PRIMARY_RED.withOpacity(0.1),
          ),
          child: Slider(
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble()),
            onChanged: widget.isConnected
                ? widget.isBlinded
                    ? (value) {
                        setState(() {
                          _dragValue = value;
                        });
                        if (widget.onChanged != null) {
                          widget
                              .onChanged(Duration(milliseconds: value.round()));
                        }
                        //_dragValue = value;
                        _dragValue = null;
                      }
                    : (value) {
                        setState(() {
                          _dragValue = value;
                        });
                        if (widget.onChanged != null) {
                          widget
                              .onChanged(Duration(milliseconds: value.round()));
                        }
                        //_dragValue = value;
                        //_dragValue = null;
                      }
                : (value) {},
            onChangeEnd: widget.isConnected
                ? widget.isBlinded
                    ? (value) {
                        if (widget.onChangeEnd != null) {
                          widget.onChangeEnd(
                              Duration(milliseconds: value.round()));
                        }
                        //_dragValue = value;
                        _dragValue = null;
                      }
                    : (value) {
                        if (widget.onChangeEnd != null) {
                          widget.onChangeEnd(
                              Duration(milliseconds: value.round()));
                        }
                        //_dragValue = value;
                        _dragValue = null;
                      }
                : (value) {},
          ),
        ),
        Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Semantics(
            excludeSemantics: true,
            child: Text(
                RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                        .firstMatch("$_remaining")
                        ?.group(1) ??
                    '$_remaining',
                style: Theme.of(context).textTheme.bodySmall),
          ),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
    double textScaleFactor,
    Size sizeWithOverflow,
  }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

void showSliderDialog({
  BuildContext context,
  String title,
  int divisions,
  double min,
  double max,
  String valueSuffix = '',
  // TODO: Replace these two by ValueStream.
  double value,
  Stream<double> stream,
  ValueChanged<double> onChanged,
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
                value: snapshot.data ?? value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

T ambiguate<T>(T value) => value;
