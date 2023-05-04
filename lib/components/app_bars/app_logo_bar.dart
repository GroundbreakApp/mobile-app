import 'package:flutter/material.dart';
import 'package:ground_break/constants/constants.dart';

class AppLogoBar extends StatelessWidget implements PreferredSizeWidget {
  const AppLogoBar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.transparent,
      leading: Container(),
      leadingWidth: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImageAssets.logoPng,
            width: 32,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Text(
              'Groundbreak',
              style: AppFontStyles.k14BoldTextStyle.copyWith(
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
