import 'package:chumanter/configs/imports/import_helper.dart';

class LanguageBtnProvider extends ChangeNotifier {
  bool _select = true;
  get select => _select;
  setSelect(bool taped) {
    _select = taped;
    notifyListeners();
  }
}
