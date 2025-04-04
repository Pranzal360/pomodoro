import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:pomodoro/models/user.dart';
import 'package:pomodoro/screen_hander.dart';
import 'package:pomodoro/interface/data_handler.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(pomodoroBox);

  if (userSettingsTable.isEmpty) {
    logUserSettings({

      Settings.work_foreground.toString(): "#000000",
      Settings.work_background.toString(): "#ffffff",
      Settings.rest_foreground.toString(): "#000000",
      Settings.rest_background.toString(): "#ffffff",
      Settings.work_time.toString(): 25,
      Settings.rest_time.toString(): 5,
    });
  }

  return runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: ScreenHandler()),
  );
}
