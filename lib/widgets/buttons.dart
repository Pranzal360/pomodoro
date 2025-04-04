import 'package:flutter/material.dart';
import 'package:pomodoro/interface/hexcolor.dart';
import 'package:pomodoro/screens/settings_screen.dart';
import 'package:pomodoro/screens/timeline_screen.dart';

class ButtonMore extends StatelessWidget {
  const ButtonMore({super.key, required this.color});

  final String color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed:
              () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (ctx) => TimelineScreen())),
          child: Text(
            "Timeline",
            style: TextStyle(color: HexColor.fromHex(color)),
          ),
        ),
        SizedBox(width: 30),
        TextButton(
          onPressed:
              () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (ctx) => SettingsScreen())),
          child: Text(
            "Settings",
            style: TextStyle(color: HexColor.fromHex(color)),
          ),
        ),
      ],
    );
  }
}
