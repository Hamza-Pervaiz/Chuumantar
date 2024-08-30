import 'package:chumanter/configs/imports/import_helper.dart';

class StatusProvider extends ChangeNotifier {
  Status _status = Status.UNINITIALIZE;
  Status get getStatus => _status;
  void setStatus(Status status) {
    _status = status;
    notifyListeners();
  }
}
