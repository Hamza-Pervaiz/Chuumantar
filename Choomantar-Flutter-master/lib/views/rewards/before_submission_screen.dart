import '../../configs/imports/import_helper.dart';

class BeforeSubmissionScreen extends StatefulWidget {
  String? pointstoRedeem;
  String? amounttoRedeem;
  String? choosenType;
  final VoidCallback onOkPressed;


  BeforeSubmissionScreen({super.key, this.amounttoRedeem, this.pointstoRedeem, this.choosenType, required this.onOkPressed});

  @override
  State<BeforeSubmissionScreen> createState() => _BeforeSubmissionScreenState();
}

class _BeforeSubmissionScreenState extends State<BeforeSubmissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: confirmation(),
        ),
      ],
    );
  }



  Widget confirmation() => Container(
    padding: EdgeInsets.all(MySize.size20),
    decoration: BoxDecoration(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(MySize.size16),
      image: const DecorationImage(
        image: AssetImage(AppConst.orgeyeBg),
        fit: BoxFit.scaleDown,
        scale: 1.5,
      ),

      boxShadow: const [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0.0, 1.0), //(x,y)
          blurRadius: 8.0,
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget(
          text: 'Confirmation!',
          textAlign: TextAlign.center,
          maxLines: 2,
          fontSize: MySize.size22,
          fontFamily: AppConst.primaryFont,
          fontColor: AppColors.redColor,
        ),
        SizedBox(height: MySize.size15),

        Image.asset('assets/images/rpoints.png', width: 60, height: 60,),

        SizedBox(height: MySize.size22),


        Text(
          widget.choosenType == 'cashdisbursement' ? 'You will get a cash reward of amount ${widget.amounttoRedeem} PKR in exchange of your ${widget.pointstoRedeem} points.'
          : 'You are going to donate ${widget.amounttoRedeem} PKR in exchange of your ${widget.pointstoRedeem} points',
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppConst.primaryFont,
            color: AppColors.purpleColor,
            fontSize: MySize.size18,
            fontWeight: FontWeight.w600,
          ),
        ),
        //


        SizedBox(height: MySize.size18),

        ElevatedButton(
          onPressed: () {
            widget.onOkPressed();
          //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SelectCategories()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.black,
            elevation: 7,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MySize.size8),
            ),
          ),
          child: const Text('Ok',style: TextStyle( fontFamily: AppConst.primaryFont,
              fontWeight: FontWeight.w600,color: AppColors.whiteColor),),
        ),

      ],
    ),
  );
}
