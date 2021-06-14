import 'package:flutter/material.dart';

import 'package:itimer/core/view_model/timerHistory_viewmodel.dart';
import 'package:stacked/stacked.dart';

class TimerHistoryView extends StatefulWidget {
  @override
  _TimerHistoryViewState createState() => _TimerHistoryViewState();
}

class _TimerHistoryViewState extends State<TimerHistoryView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ViewModelBuilder<TimerHistoryViewModel>.reactive(
        builder: (context, model, child) => SafeArea(
                child: Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  model.clearDB();
                },
                child: Icon(Icons.delete),
              ),
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  "Timer History",
                ),
              ),
              body: FutureBuilder(
                future: model.getallTimeHistory(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return snapshot.data.length == 0
                      ? Center(
                          child: Text(
                            "Empty",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: size.width * 0.05),
                          ),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data[index];
                            return Card(
                                child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                data["name"].toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.width * 0.05),
                              ),
                            ));
                          });
                },
              ),
            )),
        viewModelBuilder: () => TimerHistoryViewModel());
  }
}
