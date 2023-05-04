import 'package:flutter/material.dart';
import 'package:ground_break/components/app_borders.dart';
import 'package:ground_break/constants/constants.dart';
import 'package:ground_break/l10n/app_localizations.dart';
import 'package:ground_break/utils/utils.dart';
import 'package:ground_break/views/pages.dart';

class MediaTemplatesPage extends StatefulWidget {
  const MediaTemplatesPage({
    Key? key,
  }) : super(key: key);

  static Route route() =>
      AppUIUtils.fadeTransitionBuilder(const MediaTemplatesPage());

  @override
  State<StatefulWidget> createState() {
    return _MediaTemplatesPageState();
  }
}

class _MediaTemplatesPageState extends State<MediaTemplatesPage> {
  Widget _addTile() {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: AppBorders.roundedBorder10,
                border: Border.all(color: AppColors.white.withOpacity(0.5)),
              ),
              child: const Icon(
                Icons.add,
                color: AppColors.yellowGreen,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Text(
              AppLocalizations.of(context)!.addYourOwn,
              textAlign: TextAlign.center,
              style: AppFontStyles.k10BoldTextStyle.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _template3Tile() {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                Transform.rotate(
                  angle: 4.54 / 180 * 3.14,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: AppBorders.roundedBorder10,
                    ),
                    child: Image.asset(
                      ImageAssets.mediaTemplate1,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: -1.73 / 180 * 3.14,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: AppBorders.roundedBorder10,
                    ),
                    child: Image.asset(
                      ImageAssets.mediaTemplate1,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: AppBorders.roundedBorder10,
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.yellowGreen,
                        AppColors.white,
                      ],
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.prospectiveClient,
                    textAlign: TextAlign.center,
                    style: AppFontStyles.k10BoldTextStyle.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Text(
              '3 ${AppLocalizations.of(context)!.templates}',
              textAlign: TextAlign.center,
              style: AppFontStyles.k10BoldTextStyle.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _template4Tile() {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                Transform.rotate(
                  angle: -3.92 / 180 * 3.14,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: AppBorders.roundedBorder10,
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.skyBlue,
                          AppColors.white,
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: AppBorders.roundedBorder10,
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.lightGreen,
                        AppColors.white,
                      ],
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.existingClient,
                    textAlign: TextAlign.center,
                    style: AppFontStyles.k10BoldTextStyle.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Text(
              '4 ${AppLocalizations.of(context)!.templates}',
              textAlign: TextAlign.center,
              style: AppFontStyles.k10BoldTextStyle.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _templatePremiumTile() {
    return InkWell(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    Transform.rotate(
                      angle: -1.73 / 180 * 3.14,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: AppBorders.roundedBorder10,
                        ),
                        child: Opacity(
                          opacity: 0.5,
                          child: Image.asset(
                            ImageAssets.mediaTemplate1,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Transform.rotate(
                      angle: 4.54 / 180 * 3.14,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: AppBorders.roundedBorder10,
                        ),
                        child: Opacity(
                          opacity: 0.5,
                          child: Image.asset(
                            ImageAssets.mediaTemplate1,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: AppBorders.roundedBorder10,
                      ),
                      child: Image.asset(
                        ImageAssets.mediaTemplate2,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.only(top: 5, right: 8),
                      decoration: BoxDecoration(
                        borderRadius: AppBorders.roundedBorder10,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.black.withOpacity(0.59),
                            AppColors.green.withOpacity(0.59),
                          ],
                        ),
                      ),
                      child: Text(
                        '👑',
                        style: AppFontStyles.k15BoldTextStyle.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Text(
                  '${AppLocalizations.of(context)!.premium} ${AppLocalizations.of(context)!.templates}',
                  textAlign: TextAlign.center,
                  style: AppFontStyles.k10BoldTextStyle.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.templates,
                  style: AppFontStyles.k25BoldTextStyle.copyWith(
                    color: AppColors.yellowGreen,
                  ),
                ),
                InkWell(
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.yellowGreen,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      RecordingPage.route(),
                    );
                  },
                ),
              ],
            ),
            GridView.count(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 40),
              mainAxisSpacing: 24,
              crossAxisSpacing: 12,
              childAspectRatio: 95 / 180,
              crossAxisCount: 3,
              children: [
                _addTile(),
                _template3Tile(),
                _template4Tile(),
                _templatePremiumTile(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
