import 'package:dhs_app/screens/auth/login_screen.dart';
// import 'package:dhs_app/screens/auth/signup_screen.dart';
import 'package:dhs_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../widgets/custom_button.dart';
import '../others/webview_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize and play video
    _controller =
        VideoPlayerController.asset('assets/video/welcome_video.mp4')
          ..setLooping(true)
          ..setVolume(0.0)
          ..initialize().then((_) {
            setState(() {}); // Refresh UI when ready
            _controller.play(); // Play after initialized
          });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black, // fallback in case video fails
        body: Stack(
          children: [
            // 🔹 Video fills the screen
            if (_controller.value.isInitialized)
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),

            // 🔹 Overlay annotated region or content
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3), // optional dim layer
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 70),

                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(
                              () => const WebViewScreen(
                                url: "https://www.avbis.co.uk/",
                              ),
                            );
                          },
                          child: Icon(
                            Icons.help_outline,
                            color: AppColors.colorSecondary,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      Image.asset(
                        "assets/images/logo.png",
                        filterQuality: FilterQuality.high,
                      ),

                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 12.0,
                            right: 12.0,
                            bottom: 30.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Welcome to Aviation Business Information Systems',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Column(
                                children: [
                                  CustomButton(
                                    text: "Login",
                                    onPressed:
                                        () => Get.to(() => LoginScreen()),
                                    color: AppColors.buttonColor2,
                                    isLoading: false,
                                    loadingWidget: const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  // SizedBox(height: 20),
                                  // CustomButton(
                                  //   text: "New to aviation? Register here.",
                                  //   onPressed:
                                  //       () => Get.to(() => SignUpScreen()),
                                  //   color: Colors.transparent,
                                  //   isLoading: false,
                                  //   loadingWidget: SizedBox(),
                                  //   isTransparent: true,
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
