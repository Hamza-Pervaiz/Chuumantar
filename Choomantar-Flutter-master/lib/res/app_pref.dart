import 'package:chumanter/configs/imports/import_helper.dart';

class AppPref {
  static SharedPreferences? sp;
  static Future getData() async {
    sp = await SharedPreferences.getInstance();
  }
}
