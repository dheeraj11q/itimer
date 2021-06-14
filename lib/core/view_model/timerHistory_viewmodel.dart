import 'package:itimer/core/view_model/home_viewmodel.dart';
import 'package:stacked/stacked.dart';

class TimerHistoryViewModel extends BaseViewModel {
  Future getallTimeHistory() async {
    var allrows = await dbhelper.queryall();

    return allrows;
  }

  Future<void> clearDB() async {
    await dbhelper.databaseclear();
    notifyListeners();
  }
}
