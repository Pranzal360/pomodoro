import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pomodoro/interface/data_handler.dart';
import 'package:pomodoro/models/user.dart';

const Color kPremiumPrimary = Colors.black;
const Color kPremiumAccent = Colors.white;
const Color kCardColor = Colors.white;
const Color kBackground = Color(0xFFF8F6FA);

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final previousData = getUserSettings();

  Color workBg = Colors.white;
  Color workFg = Colors.black;
  Color restBg = Colors.white;
  Color restFg = Colors.black;

  @override
  void initState() {
    super.initState();
    workBg = _getColor(previousData[Settings.work_background.toString()]);
    workFg = _getColor(previousData[Settings.work_foreground.toString()]);
    restBg = _getColor(previousData[Settings.rest_background.toString()]);
    restFg = _getColor(previousData[Settings.rest_foreground.toString()]);
  }

  Color _getColor(String? hex) {
    if (hex == null || hex.isEmpty) return Colors.grey.shade300;
    try {
      return Color(int.parse(hex.replaceFirst("#", "ff"), radix: 16));
    } catch (e) {
      return Colors.grey.shade300;
    }
  }

  String _colorToHex(Color color) {
    return "#${color.value.toRadixString(16).substring(2)}";
  }

  void _openColorPicker(Color currentColor, void Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: kBackground,
          title: const Text("Pick a color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: onColorChanged,
              enableAlpha: false,
              displayThumbColor: true,
              labelTypes: const [ColorLabelType.hex],
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Done"),
            ),
          ],
        );
      },
    );
  }

  void _saveSettings() {
    updateSettings({
      Settings.work_background.toString(): _colorToHex(workBg),
      Settings.work_foreground.toString(): _colorToHex(workFg),
      Settings.rest_background.toString(): _colorToHex(restBg),
      Settings.rest_foreground.toString(): _colorToHex(restFg),
    });

    Navigator.of(context).pop();
  }

  void _resetToDefaults() {
    setState(() {
      workBg = Colors.white;
      workFg = Colors.black;
      restBg = Colors.white;
      restFg = Colors.black;
    });
  }

  Widget _colorRow(String label, Color color, void Function(Color) onPick) {
    return InkWell(
      onTap: () => _openColorPicker(color, onPick),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.computeLuminance() > 0.8
                      ? Colors.grey.shade400
                      : Colors.transparent,
                  width: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text("Customize Colors"),
        backgroundColor: kPremiumPrimary,
        foregroundColor: kPremiumAccent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              _colorRow("Work Background", workBg, (c) => setState(() => workBg = c)),
              _colorRow("Work Foreground", workFg, (c) => setState(() => workFg = c)),
              _colorRow("Rest Background", restBg, (c) => setState(() => restBg = c)),
              _colorRow("Rest Foreground", restFg, (c) => setState(() => restFg = c)),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveSettings,
                  icon: const Icon(Icons.save),
                  label: const Text("Save Settings"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: kPremiumPrimary,
                    foregroundColor: kPremiumAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontSize: 16, color: Colors.purple),
                ),
              ),
              TextButton(
                onPressed: _resetToDefaults,
                child: const Text(
                  "Reset to Defaults",
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
