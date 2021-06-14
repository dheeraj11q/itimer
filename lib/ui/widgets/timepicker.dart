import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:numberpicker/numberpicker.dart';

timepick({context, String timetype, int timenum, func}) {
  var size = MediaQuery.of(context).size;
  return Column(
    children: [
      NumberPicker.integer(
          initialValue: timenum,
          minValue: 0,
          maxValue: 12,
          listViewWidth: 60,
          onChanged: (v) {
            func(v);
          }),
      Text(
        timetype,
        style: TextStyle(fontSize: size.width * 0.04, color: Colors.grey),
      )
    ],
  );
}
