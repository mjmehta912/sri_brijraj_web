import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:sri_brijraj_web/constants/color_constants.dart';
import 'package:sri_brijraj_web/constants/image_constants.dart';
import 'package:sri_brijraj_web/features/login/screens/login_screen.dart';
import 'package:sri_brijraj_web/features/web_nav/screens/web_nav_screen.dart';
import 'package:sri_brijraj_web/widgets/app_size_extensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    String? fullName = await _secureStorage.read(key: 'fullName');

    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (fullName != null && fullName.isNotEmpty) {
          Get.offAll(
            () => WebNavScreen(),
          );
        } else {
          Get.offAll(
            () => LoginScreen(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorwhite,
      body: Center(
        child: Image.asset(
          kIconBrijraj,
          height: 0.3.screenHeight,
          width: 0.4.screenWidth,
        ),
      ),
    );
  }
}
