import 'package:chumanter/configs/providers/profile_completion_status.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';

import 'configs/imports/import_helper.dart';
import 'configs/providers/calculating_profile_completion_percent_provider.dart';
import 'configs/providers/get_user_points_provider.dart';
import 'configs/providers/usersignupdetails.dart';

Future<String?> getSelectedLanguage() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('language');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyDJl73ZAzIlcLpzEWH4eGww6hSugzJUpPk',
              appId: '1:413733450168:android:b46aabcac6aa4078b35f4d',
              messagingSenderId: '413733450168',
              projectId: 'otptesting-60b99'))
      : await Firebase.initializeApp();

  await EasyLocalization.ensureInitialized();
  final selectedLanguage = await getSelectedLanguage();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: AppColors.purpleColor));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('ur', 'PK')],
        path: 'lib/views/language',
        fallbackLocale: const Locale('en', 'US'),
        useOnlyLangCode: false,
        startLocale: selectedLanguage != null ? Locale(selectedLanguage) : null,
        child: const ChumanterApp(),
      ),
    );
  });
}

class ChumanterApp extends StatelessWidget {
  const ChumanterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => LanguageBtnProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => UserProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => CalculateProfileCompletionPercent(),
          ),
          ChangeNotifierProvider(
            create: (context) => ProfileCompletionStatus(),
          ),
          ChangeNotifierProvider(
            create: (context) => GetUserPoints(),
          ),
        ],
        child: SafeArea(
          child: MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            theme: _buildTheme(),
            home: const SplashView(),
          ),
        ),
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(useMaterial3: true, primaryColor: Colors.green);
  }
}
