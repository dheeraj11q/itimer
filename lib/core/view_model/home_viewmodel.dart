import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:itimer/core/utils/db_helper.dart';
import 'package:itimer/ui/widgets/toast.dart';
import 'package:stacked/stacked.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
final dbhelper = Databasehelper.instance;

class HomeViewmodel extends BaseViewModel {
  bool starttimerbool = false;
  bool pauseBool = false;
  bool stopTimerBool = false;

  int totalSeconds = 0;
  int seconds = 0;
  int minutes = 0;
  int hours = 0;
  String timeDisplay = "";
  String totalTime = "";

  void secondValueonChange(v) {
    seconds = v;
    notifyListeners();
  }

  void minuteValueonChange(v) {
    minutes = v;
    notifyListeners();
  }

  void hoursValueonChange(v) {
    hours = v;
    notifyListeners();
  }

  Future<void> startTimer({shownotificationFunc}) async {
    print(totalSeconds);
    if (totalSeconds == 0) {
      totalSeconds = hours * 60 * 60 + minutes * 60 + seconds;
      totalTime = secondtoTime(totalSeconds);
    }

    if (totalSeconds < 1) {
      showToast(text: "Please Select Time", backgroundColor: Colors.red);
    } else {
      starttimerbool = true;
      pauseBool = false;
      stopTimerBool = false;
      for (var i = totalSeconds; i >= 0; i--) {
        if (starttimerbool == false) {
          break;
        }

        if (pauseBool) {
          break;
        }

        await Future.delayed(Duration(seconds: 1), () {
          String time = secondtoTime(i);
          timeDisplay = time;

          totalSeconds = i;
          print(time);

          notifyListeners();
        });

        if (stopTimerBool) {
          stopTimer();
          break;
        }
      }

      if (pauseBool == false && stopTimerBool == false) {
        starttimerbool = false;

        // timer done
        print(totalTime);
        stopTimer();
        var id = await timedatainsert(totalTime);

        shownotificationFunc(id, "iTimer", "The timer has stopped $totalTime");
      }

      stopTimerBool = false;

      notifyListeners();
    }
  }

  void stopTimer() {
    print("tmer Storp");
    seconds = 0;
    starttimerbool = false;
    pauseBool = false;
    stopTimerBool = true;

    hours = 0;
    minutes = 0;
    seconds = 0;
    totalSeconds = 0;
    notifyListeners();
  }

  void pauseitimer() {
    pauseBool = true;
    notifyListeners();
  }

  Future timedatainsert(String time) async {
    Map<String, dynamic> row = {
      Databasehelper.columnname: time,
    };
    final id = await dbhelper.insert(row);
    return id;
  }

// sec to time

  secondtoTime(sec) {
    int timerforTimer = sec;

    String timertodisplay = "";

    if (timerforTimer < 60) {
      timertodisplay = "00:00:" + timerforTimer.toString();
      timerforTimer = timerforTimer - 1;
    } else if (timerforTimer < 3600) {
      int m = timerforTimer ~/ 60;
      int s = timerforTimer - (60 * m);
      timertodisplay = "00:" + m.toString() + ":" + s.toString();
      timerforTimer = timerforTimer - 1;
    } else {
      int h = timerforTimer ~/ 3600;
      int t = timerforTimer - (3600 * h);
      int m = t ~/ 60;
      int s = t - (60 * m);
      timertodisplay = h.toString() + ":" + m.toString() + ":" + s.toString();
      timerforTimer = timerforTimer - 1;
    }

    print(timertodisplay);

    return timertodisplay;
  }
}
