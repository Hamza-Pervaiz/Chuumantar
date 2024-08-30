// ignore_for_file: must_be_immutable

import 'package:chumanter/configs/imports/import_helper.dart';

class TextWidget extends StatelessWidget {
  TextWidget(
      {super.key,
      required this.text,
      this.fontSize = 14,
      this.fontWeight = FontWeight.w600,
      this.fontColor = AppColors.whiteColor,
      this.textAlign = TextAlign.center,
      this.textOverflow = TextOverflow.ellipsis,
      this.maxLines,
      this.fontFamily = AppConst.secondaryFont});
  String text;
  double fontSize;
  Color fontColor;
  FontWeight fontWeight;
  TextAlign textAlign;
  TextOverflow textOverflow;
  int? maxLines;
  String fontFamily;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines ?? 2,
      textAlign: textAlign,
      overflow: textOverflow,
      textScaleFactor: 1.0,
      style: TextStyle(
        fontSize: fontSize,
        color: fontColor,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }
}
