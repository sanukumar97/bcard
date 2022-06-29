import 'package:flutter/material.dart';

String colorEncoder(Color c) {
  return "${c.red},${c.green},${c.blue},${c.opacity}";
}

Color colorDecoder(String c) {
  if (c == null || (c != null && c.isEmpty)) return Colors.white;
  int r, g, b;
  double o;
  try {
    r = int.parse(c.split(",")[0]);
  } catch (e) {
    print("error in getting red color  $c  $e");
    r = 255;
  }
  try {
    g = int.parse(c.split(",")[1]);
  } catch (e) {
    print("error in getting green color  $c  $e");
    g = 255;
  }
  try {
    b = int.parse(c.split(",")[2]);
  } catch (e) {
    print("error in getting blue color  $c  $e");
    b = 255;
  }
  try {
    o = double.parse(c.split(",")[3]);
  } catch (e) {
    print("error in getting opacity  $c  $e");
    o = 1.0;
  }
  return Color.fromRGBO(r, g, b, o);
}

String dateString(DateTime date) {
  DateTime _today = DateTime.now();
  String _dateString;
  if (date.year == _today.year &&
      date.month == _today.month &&
      date.day == _today.day) {
    _dateString = "Today";
  } else {
    _dateString = to2Digit(date.day) +
        "/" +
        to2Digit(date.month) +
        "/" +
        to2Digit(date.year);
  }
  return _dateString;
}

String timeString(TimeOfDay time) {
  return "${to2Digit(time.hourOfPeriod)}:${to2Digit(time.minute)} ${time.period == DayPeriod.am ? "am" : "pm"}";
}

String to2Digit(int x) {
  if (x < 10)
    return "0$x";
  else
    return "$x";
}

String addHandleHeader(String handle, int index) {
  switch (index) {
    case 0:
      return "instagram.com/$handle/";
      break;
    case 1:
      return "wa.me/91$handle";
      break;
    case 2:
      return "behance.net/$handle";
      break;
    case 3:
      return "linkedin.com/$handle/";
      break;
    case 4:
      return "facebook.com/$handle/";
      break;

    default:
      return "";
  }
}

String makeFirstLetterUpperCase(String name) {
  return name[0].toUpperCase() + name.substring(1);
}
