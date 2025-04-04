import 'package:flutter/material.dart';
import 'dart:core';
import 'package:pomodoro/interface/data_handler.dart';
import 'package:pomodoro/models/time_stamps.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimeLineScreenState();
}

class _TimeLineScreenState extends State<TimelineScreen> {
  late List sessions;
  late DateTime now = DateTime.now();
  late int day = now.day;
  late int month = now.month;
  late int year = now.year;
  List specificSessions = [];
  late num focusedMinutes = 0;

  @override
  void initState() {
    super.initState();
    sessions = getUserSessions();
    _getSessionsForDate(year: year, month: month, day: day);
  }

  Widget _listBody(int index) {
    focusedMinutes = 0;
    _getSessionsForDate(year: year, month: month, day: day);
    if (specificSessions.isEmpty) {
      return SizedBox();
    }

    String mode = specificSessions[index]["mode"];
    int hour = specificSessions[index]["date"][DateMeasures.hour.toString()];
    int minutes =
        specificSessions[index]["date"][DateMeasures.minute.toString()];
    int total = specificSessions[index]["duration"];
    return mode == "rest"
        ? ListTile(
          tileColor: Color.fromARGB(255, 184, 187, 38),
          leading: Text(
            mode,
            style: TextStyle(color: Color.fromARGB(255, 60, 56, 54)),
          ),
          title: Text(
            "$hour:$minutes",
            style: TextStyle(color: Color.fromARGB(255, 251, 241, 199)),
          ),
          trailing: Text(
            "$total minutes",
            style: TextStyle(color: Color.fromARGB(255, 60, 56, 54)),
          ),
        )
        : ListTile(
          tileColor: Color.fromARGB(255, 69, 133, 136),
          leading: Text(
            mode,
            style: TextStyle(color: Color.fromARGB(255, 29, 32, 33)),
          ),
          title: Text(
            "$hour:$minutes",
            style: TextStyle(color: Color.fromARGB(255, 235, 219, 178)),
          ),
          trailing: Text(
            "$total minutes",
            style: TextStyle(color: Color.fromARGB(255, 60, 56, 54)),
          ),
        );
  }

  void _changeDay(int changeBy) {
    // full implementation remaining
    // does not account for month change as of now.
    // someday in the future...
    setState(() {
      day += changeBy;
    });
  }

  void _getSessionsForDate({
    required int year,
    required int month,
    required int day,
  }) {
    specificSessions = [];
    for (final session in sessions) {
      String mode = session["mode"];
      int sessionYear = session["date"][DateMeasures.year.toString()];
      int sessionMonth = session["date"][DateMeasures.month.toString()];
      int sessionDay = session["date"][DateMeasures.day.toString()];

      if (sessionYear == year && sessionMonth == month && sessionDay == day) {
        specificSessions.add(session);
        if (mode == "work") focusedMinutes += session["duration"];
      }
    }
  }

  String _getFocusedTime() {
    num hour = (focusedMinutes / 60).truncate();
    num minutes = focusedMinutes - (60 * hour);
    if (hour == 0) {
      return "$minutes m";
    }
    return "$hour h $minutes m";
  }

  @override
  Widget build(BuildContext context) {
    return sessions.isEmpty
        ? Scaffold(
          appBar: AppBar(),
          body: Center(child: Text("You have no sessions yet.")),
        )
        : Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SizedBox(
              width: 600,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    // date
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // these buttons are broken,
                          // i don't know why,
                          // and i don't intend to fix these,
                          // at least not now.
                          // Do whatever you will.
                          //IconButton(
                          //  onPressed: () {
                          //    _changeDay(-1);
                          //  },
                          //  icon: Icon(Icons.arrow_left),
                          //),
                          Text("$year/$month/$day"),
                          // Pretend you didn't see these.
                          // I have no more motivation left to fix this shit.
                          //IconButton(
                          //  onPressed: () {
                          //    _changeDay(1);
                          //  },
                          //  icon: Icon(Icons.arrow_right),
                          //),
                        ],
                      ),
                    ),

                    Text("Focused: ${_getFocusedTime()}"),
                    // graph
                    // it was planned,
                    // but i don't feel like looking at this anymore.
                    Expanded(
                      child: ListView.builder(
                        itemCount: specificSessions.length,
                        itemBuilder: (context, index) {
                          return _listBody(index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
  }
}
