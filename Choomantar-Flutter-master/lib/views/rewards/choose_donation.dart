import 'package:chumanter/configs/imports/import_helper.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'custom_payment_container.dart';


class ChooseDonation extends StatefulWidget {
  final Function(String) onYesPressed;
  const ChooseDonation({super.key, required this.onYesPressed});

  @override
  State<ChooseDonation> createState() => _ChooseDonationState();
}

class _ChooseDonationState extends State<ChooseDonation> {
  String? selectedPaymentType;
  // PageController pageController = PageController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFuncs.showToast("choose_donation\nChooseDonation");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: MySize.size10),
          Text(
            'Donate To'.tr(),
            style: TextStyle(
              fontFamily: AppConst.primaryFont,
              fontWeight: FontWeight.w900,
              color: AppColors.secondaryColor,
              fontSize: MySize.size22,
            ),
          ),
          GestureDetector(
            onTap: (){
              selectedPaymentType ='Shaukat Khanum';
              widget.onYesPressed(selectedPaymentType!);},
            child:  ReusablePaymentContainer(
              text: 'Shaukat Khanum'.tr(),
              image: 'assets/images/shaukatkhanum.png',
            ),
          ),
          GestureDetector(
            onTap: (){
              selectedPaymentType ='Al Khidmat';
              widget.onYesPressed(selectedPaymentType! );
            },
            child: ReusablePaymentContainer(
              text: 'Al Khidmat'.tr(),
              image: 'assets/images/alkhidmat.jpg',
            ),
          ),
          GestureDetector(
            onTap: (){
              selectedPaymentType ='Edhi Foundation';
              widget.onYesPressed(selectedPaymentType! );
            },
            child: ReusablePaymentContainer(
              text: 'Edhi Foundation'.tr(),
              image: 'assets/images/edhifoundation.jpg',
            ),
          ),

          GestureDetector(
            onTap: (){
              selectedPaymentType ='Akhuwat';
              widget.onYesPressed(selectedPaymentType! );
            },
            child: ReusablePaymentContainer(
              text: 'Akhuwat'.tr(),
              image: 'assets/images/akhuwat.jpg',
            ),
          ),

          GestureDetector(
            onTap: (){
              selectedPaymentType ='The Citizens';
              widget.onYesPressed(selectedPaymentType! );
            },
            child: ReusablePaymentContainer(
              text: 'The Citizens'.tr(),
              image: 'assets/images/thecitizens.png',
            ),
          ),
        ],
      ),
    );
  }
}

