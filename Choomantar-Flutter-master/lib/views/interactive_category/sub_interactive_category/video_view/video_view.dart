import 'package:chewie/chewie.dart';
import 'package:chumanter/res/utils/CommonFuncs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import '../../../../configs/imports/import_helper.dart';
import '../../../../configs/providers/get_user_points_provider.dart';
import '../../../../configs/providers/usersignupdetails.dart';
import 'package:keep_screen_on/keep_screen_on.dart';



class VideoView extends StatefulWidget {
  String? videoLastUrl;
  VideoView({super.key, required this.videoLastUrl});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  bool watchVideo = false;
  final double _aspectRatio = 1 / 1;
  bool finsihedVideo= false;
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  late CustomVideoPlayerController _customVideoPlayerController;
  ProgressDialog? progressDialog;
  bool fullOnce = true;



  PageController? pageController;
  String imagePath='';
  Future<void> _loadUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePath = prefs.getString('user_image')!;
    });
  }
  @override
  void initState() {
    _loadUserImage();
    String videoURl = "${AppUrls.videoUrl}uploads/${widget.videoLastUrl}";

    if (kDebugMode) {
      print('video url is: $videoURl');
    }

    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.portraitUp
    // ]);

    KeepScreenOn.turnOn();

    super.initState();


    initProgressDialog();


    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoURl))
      ..initialize().then((_) {
        setState(() {});
      });


    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: CustomVideoPlayerSettings(
        systemUIModeInsideFullscreen: SystemUiMode.immersiveSticky,
        exitFullscreenOnEnd: true,
        placeholderWidget: Center(
          child: Container(
            width: 50,
              height: 50,
              child: const CircularProgressIndicator(strokeWidth: 4.0,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.urduBtn),
              )),
        ),

     )
    );


 //   checkvideoEnded();

    // _chewieController = ChewieController(
    //   allowedScreenSleep: false,
    //   allowFullScreen: true,
    //   deviceOrientationsAfterFullScreen: [
    //     DeviceOrientation.landscapeRight,
    //     DeviceOrientation.landscapeLeft,
    //     DeviceOrientation.portraitUp,
    //     DeviceOrientation.portraitDown,
    //   ],
    //   videoPlayerController: _videoPlayerController,
    //   aspectRatio: _aspectRatio,
    //   autoInitialize: true,
    //   autoPlay: true,
    //   looping: false,
    //   showControls: true,
    // );
    //
    // _chewieController.enterFullScreen();
    // _chewieController.toggleFullScreen();
    //
    // _chewieController.addListener(() {
    //   if (_chewieController.isFullScreen) {
    //     SystemChrome.setPreferredOrientations([
    //       DeviceOrientation.landscapeRight,
    //       DeviceOrientation.landscapeLeft,
    //     ]);
    //   } else {
    //     SystemChrome.setPreferredOrientations([
    //       DeviceOrientation.portraitUp,
    //       DeviceOrientation.portraitDown,
    //     ]);
    //   }
    // });

    // _chewieController = ChewieController(
    //   videoPlayerController: _videoPlayerController,
    //   autoPlay: true,
    //   looping: false,
    // );



    CommonFuncs.showToast("video_view\nVideoView");


  }

  void setLandscapeOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }



  void initProgressDialog(){
    progressDialog = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: false);
    progressDialog!.style(
      textAlign: TextAlign.center,
      message: 'Please wait...'.tr(),
      elevation: 10,
      padding: const EdgeInsets.symmetric(vertical: 10),
      messageTextStyle: const TextStyle(
        color: AppColors.purpleColor,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void checkvideoEnded() async
  {
    // print('Playback position: ${_videoPlayerController.value.position}');
    // print('Video duration: ${_videoPlayerController.value.duration}');

    _videoPlayerController.addListener(() {

      if (_videoPlayerController.value.hasError) {
        // Handle video loading error
        Fluttertoast.showToast(msg: 'Error playing video');
        _customVideoPlayerController.setFullscreen(false).then((value) async {
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pop(context, "noopen");
        });

        if (kDebugMode) {
          print('Error loading video: ${_videoPlayerController.value.errorDescription}');
        }

      }

      if(_videoPlayerController.value.isInitialized && _videoPlayerController.value.isPlaying)
        {
          if(fullOnce)
            {
              setState(() {
                fullOnce = false;
                _customVideoPlayerController.setFullscreen(true);
              });
            }
        }

      if(_videoPlayerController.value.isCompleted)
      {
      //  _customVideoPlayerController.setFullscreen(false);
        setState(() {
          finsihedVideo= true;
        });
      }

    });

//     _videoPlayerController.addListener(() {
//       if(_videoPlayerController.value.position >= _videoPlayerController.value.duration)
//       {
//         setState(() {
// finsihedVideo= true;
//         });
//       }
//
//     });
  }
  @override
  void dispose() {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _videoPlayerController.removeListener(() {});
    _videoPlayerController.dispose();
    _customVideoPlayerController.dispose();
    KeepScreenOn.turnOff();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return WillPopScope(
          onWillPop: () async {
            if (pageController?.page == 0) {
              if (kDebugMode) {
                print("videoview: willpop if");
              }
              return true;
            } else {
              if (kDebugMode) {
                print("videoview: willpop else");
              }
              Navigator.pop(context, "noopen");
              // pageController.previousPage(
              //   duration: const Duration(milliseconds: 300),
              //   curve: Curves.easeOut,
              // );
              return false;
            }
          },
          child: Scaffold(
            body: Container(
              height: MySize.screenHeight,
              width: MySize.screenWidth,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppConst.bgPrimary),
                  fit: BoxFit.fill,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(MySize.size16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: MySize.size20,
                              backgroundImage: imagePath != null && imagePath!.isNotEmpty
                                  ? NetworkImage(imagePath!) as ImageProvider
                                  : const AssetImage(AppConst.hi4), // Default image
                            ),
                            SizedBox(
                              width: MySize.scaleFactorWidth * 10,
                            ),
                            Consumer<UserProvider>(
                                builder: (context, userProvider, child) {
                                  String userName = userProvider.userName ?? "";
                                  return TextWidget(
                                    text: userName,
                                    fontWeight: FontWeight.w800,
                                    fontColor: AppColors.whiteColor,
                                  );
                                }),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              AppConst.c1,
                              height: MySize.size20,
                              width: MySize.size20,
                            ),
                            SizedBox(
                              width: MySize.scaleFactorHeight * 10,
                            ),
                            Consumer<UserProvider>(
                                builder: (context, userProvider, child) {
                                  final getUserPointsProvider =
                                  Provider.of<GetUserPoints>(context,
                                      listen: false);
                                  final points = getUserPointsProvider.points;

                                  return TextWidget(
                                    text: points.toString(),
                                    fontColor: Colors.deepOrangeAccent,
                                  );
                                }),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: MySize.scaleFactorHeight * 20,
                    ),
                    watchVideo ?
                       Container(
                      height: MySize.screenHeight * 0.3,
                      width: MySize.screenWidth,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(MySize.size12),
                        border: Border.all(
                          width: MySize.size2,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(MySize.size12),
                        child: CustomVideoPlayer(
                          customVideoPlayerController: _customVideoPlayerController,
                        ),
                        // child: Chewie(
                        //   controller: _chewieController,
                        // ),
                      ),
                    )
                        : Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget(
                            text:
                            "Watch the video carefully before taking the survey.".tr(),
                            maxLines: 2,
                            fontSize: MySize.size16,
                            fontWeight: FontWeight.w700,
                          ),
                          SizedBox(
                            height: MySize.scaleFactorHeight * 20,
                          ),
                          ButtonWidget(
                            onTap: () {
                              setState(() {
                                watchVideo = !watchVideo;
                                progressDialog?.show();

                                  if (watchVideo) {

                                    Future.delayed(const Duration(seconds: 4), () {
                                      progressDialog?.hide();
                                     // _customVideoPlayerController.setFullscreen(true);
                                      _customVideoPlayerController.videoPlayerController.play();
                                    //  setLandscapeOrientation();
                                    //  _videoPlayerController.play();
                                      checkvideoEnded();
                                    });

                                    //  checkvideoEnded();

                                  }


                              });
                            },
                            text: "Watch Video".tr(),
                          ),
                        ],
                      ),
                    ),
                    watchVideo
                        ? const Spacer()
                        : SizedBox(
                      height: MySize.scaleFactorHeight * 20,
                    ),


                    finsihedVideo ?
                        ButtonWidget(
                            onTap: (){
                              Navigator.of(context).pop("opensur");
                            },
                            text: 'Ready to take survey') : Container()
                    // finsihedVideo
                    //     ? ButtonWidget(
                    //   onTap: () {
                    //     watchVideo
                    //         ? Navigator.of(context).pop("opensur")
                    //         : null;
                    //     watchVideo
                    //         ? _videoPlayerController.dispose()
                    //         : null;
                    //     setState(() {
                    //       watchVideo = !watchVideo;
                    //     });
                    //   },
                    //   text: watchVideo
                    //       ? "Ready to take survey".tr()
                    //       : "Watch Video First".tr(),
                    // )
                    //     : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        );
  }
}



