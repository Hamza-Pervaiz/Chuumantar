import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCompletionStatus extends ChangeNotifier {
  bool? isCompletedGeneral;
  bool? isCompletedHealth;
  bool? isCompletedShopping;
  bool? isCompletedEntertainment;
  bool? isCompletedTechnology;
  bool? isCompletedFinancial;

  bool? get completedGeneral => isCompletedGeneral;
  bool? get completedHealth => isCompletedHealth;
  bool? get completedShopping => isCompletedShopping;
  bool? get completedEntertainment => isCompletedEntertainment;
  bool? get completedTechnology => isCompletedTechnology;
  bool? get completedFinancial => isCompletedFinancial;

  Future<void> getCompleteionProfilesData() async {
    SharedPreferences preffs = await SharedPreferences.getInstance();
    isCompletedGeneral = preffs.getBool('completedGeneral') ?? false;
    isCompletedHealth = preffs.getBool('completedHealth') ?? false;
    isCompletedShopping = preffs.getBool('completedShopping') ?? false;
    isCompletedEntertainment =
        preffs.getBool('completedEntertainment') ?? false;
    isCompletedTechnology = preffs.getBool('completedTechnology') ?? false;
    isCompletedFinancial = preffs.getBool('completedFinancial') ?? false;

    notifyListeners();
  }
}
