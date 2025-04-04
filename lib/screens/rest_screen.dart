import 'package:flutter/material.dart';
import 'package:pomodoro/interface/data_handler.dart';
import 'package:pomodoro/interface/hexcolor.dart';
import 'package:pomodoro/models/user.dart';
import 'package:pomodoro/widgets/coutdown.dart';
import 'package:pomodoro/widgets/buttons.dart';

class RestScreen extends StatefulWidget {
  const RestScreen({super.key, required this.toWork});

  final void Function() toWork;

  @override
  State<RestScreen> createState() => _RestScreenState();
}

class _RestScreenState extends State<RestScreen> {
  late Map settings;

  @override
  void initState() {
    super.initState();
    settings = getUserSettings();
  }

  @override
  Widget build(BuildContext context) {
    final String background = settings[Settings.rest_background.toString()] ?? "#35AE73";
    final String foreground = settings[Settings.rest_foreground.toString()] ?? "#FFFFFF";
    final int restTime = settings[Settings.rest_time.toString()] ?? 5;

    return Scaffold(
      backgroundColor: HexColor.fromHex(background),
      appBar: AppBar(
        backgroundColor: HexColor.fromHex(background),
        foregroundColor: HexColor.fromHex(foreground),
        elevation: 0,
        actions: [
          const Spacer(),
          IconButton(
            onPressed: widget.toWork,
            icon: const Icon(Icons.replay),
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
              Text(
                "Rest",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: HexColor.fromHex(foreground),
                ),
              ),
              const SizedBox(height: 10),
              Countdown(
                minutes: restTime,
                color: foreground,
                logText: "rest",
                loadNext: widget.toWork,
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
