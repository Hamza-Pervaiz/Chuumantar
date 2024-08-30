import 'package:chumanter/configs/imports/import_helper.dart';

class AppColors {
  /// Gradient
  static const LinearGradient primaryGradient = LinearGradient(colors: [
    Color(0xCDFFFFFF),
    Color(0xFF58ABD1),
    Color(0xFF001790),
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);

  static const LinearGradient tapedGradient = LinearGradient(colors: [
    AppColors.secondaryColor,
    Color(0xFF58ABD1),
    Color(0xFF001790),
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);

  static const LinearGradient homeGradient = LinearGradient(colors: [
    Color(0xCDFFFFFF),
    Color(0xFF58ABD1),
    Color(0xFF001790),
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);

  ///Colors
  static const Color primaryColor = Colors.green;
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF000000);
  static const Color purpleColor = Color(0XFF053B8A);
  static const Color purple500 = Color(0X8B053B8A);
  static const Color purple200 = Color(0XFFBB86FC);
  static const Color lightBgColor = Color(0XFF053B8A);
  static const Color secondaryColor = Color(0xff32d18f);
  static const Color redColor = Color(0xFFFF0000);
  static const Color urduBtn = Color(0xffEF6926);
  static const Color lightGreen = Color(0xFF355D57);
  static const Color greyColor = Colors.grey;
  static const Color blueColor = Color(0xFF053B8A);
}

/*
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="purple_200">#FFBB86FC</color>
    <color name="purple_500">#053B8A</color>
    <color name="purple_700">#011741</color>
    <color name="teal_200">#FF03DAC5</color>
    <color name="teal_700">#FF018786</color>
    <color name="black">#FF000000</color>
    <color name="white">#FFFFFFFF</color>
    //button color
    englishBtn
    <color name="englishBtn">#32D18F</color>
    <color name="urduBtn">#EF6926</color>
    <color name="hintColor">#C6C6C5</color>
    <color name="dividerColor">#BCBCBC</color>
    <color name="blueColor">#053B8A</color>
    <color name="orangelogo">#f36d3d</color>
    <color name="textcolormain">#042C55</color>

    <color name="lightgreen">#9DD8BF</color>

    <color name="surveyOptionBorder">#053B8A</color>

    <color name="blackTransparent">#7A000000</color>

    <color name="whiteTransparent">#66FFFFFF</color>
    <color name="Transparent">#00FFFFFF</color>

    <color name="home2whiteTransparent">#83FFFFFF</color>

    <color name="segmentProgrssColor">#7A32D18F</color>
    <color name="cardBackground">#46FFFFFF</color>

    <color name="invisibleBackground">#B01E5CB7</color>
    <color name="lockBackground">#8B053B8A</color>

    <color name="selectedColor">#053B8A</color>
    <color name="unselectedColor">#80A9E5</color>

    <color name="dateTextColor">#A5A4A4</color>










</resources>
*/
