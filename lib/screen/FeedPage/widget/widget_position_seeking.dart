import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testing_layout/components/constant.dart';

class PositionSeekWidget extends StatefulWidget {
  final Duration currentPosition;
  final Duration duration;
  final Function(Duration) seekTo;

  const PositionSeekWidget({
    @required this.currentPosition,
    @required this.duration,
    @required this.seekTo,
  });

  @override
  _PositionSeekWidgetState createState() => _PositionSeekWidgetState();
}

class _PositionSeekWidgetState extends State<PositionSeekWidget> {
  Duration _visibleValue;
  bool listenOnlyUserInterraction = false;
  double get percent => widget.duration.inMilliseconds == 0
      ? 0
      : _visibleValue.inMilliseconds / widget.duration.inMilliseconds;

  @override
  void initState() {
    super.initState();
    _visibleValue = widget.currentPosition;
  }

  @override
  void didUpdateWidget(PositionSeekWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listenOnlyUserInterraction) {
      _visibleValue = widget.currentPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: MediaQuery.of(context).size.width,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          thumbColor: Colors.black,
          thumbShape: RoundSliderThumbShape(
            enabledThumbRadius: 3.0,
          ),
          trackHeight: 3.0,
        ),
        child: Slider(
          activeColor: appKeyColor,
          inactiveColor: Colors.white,
          min: 0,
          max: widget.duration.inMilliseconds.toDouble(),
          value: percent * widget.duration.inMilliseconds.toDouble(),
          onChangeEnd: (newValue) {
            setState(() {
              listenOnlyUserInterraction = false;
              widget.seekTo(_visibleValue);
            });
          },
          onChangeStart: (_) {
            setState(() {
              listenOnlyUserInterraction = true;
            });
          },
          onChanged: (newValue) {
            setState(() {
              final to = Duration(milliseconds: newValue.floor());
              _visibleValue = to;
            });
          },
        ),
      ),
    );
  }
}

String durationToString(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes =
      twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
  String twoDigitSeconds =
      twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
  return "$twoDigitMinutes:$twoDigitSeconds";
}
