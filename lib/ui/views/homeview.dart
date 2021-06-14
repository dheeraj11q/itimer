import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:itimer/core/view_model/home_viewmodel.dart';
import 'package:itimer/ui/views/timerHistoryView.dart';
import 'package:itimer/ui/widgets/circleButton.dart';
import 'package:itimer/ui/widgets/timepicker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:stacked/stacked.dart';

class Homeview extends StatefulWidget {
  @override
  _HomeviewState createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();

    var initSetting = new InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: onSelectnotification);
  }

  Future onSelectnotification(String pyload) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => TimerHistoryView()));

    return null;
  }

  shownotification(int id, name, address) async {
    var android = new AndroidNotificationDetails(
        "channelId", "channelName", "channelDescription");
    var ios = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: ios);
    await flutterLocalNotificationsPlugin.show(id, name, address, platform);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ViewModelBuilder<HomeViewmodel>.reactive(
        builder: (context, model, child) => SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Text(
                    "iTimer",
                    style: TextStyle(color: Colors.brown),
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0,
                  actions: [
                    Row(
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.history,
                              color: Colors.brown,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TimerHistoryView()));
                            }),
                      ],
                    )
                  ],
                ),
                body: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        flex: 7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: size.height * 0.08,
                            ),
                            model.starttimerbool && model.pauseBool == false
                                ? Text(
                                    "Timer Started",
                                    style:
                                        TextStyle(fontSize: size.width * 0.06),
                                  )
                                : model.pauseBool
                                    ? Text(
                                        "Timer Paused",
                                        style: TextStyle(
                                            fontSize: size.width * 0.06),
                                      )
                                    : Text(
                                        "Timer Start",
                                        style: TextStyle(
                                            fontSize: size.width * 0.06),
                                      ),
                            SizedBox(
                              height: size.height * 0.04,
                            ),
                            model.starttimerbool == false
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      timepick(
                                          context: context,
                                          timetype: "HH",
                                          timenum: model.hours,
                                          func: model.hoursValueonChange),
                                      timepick(
                                          context: context,
                                          timetype: "MM",
                                          timenum: model.minutes,
                                          func: model.minuteValueonChange),
                                      timepick(
                                          context: context,
                                          timetype: "SS",
                                          timenum: model.seconds,
                                          func: model.secondValueonChange),
                                    ],
                                  )
                                : Text(
                                    "${model.timeDisplay}",
                                    style:
                                        TextStyle(fontSize: size.width * 0.06),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          model.starttimerbool == false ||
                                  model.pauseBool == true
                              ? circleButton(
                                  btnColor: Colors.brown,
                                  icon: Icons.play_arrow,
                                  func: () {
                                    model.startTimer(
                                        shownotificationFunc: shownotification);
                                  })
                              : circleButton(
                                  btnColor: Colors.yellow[700],
                                  icon: Icons.pause,
                                  func: model.pauseitimer),
                          SizedBox(
                            width: size.width * 0.01,
                          ),
                          model.starttimerbool == true
                              ? circleButton(
                                  btnColor: Colors.red,
                                  icon: Icons.stop,
                                  func: model.stopTimer)
                              : SizedBox()
                        ],
                      ),
                    )
                  ],
                )),
              ),
            ),
        viewModelBuilder: () => HomeViewmodel());
  }
}

// class Homeview extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return ViewModelBuilder<HomeViewmodel>.reactive(
//         builder: (context, model, child) => SafeArea(
//               child: Scaffold(
//                 backgroundColor: Colors.white,
//                 appBar: AppBar(
//                   title: Text(
//                     "iTimer",
//                     style: TextStyle(color: Colors.green),
//                   ),
//                   backgroundColor: Colors.white,
//                   elevation: 0,
//                   actions: [
//                     IconButton(
//                         icon: Icon(
//                           Icons.history,
//                           color: Colors.black,
//                         ),
//                         onPressed: () {})
//                   ],
//                 ),
//                 body: Center(
//                     child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Expanded(
//                         flex: 7,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               height: size.height * 0.08,
//                             ),
//                             model.starttimerbool && model.pauseBool == false
//                                 ? Text(
//                                     "Timer Start",
//                                     style:
//                                         TextStyle(fontSize: size.width * 0.06),
//                                   )
//                                 : model.pauseBool
//                                     ? Text(
//                                         "Timer Pause",
//                                         style: TextStyle(
//                                             fontSize: size.width * 0.06),
//                                       )
//                                     : Text(
//                                         "Timer",
//                                         style: TextStyle(
//                                             fontSize: size.width * 0.06),
//                                       ),
//                             SizedBox(
//                               height: size.height * 0.04,
//                             ),
//                             model.starttimerbool == false
//                                 ? Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       timepick(
//                                           context: context,
//                                           timetype: "HH",
//                                           timenum: model.hours,
//                                           func: model.hoursValueonChange),
//                                       timepick(
//                                           context: context,
//                                           timetype: "MM",
//                                           timenum: model.minutes,
//                                           func: model.minuteValueonChange),
//                                       timepick(
//                                           context: context,
//                                           timetype: "SS",
//                                           timenum: model.seconds,
//                                           func: model.secondValueonChange),
//                                     ],
//                                   )
//                                 : Text(
//                                     "${model.timeDisplay}",
//                                     style:
//                                         TextStyle(fontSize: size.width * 0.06),
//                                   ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                           ],
//                         )),
//                     Expanded(
//                       flex: 3,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           model.starttimerbool == false ||
//                                   model.pauseBool == true
//                               ? circleButton(
//                                   btnColor: Colors.green,
//                                   icon: Icons.play_arrow,
//                                   func: model.startTimer)
//                               : circleButton(
//                                   btnColor: Colors.yellow,
//                                   icon: Icons.pause,
//                                   func: model.pauseitimer),
//                           SizedBox(
//                             width: size.width * 0.01,
//                           ),
//                           model.starttimerbool == true
//                               ? circleButton(
//                                   btnColor: Colors.red,
//                                   icon: Icons.stop,
//                                   func: model.stopTimer)
//                               : SizedBox()
//                         ],
//                       ),
//                     )
//                   ],
//                 )),
//               ),
//             ),
//         viewModelBuilder: () => HomeViewmodel());
//   }
// }
