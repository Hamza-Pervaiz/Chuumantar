import 'package:easy_localization/easy_localization.dart';

class QuizDataEntertainment {
  static List<Map<String, dynamic>> getEntertainmentQuestions() {
    return [
      {
        'question': "What type of dramas do you watch?".tr(),
        'options': [
          "Romantic".tr(),
          "Fiction".tr(),
          "Suspense".tr(),
          "Horror".tr(),
          "Comedy".tr(),
          "Others".tr(),
        ],
      },
      {
        'question': "What type of music do you listen to?".tr(),
        'options': [
          "Classical/Ghazal".tr(),
          "Pop/Rock".tr(),
          "Country".tr(),
          "Filmy".tr(),
          "Religious".tr(),
          "I have no interest in music".tr(),
        ],
      },
      {
        'question': "What types of movies do you watch?".tr(),
        'options': [
          "Action".tr(),
          "Comedy".tr(),
          "Drama".tr(),
          "Documentaries".tr(),
          "Thriller/Horror".tr(),
          "Fantasy and romance".tr(),
          "Science fiction".tr(),
          "All of the above".tr(),
          "I have no interest in movies".tr(),
        ],
      },
      {
        'question': "How often do you watch movies?".tr(),
        'options': [
          "Once in a while".tr(),
          "Regularly".tr(),
          "I don't watch movies".tr()
        ],
      },
      {
        'question': "When did you last watch a movie in a cinema?".tr(),
        'options': [
          "Recently".tr(),
          "One month ago".tr(),
          "3 months ago".tr(),
          "6 months ago".tr(),
          "More than one year ago".tr(),
          "I have never been to cinema".tr(),
        ],
      },
      {
        'question': "What is your primary source of music?".tr(),
        'options': [
          "Radio".tr(),
          "CD's".tr(),
          "Online apps(Spotify etc)".tr(),
          "Internet(YouTube etc)".tr(),
          "Downloaded Music(USB etc)".tr(),
        ],
      },
      {
        'question': "What do you mostly do in your free time?".tr(),
        'options': [
          "Watch TV/Movies".tr(),
          "Talk to a friend".tr(),
          "Social Media".tr(),
          "Book Reading".tr(),
          "Exercise (Walk etc.)".tr(),
          "Listen to Music".tr(),
        ],
      },
      {
        'question': "Do you watch current affairs programs?".tr(),
        'options': [
          "Yes Regularly".tr(),
          "Occasionally".tr(),
          "Not at all".tr()
        ],
      },
      {
        'question': "What is your favorite news Channel?".tr(),
        'options': [
          "ARY".tr(),
          "Dunya".tr(),
          "SAMAA".tr(),
          "GEO".tr(),
          "BOL".tr(),
          "Others".tr()
        ],
      },
      {
        'question': "What is your favorite Drama Channel?".tr(),
        'options': [
          "ARY Digital",
          "Hum",
          "GEO Kahani",
          "A plus",
          "PTV World"
        ],
      },
      {
        'question': "How much time do you spend watching TV?".tr(),
        'options': [
          "2 Hours".tr(),
          "4 Hours".tr(),
          "6 Hours".tr(),
          "8 Hours".tr(),
          "8 Hours +".tr(),
          "None".tr()],
      },
      {
        'question': "Average time spent on social media?".tr(),
        'options': [
          "1-2 Hours".tr(),
          "3-4 Hours".tr(),
          "5-6 Hours".tr(),
          "7-8 Hours".tr(),
          "8 Hours and more".tr(),
        ],
      },
      {
        'question': "What's your interest in social media?".tr(),
        'options': [
          "Education/Learning".tr(),
          "News/Current Affairs".tr(),
          "Dramas/Entertainment".tr(),
          "Religion".tr(),
          "Food".tr(),
          "Sports".tr()
        ],
      },
      {
        'question': "Favourite Social Media Platforms".tr(),
        'options': [
          "Facebook".tr(),
          "TikTok".tr(),
          "Instagram".tr(),
          "Twitter".tr(),
          "LinkedIn".tr()
        ],
      },
      {
        'question': "How do you entertain yourself?".tr(),
        'options': [
          "Watching TV".tr(),
          "Reading Books".tr(),
          "Watching Movies".tr(),
          "Listening to Music".tr(),
          "Social Media".tr(),
          "Going Outdoors".tr(),
        ],
      },

    ];
  }

}