import 'package:flutter/material.dart';

Widget circleButton({btnColor, icon, func}) {
  return MaterialButton(
    shape: CircleBorder(),
    padding: EdgeInsets.all(10),
    onPressed: func,
    color: btnColor,
    child: Icon(
      icon,
      color: Colors.white,
    ),
  );
}
