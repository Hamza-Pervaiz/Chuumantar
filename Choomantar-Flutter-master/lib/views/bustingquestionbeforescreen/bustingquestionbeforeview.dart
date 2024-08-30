import 'package:chumanter/configs/imports/import_helper.dart';
import 'dart:math';


class BeforeBustingPage extends StatefulWidget {
  const BeforeBustingPage({super.key});

  @override
  State<BeforeBustingPage> createState() => _BeforeBustingPageState();
}

class _BeforeBustingPageState extends State<BeforeBustingPage> {
  final _foldingCellKey = GlobalKey<AnimatedFoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MySize.screenHeight,
          width: MySize.screenWidth,
          decoration: const BoxDecoration(
            color: AppColors.blackColor,
            image: DecorationImage(
              image: AssetImage(AppConst.bgPrimary),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              logoComp(
                  width: MySize.screenWidth * 0.6,
                  height: MySize.size56),
              SizedBox(height: MySize.scaleFactorHeight*40,),
              const Text(
              'Next question is a busting question.\nGive the correct answer or you will be redirected back to MainSurvey.',
style: TextStyle(
  color: AppColors.whiteColor,
fontSize: 17,
  fontWeight: FontWeight.w600,
),
textAlign: TextAlign.center,
              ),
              SizedBox(height: MySize.scaleFactorHeight*40,),
              const Text(
                'Click the door to reveal the busting question.',
                style: TextStyle(
                  color: AppColors.secondaryColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MySize.scaleFactorHeight*100,),
              GestureDetector(
                onTap: () {
                  _foldingCellKey.currentState?.toggleFold();
                  Future.delayed(const Duration(milliseconds: 1000), () {
                    Navigator.of(context).pop(true);
                  });
                },
                child: Center(
                  child: AnimatedFold(
                    key: _foldingCellKey,
                    frontWidget: SizedBox(
                      height: MySize.scaleFactorHeight *400,
                      width:MySize.scaleFactorWidth *300,
                      child: const Image(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/wooden_door.png',),
                      ),
                    ),
                    animationDuration: const Duration(milliseconds: 1000),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class AnimatedFold extends StatefulWidget {
  const AnimatedFold(
      {
        super.key,
        required this.frontWidget,
        this.animationDuration = const Duration(milliseconds: 1000),
      });

  final Widget? frontWidget;
  final Duration? animationDuration;

  @override
  AnimatedFoldState createState() => AnimatedFoldState();
}

class AnimatedFoldState extends State<AnimatedFold> with SingleTickerProviderStateMixin {
  bool _isOpened = false;
  late AnimationController _animationController;

  void toggleFold() {
    if (_isOpened) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    _isOpened = !_isOpened;
  }

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: widget.animationDuration,);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final angle = _animationController.value * pi;

          return Transform(
            alignment: Alignment.centerLeft,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(-angle / 2.5),
            child: widget.frontWidget,
          );
        });
  }
}
