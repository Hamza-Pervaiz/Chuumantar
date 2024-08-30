import '../configs/imports/import_helper.dart';

// ignore: must_be_immutable
class ButtonWidget extends StatefulWidget {
  ButtonWidget(
      {super.key,
      required this.onTap,
      required this.text,
      this.fontSize = 18,
      this.borderColor = AppColors.purpleColor,
      this.borderRadius = 30,
      this.color = AppColors.whiteColor,
      this.fontColor = AppColors.purpleColor,
      this.taped = false,
      this.activeOff = false,
      this.fontWeight = FontWeight.w500});
  Function onTap;
  double fontSize;
  Color borderColor;
  double borderRadius;
  Color color;
  String text;
  Color fontColor;
  FontWeight fontWeight;
  bool taped;
  bool activeOff;

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.activeOff ? null : widget.taped = !widget.taped;
        setState(() {});
        widget.onTap();
      },
      child: Center(
        child: Container(
          height: MySize.scaleFactorHeight * 50,
          width: MySize.screenWidth * 0.9,
          decoration: BoxDecoration(
              color: widget.taped ? AppColors.secondaryColor : widget.color,
              border:
                  Border.all(width: MySize.size2, color: widget.borderColor),
              borderRadius: BorderRadius.circular(widget.borderRadius)),
          child: Center(
            child: TextWidget(
              text: widget.text,
              fontSize: widget.fontSize,
              fontColor: widget.taped ? AppColors.whiteColor : widget.fontColor,
              fontWeight: widget.fontWeight,
              fontFamily: AppConst.primaryFont,
            ),
          ),
        ),
      ),
    );
  }
}
