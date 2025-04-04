import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pomodoro/models/time_stamps.dart';

const pomodoroBox = "pomodoro_box";
const userSettings = "user_settings";
const userSessions = "user_sessions";

final _storageBox = Hive.box(pomodoroBox);
List userSettingsTable = _storageBox.get(userSettings) ?? [];
List userSessionsTable = _storageBox.get(userSessions) ?? [];

void updateSettings(Map<String, dynamic> updated) {
  userSettingsTable = [updated];
  _saveToDatabase(tableName: userSettings, data: userSettingsTable);
}

void addSession({required String logText, required int duration}) {
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
  userSessionsTable.add(newSession);
  _saveToDatabase(tableName: userSessions, data: userSessionsTable);
}

void editSession({
  required Map<String, dynamic> old,
  required Map<String, dynamic> updated,
}) {
  int index = userSessionsTable.indexOf(old);
  userSessionsTable.remove(old);
  userSessionsTable.insert(index, updated);
}

void deleteSession(Map<String, dynamic> session) {
  userSessionsTable.remove(session);
}

void logUserSettings(Map<String, dynamic> userProfile) {
  _saveToDatabase(tableName: userSettings, data: [userProfile]);
}

Map getUserSettings() {
  return userSettingsTable[0];
}

List getUserSessions() {
  return userSessionsTable;
}

// Basic Functions
void _saveToDatabase({required String tableName, required List data}) {
  _storageBox.put(tableName, data);
}
