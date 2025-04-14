import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pomodoro/models/time_stamps.dart';

const pomodoroBox = "pomodoro_box";
const userSettings = "user_settings";
const userSessions = "user_sessions";

// Do NOT initialize storage or tables here — wait until Hive is ready in main()

void updateSettings(Map<String, dynamic> updated) {
  final box = Hive.box(pomodoroBox);
  box.put(userSettings, [updated]);
}

void addSession({required String logText, required int duration}) {
  final box = Hive.box(pomodoroBox);
  List sessions = box.get(userSessions, defaultValue: []);

  final now = DateTime.now();
  Map<String, dynamic> newSession = {
    "date": {
      DateMeasures.year.toString(): now.year,
      DateMeasures.month.toString(): now.month,
      DateMeasures.day.toString(): now.day,
      DateMeasures.hour.toString(): now.hour,
      DateMeasures.minute.toString(): now.minute,
    },
    "mode": logText,
    "duration": duration,
  };

  sessions.add(newSession);
  box.put(userSessions, sessions);
}

void editSession({
  required Map<String, dynamic> old,
  required Map<String, dynamic> updated,
}) {
  final box = Hive.box(pomodoroBox);
  List sessions = box.get(userSessions, defaultValue: []);

  int index = sessions.indexOf(old);
  if (index != -1) {
    sessions[index] = updated;
    box.put(userSessions, sessions);
  }
}

void deleteSession(Map<String, dynamic> session) {
  final box = Hive.box(pomodoroBox);
  List sessions = box.get(userSessions, defaultValue: []);
  sessions.remove(session);
  box.put(userSessions, sessions);
}

void logUserSettings(Map<String, dynamic> userProfile) {
  final box = Hive.box(pomodoroBox);
  box.put(userSettings, [userProfile]);
}

Map getUserSettings() {
  final box = Hive.box(pomodoroBox);
  List settings = box.get(userSettings, defaultValue: []);
  return settings.isNotEmpty ? settings[0] : {};
}

List getUserSessions() {
  final box = Hive.box(pomodoroBox);
  return box.get(userSessions, defaultValue: []);
}
