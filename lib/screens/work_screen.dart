import 'package:flutter/material.dart';
import 'package:pomodoro/interface/data_handler.dart';
import 'package:pomodoro/interface/hexcolor.dart';
import 'package:pomodoro/models/user.dart';
import 'package:pomodoro/widgets/coutdown.dart';
import 'package:pomodoro/widgets/buttons.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key, required this.toRest});
  final void Function() toRest;

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Map settings;

  @override
  void initState() {
    super.initState();
    settings = getUserSettings();
  }

  @override
  Widget build(BuildContext context) {
    final String background = settings[Settings.work_background.toString()] ?? "#35AE73";
    final String foreground = settings[Settings.work_foreground.toString()] ?? "#FFFFFF";
    final int workTime = settings[Settings.work_time.toString()] ?? 25;

    return Scaffold(
      backgroundColor: HexColor.fromHex(background),
      appBar: AppBar(
        backgroundColor: HexColor.fromHex(background),
        elevation: 0,
        actions: [
          const Spacer(),
          IconButton(
            onPressed: widget.toRest,
            icon: const Icon(Icons.arrow_right_alt),
            color: HexColor.fromHex(foreground),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              Countdown(
                minutes: workTime,
                color: foreground,
                logText: "work",
                loadNext: widget.toRest,
              ),
              const Spacer(),
              ButtonMore(color: foreground),
            ],
          ),
        ),
      ),
    );
  }
}
