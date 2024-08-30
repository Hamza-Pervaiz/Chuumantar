import 'package:easy_localization/easy_localization.dart';

class QuizDataHealth {
  static List<Map<String, dynamic>> getQuestionsHealth() {
    return [
      {
        'question': "What is your blood group?".tr(),
        'options': [
          "A+",
          "B+",
          "O+",
          "AB+",
          "AB-",
          "O-",
          "A-",
          "B-",
          "Don't Know".tr()
        ],
      },
      {
        'question': "How often do you take pain killers?".tr(),
        'options': [
          "Daily".tr(),
          "Once a week".tr(),
          "Once a month".tr(),
          "Once in 2 months".tr(),
          "Once in 6 months".tr(),
          "Never".tr(),
        ],
      },
      {
        'question': "Tell us about your height".tr(),
        'options': [
          "4.0 to 4.5 feet".tr(),
          "4.5 to 5.0 feet".tr(),
          "5.0 to 5.5 feet".tr(),
          "5.5 to 6.0 feet".tr(),
          "6.0 to 6.5 feet".tr(),
          "6.5 feet & above".tr(),
        ],
      },
      {
        'question': "Tell us about your weight (in KG's)".tr(),
        'options': [
          "40-50 KG".tr(),
          "50-60 KG".tr(),
          "60-80 KG".tr(),
          "80-100 KG".tr(),
          "100-120 KG".tr(),
          "More than 120 KG".tr(),
        ],
      },
      {
        'question': "How often do you exercise (Walk, Gym, Swimming or any sports etc)".tr(),
        'options': [
          "Daily".tr(),
          "3 times a week".tr(),
          "Once a week".tr(),
          "Twice a month".tr(),
          "Occasionally".tr(),
          "I do not exercise at all".tr(),
        ],
      },
      {
        'question': "What mode of exercise you do".tr(),
        'options': [
          "Walk (nature walk) / Trekking".tr(),
          "Gym".tr(),
          "Swimming".tr(),
          "Treadmill".tr(),
          "Regular Sports".tr(),
          "I do not exercise".tr(),
        ],
      },
      {
        'question': "Do you smoke?".tr(),
        'options': [
          "No".tr(),
          "Occasionally".tr(),
          "Less than 5 cigarettes a day".tr(),
          "Half pack a day".tr(),
          "One pack of 20 a day".tr(),
          "More than one pack a day".tr()
        ],
      },
      {
        'question': "When was your last medical check-up?".tr(),
        'options': [
          "Last month".tr(),
          "Once in 6 months".tr(),
          "Once a year".tr(),
          "When required".tr(),
          "Never".tr(),
        ],
      },
      {
        'question': "Do you have any terminal illness / Do you suffer from any kind of illness/disease?".tr(),
        'options': [
          "Yes".tr(),
          "No".tr()
        ],
      },
      {
        'question': "Are you on regular medication?".tr(),
        'options': [
          "Yes".tr(),
          "No".tr(),
          "Blood Pressure".tr(),
          "Sugar".tr(),
          "Blood Pressure and Sugar".tr(),
          "Other Medication".tr(),
        ],
      },

      {
        'question': "Is fruit a part of your regular daily meal?".tr(),
        'options': [
          "Yes".tr(),
          "Occasionally".tr(),
          "No".tr()
        ],
      },
      {
        'question': "Are you covid vaccinated?".tr(),
        'options': [
          "Yes both doses".tr(),
          "Yes both doses with a booster shot".tr(),
          "One dose only".tr(),
          "No".tr(),
        ],
      },
      {
        'question': "How many cups of tea/coffee you consume in a day?".tr(),
        'options': [
          "Less than 2".tr(),
          "Less than 5".tr(),
          "Less than 10".tr(),
          "I don't drink coffee/tea".tr(),
        ],
      },
      {
        'question': "What type of water you use for your daily life".tr(),
        'options': [
          "Tap water".tr(),
          "Filter water".tr(),
          "Mineral water".tr(),
          "Boiled water".tr(),
        ],
      },
      // {
      //   'question': "Are your kids Polio vaccinated?",
      //   'options': ["Yes", "No"],
      // },
      // Add more questions here...
    ];
  }
}