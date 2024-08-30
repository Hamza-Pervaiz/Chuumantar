import 'package:chumanter/configs/imports/import_helper.dart';

class TextWidgetAboutUs extends StatelessWidget {
  TextWidgetAboutUs(
      {super.key,
        required this.text,
        this.fontSize = 14,
        this.fontWeight = FontWeight.w600,
        this.fontColor = AppColors.blackColor,
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
      maxLines: maxLines ?? 15,
      textAlign: textAlign,
      overflow: textOverflow,
      style: TextStyle(
        fontSize: fontSize,
        color: fontColor,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }
}