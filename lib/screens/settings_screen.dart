import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pomodoro/interface/data_handler.dart';
import 'package:pomodoro/models/user.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final previousData = getUserSettings();

  Color workBg = Colors.green;
  Color workFg = Colors.white;
  Color restBg = Colors.blue;
  Color restFg = Colors.white;

  @override
  void initState() {
    super.initState();
    workBg = _getColor(previousData[Settings.work_background.toString()]);
    workFg = _getColor(previousData[Settings.work_foreground.toString()]);
    restBg = _getColor(previousData[Settings.rest_background.toString()]);
    restFg = _getColor(previousData[Settings.rest_foreground.toString()]);
  }

  Color _getColor(String? hex) {
    if (hex == null || hex.isEmpty) return Colors.grey.shade400;
    try {
      return Color(int.parse(hex.replaceFirst("#", "ff"), radix: 16));
    } catch (e) {
      return Colors.grey.shade400;
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

  Widget _colorRow(String label, Color color, void Function(Color) onPick) {
    return InkWell(
      onTap: () => _openColorPicker(color, onPick),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade400,
                  width: color == Colors.white ? 1.5 : 0.2,
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
      backgroundColor: const Color(0xFFF8F6FA),
      appBar: AppBar(
        title: const Text("Customize Colors"),
        backgroundColor: const Color(0xFF35AE73), // Custom green
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
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
                    backgroundColor: const Color(0xFF35AE73),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontSize: 16, color: Colors.purple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
