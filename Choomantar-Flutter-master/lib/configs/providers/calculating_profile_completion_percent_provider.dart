import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculateProfileCompletionPercent extends ChangeNotifier {
  double? general_Percent;
  double? health_Percent;
  double? shopping_Percent;
  double? entertainment_Percent;
  double? technology_Percent;
  double? financial_Percent;
  double? all_Percents;
  double? resultAll;

  double _resultAll = 0;

  double get resultAl => _resultAll;


  Future<void> setGeneralCompletionPercent(double percent) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(percent!= null)
      {
        general_Percent = percent;
        prefs.setDouble('resultgeneral', general_Percent!);
      }
    if (kDebugMode) {
      print('im provider $general_Percent');
    }
    notifyListeners();
  }

  Future<void> setHealthCompletionPercent(double percent) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(percent!= null)
    {
      health_Percent = percent;
      prefs.setDouble('resulthealth', health_Percent!);
    }
    if (kDebugMode) {
      print('im provider $health_Percent');
    }
    notifyListeners(); // Notify listeners that the data has changed
  }
  Future<void> setShoppingCompletionPercent(double percent) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(percent!= null)
    {
      shopping_Percent = percent;
      prefs.setDouble('resultshopping', shopping_Percent!);
    }
    if (kDebugMode) {
      print('im provider $shopping_Percent');
    }
    notifyListeners(); // Notify listeners that the data has changed
  }
  Future<void> setEntertainmentCompletionPercent(double percent) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(percent!= null)
    {
      entertainment_Percent = percent;
      prefs.setDouble('resultentertainment',entertainment_Percent!);
    }
    if (kDebugMode) {
      print('im provider $entertainment_Percent');
    }
    notifyListeners(); // Notify listeners that the data has changed
  }
  Future<void> setTechnologyCompletionPercent(double percent) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(percent!= null)
    {
      technology_Percent = percent;
      prefs.setDouble('resulttechnology', technology_Percent!);
    }
    if (kDebugMode) {
      print('im provider $technology_Percent');
    }
    notifyListeners(); // Notify listeners that the data has changed
  }
  Future<void> setFinancialCompletionPercent(double percent) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(percent!= null)
    {
     financial_Percent = percent;
      prefs.setDouble('resultfinancial', financial_Percent!);
    }
    if (kDebugMode) {
      print('im provider $financial_Percent');
    }
    notifyListeners(); // Notify listeners that the data has changed
  }
  Future<void> calculateAllPercents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve all the stored percents
    double generalPercent = prefs.getDouble('resultgeneral') ?? 0;
    double healthPercent = prefs.getDouble('resulthealth') ?? 0;
    double shoppingPercent = prefs.getDouble('resultshopping') ?? 0;
    double entertainmentPercent = prefs.getDouble('resultentertainment') ?? 0;
    double technologyPercent = prefs.getDouble('resulttechnology') ?? 0;
    double financialPercent = prefs.getDouble('resultfinancial') ?? 0;

    // Calculate the sum of all percents
    all_Percents = generalPercent +
        healthPercent +
        shoppingPercent +
        entertainmentPercent +
        technologyPercent +
        financialPercent;

    _resultAll = all_Percents ?? 0;

    // Save the result in SharedPreferences
    prefs.setDouble('resultall', all_Percents ?? 0);

  notifyListeners();
  }
}
