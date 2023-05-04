import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ground_break/components/components.dart';
import 'package:ground_break/constants/constants.dart';
import 'package:ground_break/l10n/app_localizations.dart';
import 'package:ground_break/views/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parrot Ground Break',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
      ],
      theme: ThemeData(
        fontFamily: 'Montserrat',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: AppColors.yellowGreen,
          iconTheme: IconThemeData(
            color: AppColors.black,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: AppFontStyles.k16TextStyle.copyWith(
            color: AppColors.white.withOpacity(0.75),
          ),
          labelStyle: AppFontStyles.k16TextStyle.copyWith(
            color: AppColors.white.withOpacity(0.75),
          ),
          errorStyle: AppFontStyles.k16TextStyle.copyWith(
            color: AppColors.red,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.white.withOpacity(0.5),
            ),
            borderRadius: AppBorders.roundedBorder5,
          ),
        ),
      ),
      home: const OnboardingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
