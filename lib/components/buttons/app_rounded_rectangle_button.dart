import 'package:flutter/material.dart';
import 'package:ground_break/constants/constants.dart';

enum AppButtonType {
  black,
  green,
}

class AppRoundedRectangleButton extends StatelessWidget {
  const AppRoundedRectangleButton({
    Key? key,
    required this.text,
    this.buttonType = AppButtonType.black,
    this.loading = false,
    this.onTap,
  }) : super(key: key);

  final String text;
  final AppButtonType buttonType;
  final bool loading;
  final Function()? onTap;

  Color get _innerColor {
    switch (buttonType) {
      case AppButtonType.black:
        return AppColors.yellowGreen;
      case AppButtonType.green:
        return AppColors.black;
    }
  }

  Color get _backgroundColor {
    switch (buttonType) {
      case AppButtonType.black:
        return AppColors.black;
      case AppButtonType.green:
        return AppColors.yellowGreen;
    }
  }

  TextStyle get _textStyle {
    switch (buttonType) {
      case AppButtonType.black:
        return AppFontStyles.k14BoldTextStyle.copyWith(
          color: AppColors.white,
        );
      case AppButtonType.green:
        return AppFontStyles.k18SemiBoldTextStyle.copyWith(
          color: AppColors.black,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !loading ? onTap : null,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(2),
        ),
        child: !loading
            ? Text(
                text,
                style: _textStyle,
              )
            : CircularProgressIndicator(
                color: _innerColor,
              ),
      ),
    );
  }
}
