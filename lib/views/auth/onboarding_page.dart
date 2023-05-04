import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ground_break/components/components.dart';
import 'package:ground_break/constants/constants.dart';
import 'package:ground_break/l10n/app_localizations.dart';
import 'package:ground_break/utils/utils.dart';
import 'package:ground_break/views/pages.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  static Route route() =>
      AppUIUtils.fadeTransitionBuilder(const OnboardingPage());

  @override
  State<StatefulWidget> createState() {
    return _OnboardingPageState();
  }
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    ScreenRatio.setScreenRatio(MediaQuery.of(context));

    return Container(
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
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        appBar: const AppLogoBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    left: 56 * ScreenRatio.widthRatio,
                    top: 53 * ScreenRatio.heightRatio,
                    child: Image.asset(
                      ImageAssets.imageTemplate1Png,
                      fit: BoxFit.contain,
                      width: 140 * ScreenRatio.widthRatio,
                      height: 149 * ScreenRatio.heightRatio,
                    ),
                  ),
                  Positioned(
                    top: 25 * ScreenRatio.heightRatio,
                    right: 68 * ScreenRatio.widthRatio,
                    child: Image.asset(
                      ImageAssets.imageTemplate2Png,
                      fit: BoxFit.contain,
                      width: 114 * ScreenRatio.widthRatio,
                      height: 124 * ScreenRatio.heightRatio,
                    ),
                  ),
                  Positioned(
                    left: -29 * ScreenRatio.widthRatio,
                    bottom: 36 * ScreenRatio.heightRatio,
                    child: Image.asset(
                      ImageAssets.imageTemplate3Png,
                      fit: BoxFit.contain,
                      width: 210 * ScreenRatio.widthRatio,
                      height: 209 * ScreenRatio.heightRatio,
                    ),
                  ),
                  Positioned(
                    right: -61 * ScreenRatio.widthRatio,
                    bottom: 34 * ScreenRatio.heightRatio,
                    child: Image.asset(
                      ImageAssets.imageTemplate4Png,
                      fit: BoxFit.contain,
                      width: 272 * ScreenRatio.widthRatio,
                      height: 293 * ScreenRatio.heightRatio,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Text(
                AppLocalizations.of(context)!.startSelling,
                style: AppFontStyles.k50BoldTextStyle.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 24, 36, 36),
              child: Text(
                AppLocalizations.of(context)!.startSellingDescription,
                style: AppFontStyles.k16TextStyle.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: AppRoundedRectangleButton(
                text: AppLocalizations.of(context)!.joinNow,
                onTap: () {
                  Navigator.of(context).push(
                    SignUpPage.route(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 24, 36, 36),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.haveAnAccount,
                      style: AppFontStyles.k14TextStyle.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!.login,
                      style: AppFontStyles.k14BoldTextStyle.copyWith(
                        color: AppColors.black,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(
                            SignInPage.route(),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
