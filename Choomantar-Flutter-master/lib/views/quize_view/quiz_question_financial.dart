import 'package:easy_localization/easy_localization.dart';

class QuizDataFinancial{
  static List<Map<String, dynamic>> getFinanceQuestions() {
    return [
      {
        'question': "Are you the primary earner?".tr(),
        'options': [
          "Yes".tr(),
          "No".tr()
        ],
      },
      {
        'question': "What is your monthly income?".tr(),
        'options': [
          "Less than PKR 25000/-".tr(),
          "PKR 25000/- to 50,000/-".tr(),
          "PKR 50,000/- to 100,000/-".tr(),
          "PKR 100,000/- to PKR 250,000/-".tr(),
          "PKR 250,000/- To 500,000/-".tr(),
          "More than PKR 500,000/-".tr(),
        ],
      },
      {
        'question': "What is your mode of earning?".tr(),
        'options': [
          "Govt. Job".tr(),
          "Private sector job".tr(),
          "Family business".tr(),
          "Online business".tr(),
           "Husband's / Parents income".tr(),
          "Investments (Property, National Savings, Rental Income etc.".tr(),
        ],
      },
      {
        'question': "Do you own a house?".tr(),
        'options': [
          "Yes".tr(),
          "No".tr()
        ],
      },
      {
        'question': "What is the size of the house you are currently living in?".tr(),
        'options': [
          "Less than 5 Marla (125 yards)".tr(),
          "5 Marla (125 Yards)".tr(),
          "10 Marla (250 yards)".tr(),
          "One Kanal (500 yards)".tr(),
          "2 Kanals (1000 Yards)".tr(),
          "Farmhouse (more than 1000 Yards)".tr(),
        ],
      },
      {
        'question': "What mode of transport do you use?".tr(),
        'options': [
          "Motor Bike".tr(),
          "Car".tr(),
          "Public Transport".tr(),
          "Cycle".tr(),
          "None".tr()
        ],
      },
      {
        'question': "Do you have a personal bank account?".tr(),
        'options': [
          "Yes".tr(),
          "No".tr()
        ],
      },
      {
        'question': "Do you have a credit card?".tr(),
        'options': [
          "Yes".tr(),
          "No".tr()
        ],
      },
      {
        'question': "Do you have a debit card?".tr(),
        'options': [
          "Yes".tr(),
          "No".tr()
        ],
      },
      {
        'question': "How do you pay your utility bills (electricity, gas, telephone, internet, etc.)?".tr(),
        'options': [
          "By Cash".tr(),
          "Online Banking".tr(),
          "Payment Vouchers".tr()
        ],
      },
      {
        'question': "Have you ever tried earning online?".tr(),
        'options': [
          "Yes".tr(),
          "No".tr()
        ],
      },
      {
        'question': "What is your other source of income?".tr(),
        'options': [
          "Part time Job".tr(),
          "Side Hustle".tr(),
          "Free Lancing".tr(),
          "Earning from investments".tr(),
          "None".tr(),
        ],
      },
      {
        'question': "What is your monthly/yearly savings?".tr(),
        'options': [
          "10K/100K".tr(),
          "20K/200K".tr(),
          "30K/300K".tr(),
          "40K/400K".tr(),
          "50K/500K".tr(),
          "None".tr(),
        ],
      },
      {
        'question': "How much do you spend on Kids Education/school fee? Monthly".tr(),
        'options': [
          "PKR 10,000/- to 20,000/-".tr(),
          "PKR 20,000/- to 30,000/-".tr(),
          "PKR 30,000 to 40,000/-".tr(),
          "PKR 40,000/- to 50,000/-".tr(),
          "PKR 50,000/- to 100,000/-".tr(),
          "More than PKR 100,000/-".tr()
        ],
      },
      {
        'question': "How much rent do you pay?".tr(),
        'options': [
          "Less than 20k".tr(),
          "20-50k",
          "50-100k",
          "100-500k",
          "500k & above".tr(),
          "I do not pay rent".tr(),
        ],
      },

    ];
  }


}