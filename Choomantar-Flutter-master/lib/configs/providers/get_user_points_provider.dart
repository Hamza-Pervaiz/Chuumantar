import 'dart:developer';

import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GetUserPoints extends ChangeNotifier {
  int _points = 0;

  int get points => _points;

  Future<void> fetchUserPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('uid');

    if (userId == null) {
      log('User ID is null');
      return;
    }

    try {

      var response = await http.post(
        Uri.parse(AppUrls.getPoints),
        body: {
          "userId": userId,
        },
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        CommonFuncs.apiHitPrinter("200", AppUrls.getPoints,
            "POST", "userId: $userId",
            data, "get_user_points_provider");

        if (data != null && data['points'] is String) {
          _points = int.tryParse(data['points']) ?? 0;
          if (kDebugMode) {
            print('Points are: $_points');
          }
          notifyListeners();
        } else {
          log("Invalid data format received from the getPoints API.");
        }
      } else {

        CommonFuncs.apiHitPrinter(response.statusCode.toString(), AppUrls.getPoints,
            "POST", "userId: $userId",
            data, "get_user_points_provider");

        log("Failed to fetch data from the getPoints API. Status code: ${response.statusCode}");

      }
    } catch (e) {
      log("Error fetching user points: $e");
    }
    notifyListeners();
  }
}
