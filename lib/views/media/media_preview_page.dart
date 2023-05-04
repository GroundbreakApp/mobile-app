import 'package:flutter/material.dart';
import 'package:ground_break/constants/constants.dart';
import 'package:ground_break/models/models.dart';
import 'package:ground_break/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:websafe_svg/websafe_svg.dart';

class MediaPreviewPage extends StatefulWidget {
  const MediaPreviewPage({
    Key? key,
    required this.media,
  }) : super(key: key);

  final MediaModel media;

  static Route route({required MediaModel media}) =>
      AppUIUtils.fadeTransitionBuilder(MediaPreviewPage(media: media));

  @override
  State<StatefulWidget> createState() {
    return _MediaPreviewPageState();
  }
}

class _MediaPreviewPageState extends State<MediaPreviewPage> {
  late final VideoPlayerController _controller =
      VideoPlayerController.network(widget.media.url)..setLooping(true);

  @override
  void initState() {
    super.initState();
    _controller.initialize().then((value) {
      setState(() {});
      _controller.play();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? Stack(
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  Positioned(
                    left: 10,
                    top: 20,
                    child: InkWell(
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: AppColors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Positioned(
                    top: 25,
                    right: 6,
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: WebsafeSvg.asset(
                          ImageAssets.icCalendar,
                          width: 24,
                        ),
                      ),
                      onTap: () async {
                        Uri uri = Uri.parse(widget.media.calendlyUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                    ),
                  )
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
