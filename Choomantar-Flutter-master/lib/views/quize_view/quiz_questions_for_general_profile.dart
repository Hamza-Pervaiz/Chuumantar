import 'package:easy_localization/easy_localization.dart';

class QuizDataGeneral {
  static List<Map<String, dynamic>> getQuestions() {
    return [
      {
        'question': "Tell us about your gender?".tr(),
        'options': ["Male".tr(), "Female".tr(), "Transgender".tr()]
      },
      {
        'question': "Tell us about your education level?".tr(),
        'options': [
          "Illiterate".tr(),
          "Primary".tr(),
          "Secondary".tr(),
          "Materic".tr(),
          "Bachelors".tr(),
          "Masters & Above".tr(),
        ]
      },
      {
        'question': "Tell us about your marital status?".tr(),
        'options': [
          "Single".tr(),
          "Married".tr(),
          "Divorced / Separated".tr(),
        ]
      },
      {
        'question': "Your number of dependents".tr(),
        'options': [
          "1".tr(),
          "2".tr(),
          "3".tr(),
          "4".tr(),
          "5".tr(),
          "None".tr(),
        ]
      },
      {
        'question': "Children under 18 years old in your household?".tr(),
        'options': [
          "1".tr(),
          "2".tr(),
          "3".tr(),
          "4".tr(),
          "5".tr(),
          "None".tr(),
        ]
      },
      {
        'question': "Are your parents living with you?".tr(),
        'options': [
          "Yes".tr(),
          "No".tr(),
        ]
      },
      {
        'question': "Do you own a pet?".tr(),
        'options': [
          "Yes".tr(),
          "No".tr(),
        ]
      },
      {
        'question': "Which mode of transport do you use?".tr(),
        'options': [
          "Car".tr(),
          "Motorbike".tr(),
          "Public Transport".tr(),
          "Cycle".tr(),
          "Others".tr(),
        ]
      },
      {
        'question': "Have you ever travelled abroad?".tr(),
        'options': [
          "Yes".tr(),
          "No".tr(),
        ]
      },
      {
        'question': "What is your favorite color?".tr(),
        'options': [
          "Red".tr(),
          "Blue".tr(),
          "Green".tr(),
          "Black".tr(),
          "White".tr(),
          "Others".tr(),
        ]
      },
      {
        'question': "What will be the color of your dream car?".tr(),
        'options': [
          "White".tr(),
          "Black".tr(),
          "Silver".tr(),
          "Red".tr(),
          "Blue".tr(),
          "Others".tr(),
        ]
      },
      {
        'question': "How often do you travel with family?".tr(),
        'options': [
          "Twice a year".tr(),
          "Once a year".tr(),
          "Once in 2 years".tr(),
          "During Summer vacation only".tr(),
          "Never".tr(),
        ]
      },
      {
        'question': "Which industry do you work for?".tr(),
        'options': [
          "Banking".tr(),
          "Telecom".tr(),
          "Oil & Gas".tr(),
          "IT".tr(),
          "Education".tr(),
          "Self Employed".tr(),
          "Private Company".tr(),
        ]
      },
      {
        'question': "How often do you Travel for work?".tr(),
        'options': [
          "Frequently".tr(),
          "Once a year".tr(),
          "Once in 3 months".tr(),
          "Twice a year".tr(),
          "Never".tr(),
        ]
      },
    ];
  }
}