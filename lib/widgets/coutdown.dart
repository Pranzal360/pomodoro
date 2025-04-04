import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pomodoro/interface/data_handler.dart';
import 'package:pomodoro/interface/hexcolor.dart';

class Countdown extends StatefulWidget {
  const Countdown({
    super.key,
    required this.minutes,
    required this.color,
    required this.logText,
    required this.loadNext,
  });

  final int minutes;
  final String color;
  final String logText;
  final void Function() loadNext;

  @override
  State<Countdown> createState() => _CountState();
}

class _CountState extends State<Countdown> {
  late int minutes;
  late int seconds = 0;
  int extraMinutes = 0;
  int extraSeconds = 0;
  Timer? timer;
  String prefix = "";
  // mode: start, running, paused, extra
  String mode = "start";

  @override
  void initState() {
    super.initState();
    minutes = widget.minutes;
  }

  void _countUp() {
    prefix = "+";
    setState(() {
      mode = "extra";
    });

    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds == 60) {
        setState(() {
          seconds = 0;
          minutes++;
        });
      }
      setState(() {
        seconds++;
      });
    });
  }

  void _countdown() {
    mode = "running";
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds == 0) {
        minutes--;
        seconds = 60;
      }
      setState(() {
        seconds--;
      });
      if (minutes == 0 && seconds == 0) {
        timer!.cancel();
        _countUp();
        return;
      }
    });
  }

  void _stopTimer() {
    timer?.cancel();
  }

  void _reset() {
    setState(() {
      _stopTimer();
      mode = "start";
      minutes = widget.minutes;
      seconds = 0;
      prefix = "";
    });
  }

  Widget _buttons() {
    if (mode == "start") {
      return IconButton(
        onPressed: () {
          _countdown();
        },
        icon: Icon(Icons.play_circle, color: HexColor.fromHex(widget.color)),
        color: HexColor.fromHex(widget.color),
      );
    }

    if (mode == "running") {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                mode = "paused";
              });
              _stopTimer();
            },
            icon: Icon(Icons.pause),
            color: HexColor.fromHex(widget.color),
          ),
          IconButton(
            onPressed: () {
              _save();
              _reset();
            },
            icon: Icon(Icons.close),
            color: HexColor.fromHex(widget.color),
          ),
        ],
      );
    }

    if (mode == "paused") {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              _countdown();
            },
            icon: Icon(
              Icons.play_circle,
              color: HexColor.fromHex(widget.color),
            ),
          ),
          IconButton(
            onPressed: () {
              _save();
              _reset();
            },
            icon: Icon(Icons.close, color: HexColor.fromHex(widget.color)),
          ),
        ],
      );
    }

    // if extra time
    return IconButton(
      onPressed: () {
        _stopTimer();
        _save();
        widget.loadNext();
      },
      icon: Icon(Icons.pause, color: HexColor.fromHex(widget.color)),
    );
  }

  void _save() {
    int total = 0;
    if (mode == "extra") {
      total = widget.minutes + minutes;
    } else {
      total = widget.minutes - minutes;
    }
    addSession(logText: widget.logText, duration: total);
  }

  // Int -> String
  // Adds a '0' to the front if number is only one digit
  String _twoDigits(int number) => (number > 9) ? "$number" : "0$number";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "$prefix${_twoDigits(minutes)}:${_twoDigits(seconds)}",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 75,
            color: HexColor.fromHex(widget.color),
          ),
        ),
        _buttons(),
      ],
    );
  }
}
