import 'package:flutter/material.dart';

Future<DateTime?> pickDate(
    {required BuildContext context,
    DateTime? firstDate,
    DateTime? initialDate}) async {
  return showDatePicker(
      context: context,
      firstDate: firstDate ?? DateTime(2000),
      lastDate: DateTime(2050),
      initialDate: initialDate ?? DateTime.now());
}
