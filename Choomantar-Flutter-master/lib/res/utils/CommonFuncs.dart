import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../configs/imports/import_helper.dart';

class CommonFuncs {

   static const bool sToast = AppConst.showToasts;

  static void apiHitPrinter(String statusCode, String url, String method, String params, dynamic resp, String pageName)
  {
    try{
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      String prettyprint = encoder.convert(resp);

      final logg = "============================J-API HIT============================\n\nSCREEN: $pageName\n\nCODE: $statusCode\nURL: $url\n"
          "METHOD: $method\nPARAMS: $params\n\n$prettyprint";

   //   log(logg);
        print(logg);

      debugPrint(logg, wrapWidth: 1024);
    }
    catch(e)
    {
      if (kDebugMode) {
        print(e.toString());
      }
    }

  }


  static void showToast(String msg)
  {
    if(sToast) {
      Fluttertoast.showToast(msg: msg,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          backgroundColor: AppColors.urduBtn);
    }
  }


}
