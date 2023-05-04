import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ground_break/constants/constants.dart';
import 'package:ground_break/utils/utils.dart';
import 'package:ground_break/views/pages.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (FirebaseAuth.instance.currentUser != null) {
          Navigator.of(context).push(
            RecordingPage.route(),
          );
        } else {
          Navigator.of(context).push(
            OnboardingPage.route(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenRatio.setScreenRatio(MediaQuery.of(context));

    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.yellowGreen,
            AppColors.lightYellow,
          ],
        ),
      ),
      child: Text(
        'Groundbreak',
        style: AppFontStyles.k50BoldTextStyle.copyWith(
          color: AppColors.black,
        ),
      ),
    );
  }
}
