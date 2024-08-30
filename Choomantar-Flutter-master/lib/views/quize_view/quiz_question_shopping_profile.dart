import 'package:easy_localization/easy_localization.dart';

class QuizDataShopping {
  static List<Map<String, dynamic>> getShoppingQuestions() {
    return [
      {
        'question': "Are you primary grocery shopper?".tr(),
        'options': [
          "Yes".tr(),
          "No".tr()
        ],
      },
      {
        'question': "Do you shop online?".tr(),
        'options': [
          "Yes".tr(),
          "No".tr()
        ],
      },
      {
        'question': "What type of shopping do you do online?".tr(),
        'options': [
          "Clothes and Shoes".tr(),
          "Electronics".tr(),
          "Grocery".tr(),
          "Toys".tr(),
          "Auto parts".tr(),
          "General Household".tr(),
          "Crockery".tr(),
          "Others".tr(),
        ],
      },
      {
        'question': "Where do you go for monthly groceries?".tr(),
        'options': [
          "Big Retail Stores(Metro, Imtiaz, Al Fatah etc )".tr(),
          "Utility Stores".tr(),
          "Mid Sized Retail Stores(Different Save Marts)".tr(),
          "Online Grocery Apps".tr(),
          "Small Karyana Stores".tr(),
          "Cash & Carry Stores".tr(),
        ],
      },
      {
        'question': "How often do you shop online?".tr(),
        'options': [
          "Regularly".tr(),
          "Occasionally".tr(),
          "As & when required".tr(),
          "Never".tr()
        ],
      },
      {
        'question': "Are you brand conscious? Or do you give preference to big brands?".tr(),
        'options': [
          "Yes".tr(),
          "No".tr()
        ],
      },
      {
        'question': "How much do you spend on monthly grocery shopping?".tr(),
        'options': [
          "20K-30K",
          "30K-50K",
          "50K-75K",
          "75K-100K",
          "100K-200K",
          "200K & above".tr()
        ],
      },
      {
        'question': "Which brands do you choose while shopping online?".tr(),
        'options': [
          "Local Brands".tr(),
          "Foreign Brands".tr(),
          "Depends on what's required".tr(),
          "Doesn't Matter".tr()
        ],
      },
      // Add more questions here...
    ];
  }
}