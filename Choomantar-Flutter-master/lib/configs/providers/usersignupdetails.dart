import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? userEmail;
  String? userName;
  String? userPhoneNumber;
  String? userPin;
  String? imagePath;
  UserProvider() {
    // Initialize the values from SharedPreferences in the constructor
    loadUserDetails();
  }

  void loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userEmail = prefs.getString('user_email') ?? "";
    userName = prefs.getString('username') ?? "";
    userPhoneNumber = prefs.getString('user_mobile') ?? "";
    userPin = prefs.getString('user_password') ?? "";
    imagePath = prefs.getString('user_image') ?? "";

    notifyListeners();
  }

  void setUserDetails(String email, String name, String phone, String user_pin,
      String image_Path) {
    userEmail = email;
    userName = name;
    userPhoneNumber = phone;
    userPin = user_pin;
    imagePath = image_Path;
    // Save the updated values to SharedPreferences
    saveUserDetails();

    notifyListeners();
  }

  void saveUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('user_email', userEmail ?? "");
    prefs.setString('username', userName ?? "");
    prefs.setString('user_mobile', userPhoneNumber ?? "");
    prefs.setString('user_password', userPin ?? "");
    prefs.setString('user_image', imagePath ?? "");

    notifyListeners();
  }
}
