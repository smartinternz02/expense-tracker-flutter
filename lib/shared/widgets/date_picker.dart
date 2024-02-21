import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseDatePicker extends StatefulWidget {
  final Function(DateTime)? onDateSelected;
  const ExpenseDatePicker({super.key, this.onDateSelected});

  @override
  State<ExpenseDatePicker> createState() => _ExpenseDatePickerState();
}

class _ExpenseDatePickerState extends State<ExpenseDatePicker> {
  DateTime? date;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          var selectedDate = await showDatePicker(
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              initialDatePickerMode: DatePickerMode.day,
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100));

          if (selectedDate != null) {
            setState(() {
              date = selectedDate;
            });

            if (widget.onDateSelected != null) {
              widget.onDateSelected!(selectedDate);
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey, width: 1)),
          child: Text(
              DateFormat('EEE, MMM dd, yyyy').format(date ?? DateTime.now())),
        ));
  }
}
