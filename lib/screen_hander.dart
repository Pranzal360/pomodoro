import 'package:flutter/material.dart';
import 'package:pomodoro/interface/data_handler.dart'; // ✅ THIS LINE is needed
import 'package:pomodoro/screens/rest_screen.dart';
import 'package:pomodoro/screens/work_screen.dart';
ValueNotifier<bool> settingsUpdated = ValueNotifier(false);

class ScreenHandler extends StatefulWidget {
  const ScreenHandler({super.key});

  @override
  State<ScreenHandler> createState() => _ScreenHandlerState();
}

class _ScreenHandlerState extends State<ScreenHandler> {
  String current = "/work";

  void toWork() => setState(() => current = "/work");
  void toRest() => setState(() => current = "/rest");

  @override
  void initState() {
    super.initState();

    // 🟢 Now this works!
    settingsUpdated.addListener(() {
      setState(() {}); // Refresh when settings change
    });
  }

  @override
  Widget build(BuildContext context) {
    if (current == "/rest") {
      return RestScreen(toWork: toWork);
    }
    return TimerScreen(toRest: toRest);
  }
}
