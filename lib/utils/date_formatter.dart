import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDateFromString(
  String date,
  String inputFormat,
  String outputFormat,
) {
  try {
    var inputFormatter = DateFormat(inputFormat);
    var outFormatter = DateFormat(outputFormat);
    DateTime inputDate = inputFormatter.parse(date);
    return outFormatter.format(inputDate);
  } catch (e) {
    debugPrint(e.toString());
    return date;
  }
}

String formatDateFromDate({
  required DateTime dateTime,
  required String format,
}) {
  var outFormatter = DateFormat(format);
  return outFormatter.format(dateTime);
}

DateTime? stringToDateTime({required String date, required String format}) {
  DateTime? dateTime;
  try {
    dateTime = DateFormat(format).parse(date);
  } catch (e) {
    dateTime = null;
  }
  return dateTime;
}
