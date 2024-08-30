import 'dart:convert';

import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../models/inappnotifications_model.dart';
import '../../res/app_urls.dart';

class ApiService {
  // Future<List<NotificationModel>> fetchNotifications() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String userId = prefs.getString('uid') ?? '';

  //   var response = await http.post(
  //     Uri.parse(AppUrls.inAppNotifications),
  //     body: {"userId": userId},
  //   );

  //   if (response.statusCode == 200) {
  //     List<dynamic> data = jsonDecode(response.body);
  //     var dataa = jsonDecode(response.body);
  //     CommonFuncs.apiHitPrinter("200", AppUrls.inAppNotifications, "POST", "userId: $userId", dataa, "api_class_notification");
  //     return data.map((json) => NotificationModel.fromJson(json)).toList();
  //   } else {
  //     CommonFuncs.apiHitPrinter(response.statusCode.toString(), AppUrls.inAppNotifications, "POST", "userId: $userId", 'Failed to load notifications',  "api_class_notification");
  //     throw Exception('Failed to load notifications');
  //   }
  // }
  Future<List<NotificationModel>> fetchNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('uid') ?? '';

    List<NotificationModel> notifications = [];
    List<NotificationModel> latestnotifications = [];
    int firstId = 0;

    // Fetch existing notifications
    try {
      var response = await http.post(
        Uri.parse(AppUrls.inAppNotifications),
        body: {"userId": userId},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        notifications =
            data.map((json) => NotificationModel.fromJson(json)).toList();

        // Determine the smallest ID from the existing notifications
        if (notifications.isNotEmpty) {
          firstId = notifications
              .map((n) => int.tryParse(n.id) ?? 0)
              .reduce((a, b) => a < b ? a : b);
        }

        CommonFuncs.apiHitPrinter("200", AppUrls.inAppNotifications, "POST",
            "userId: $userId", data, "api_class_notification");
      } else {
        CommonFuncs.apiHitPrinter(
            response.statusCode.toString(),
            AppUrls.inAppNotifications,
            "POST",
            "userId: $userId",
            'Failed to load notifications',
            "api_class_notification");
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching notifications: $e');
      }
    }

    // Fetch and add lucky draw notification if available
    try {
      var luckyDrawResponse = await http.post(
        Uri.parse(AppUrls.luckydrawWinners),
        body: {"id": userId},
      );

      if (luckyDrawResponse.statusCode == 200) {
        var dataa = jsonDecode(luckyDrawResponse.body);

        if (dataa is Map<String, dynamic> &&
            dataa.containsKey('message') &&
            dataa['message'] != null &&
            dataa['message'].isNotEmpty) {
          // Create a new NotificationModel instance with the message
          NotificationModel newNotification = NotificationModel(
            id: (firstId - 1).toString(), // Assign the new ID as firstId - 1
            userId: userId,
            message: dataa['message'],
          );

          // Add the new notification to the existing list
          latestnotifications.add(newNotification);
          latestnotifications.addAll(notifications);
        }
      } else {
        if (kDebugMode) {
          print(
              'Lucky draw notification request failed with status: ${luckyDrawResponse.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching lucky draw notification: $e');
      }
    }

    return latestnotifications; // Return the list with the new notification added
  }
}
