import 'dart:developer';

import 'package:chumanter/models/inappnotifications_model.dart';
import 'package:chumanter/views/auth/login_view/login_view.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../configs/imports/import_helper.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  // ------------- Winner Notification ---------------

  late VideoPlayerController _videoController;

  @override
  void initState() {
    Future<String?> getSelectedLanguage() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('language');
    }

    Future<bool> isUserLoggedIn() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('isLoggedIn') ?? false;
    }

    getPref();
    Future.delayed(const Duration(seconds: 4), () async {
      String? selectedLanguage = await getSelectedLanguage();
      bool? isloggedin = await isUserLoggedIn();
      log('selected lang is: $selectedLanguage');

      if (!mounted) return;

      if (selectedLanguage == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LanguageView(
                    whereFrom: 'splash',
                  )),
        );
      } else if (preff!.get('isReg') == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SigninPhoneView()),
        );
      }
    });
    super.initState();
    _videoController = VideoPlayerController.asset(AppConst.splashVideo)
      ..initialize().then((_) {
        setState(() {
          _videoController.play();
        });
        _videoController.setLooping(true);
      });
  }

  SharedPreferences? preff;
  getPref() async {
    preff = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    _videoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _videoController.value.size.width,
            height: _videoController.value.size.height,
            child: VideoPlayer(_videoController),
          ),
        ),
      ),
    );
  }
}
