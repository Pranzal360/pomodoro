enum DateMeasures { year, month, day, hour, minute }

class TimeStamp {
  const TimeStamp({
    required this.date,
    required this.mode,
    required this.duration,
  });

  final Map<String, int> date;
  final String mode;
  final int duration;
}
