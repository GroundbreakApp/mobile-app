import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ground_break/components/components.dart';
import 'package:ground_break/constants/constants.dart';
import 'package:ground_break/l10n/app_localizations.dart';
import 'package:ground_break/models/models.dart';
import 'package:ground_break/services/services.dart';
import 'package:ground_break/utils/utils.dart';
import 'package:ground_break/views/pages.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:websafe_svg/websafe_svg.dart';

class VideoPreviewPage extends StatefulWidget {
  const VideoPreviewPage({
    Key? key,
    required this.video,
  }) : super(key: key);

  final File video;

  static Route route({required File video}) =>
      AppUIUtils.fadeTransitionBuilder(VideoPreviewPage(video: video));

  @override
  State<StatefulWidget> createState() {
    return _VideoPreviewPageState();
  }
}

class _VideoPreviewPageState extends State<VideoPreviewPage> {
  late VideoPlayerController _controller;

  final GlobalKey _globalKey = GlobalKey();

  String? _text;

  Color _selectedTextColor = AppColors.black;
  TextStyle _selectedTextStyle = AppFontStyles.k40TextStyle;
  Offset _dragPosition = Offset.zero;

  bool _showCalendar = false, _sending = false;
  String _calendlyUrl = 'https://calendly.com/josh-hava/30min';

  MediaModel? _media;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.video)
      ..setLooping(true)
      ..initialize().then((value) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _colorPicker(Color color) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _selectedTextColor = color;
        });
      },
    );
  }

  Future<void> _addText() async {
    TextEditingController editingController = TextEditingController();
    String? text = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.yellowGreen.withOpacity(0.5),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalizations.of(context)!.textSize,
                  style: AppFontStyles.k16SemiBoldTextStyle.copyWith(
                    color: AppColors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: const Icon(
                        Icons.text_fields,
                        size: 20,
                        color: AppColors.white,
                      ),
                      onTap: () {
                        setState(() {
                          _selectedTextStyle = AppFontStyles.k32TextStyle;
                        });
                      },
                    ),
                    GestureDetector(
                      child: const Icon(
                        Icons.text_fields,
                        size: 30,
                        color: AppColors.white,
                      ),
                      onTap: () {
                        setState(() {
                          _selectedTextStyle = AppFontStyles.k40TextStyle;
                        });
                      },
                    ),
                    GestureDetector(
                      child: const Icon(
                        Icons.text_fields,
                        size: 40,
                        color: AppColors.white,
                      ),
                      onTap: () {
                        setState(() {
                          _selectedTextStyle = AppFontStyles.k50TextStyle;
                        });
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    AppLocalizations.of(context)!.textColor,
                    style: AppFontStyles.k16MediumTextStyle.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _colorPicker(Colors.black),
                    _colorPicker(Colors.blue),
                    _colorPicker(Colors.red),
                    _colorPicker(Colors.yellow),
                    _colorPicker(Colors.green),
                    _colorPicker(Colors.pink),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: AppTextFormField(
                    controller: editingController,
                    hintText: AppLocalizations.of(context)!.enterYourTextHere,
                    style: AppFontStyles.k16TextStyle.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: AppRoundedRectangleButton(
                    buttonType: AppButtonType.green,
                    text: AppLocalizations.of(context)!.add,
                    onTap: () {
                      Navigator.of(context).pop(editingController.text);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (text != null) {
      setState(() {
        _text = text;
      });
    }
  }

  Future<File?> _saveImage() async {
    RenderRepaintBoundary? boundary =
        _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary != null) {
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        String filePath = await FileService.getTemporaryFilePath(
          directoryName: 'recordings',
          fileName: 'watermark.png',
        );
        return File(filePath).writeAsBytes(
          byteData.buffer.asUint8List(
            byteData.offsetInBytes,
            byteData.lengthInBytes,
          ),
        );
      }
    }
    return null;
  }

  Future<void> _sendVideo() async {
    setState(() {
      _sending = true;
    });

    if (_media == null) {
      String filePath = widget.video.path;
      if (_text != null) {
        File? file = await _saveImage();
        if (file != null && mounted) {
          Size screenSize = MediaQuery.of(context).size;
          Size imageSize = _globalKey.currentContext!.size!;
          File? watermarked = await RecordingService.addWatermark(
            video: widget.video,
            image: file,
            videoSize: Size(
              screenSize.width,
              screenSize.width / _controller.value.aspectRatio,
            ),
            imageSize: imageSize,
            offset: _dragPosition,
          );
          if (watermarked != null) {
            filePath = watermarked.path;
          }
        }
      }
      File? gif = await RecordingService.generateGif(File(filePath));
      if (gif != null) {
        await RecordingService.saveGif(gif.path);
        String newMediaId = UploadService.newMediaId;
        String? videoUrl = await UploadService.uploadFile(
          path: newMediaId,
          file: File(filePath),
          fileExtension: 'mp4',
        );
        String? gifUrl = await UploadService.uploadFile(
          path: newMediaId,
          file: gif,
          fileExtension: 'gif',
        );
        if (videoUrl != null && gifUrl != null) {
          _media = await UploadService.createMedia(MediaModel(
            url: videoUrl,
            gifUrl: gifUrl,
            calendlyUrl: _calendlyUrl,
          ));
        }
      }
    }
    if (mounted) {
      // final Uri uri = Uri(
      //   scheme: 'mailto',
      //   path: '',
      //   queryParameters: {
      //     'subject': 'Video from Groundbreak',
      //     'body': 'https://groundbreak.vercel.com/videos?id=${_media?.id}}',
      //   },
      // );
      // if (await canLaunchUrl(uri)) {
      //   await launchUrl(uri);
      // } else {
      //   if (kDebugMode) {
      //     print('Could not launch $uri');
      //   }
      // }
      await Share.share(
        '''
          I am going to share a video from Groundbreak. https://groundbreak-six.vercel.app/videos?id=${_media?.id}
        ''',
      );
    }
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MediaTemplatesPage.route(),
        (route) => route.isFirst,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.black,
      body: _controller.value.isInitialized
          ? Stack(
              fit: StackFit.expand,
              children: [
                Transform.scale(
                  scale: _controller.value.aspectRatio /
                      MediaQuery.of(context).size.aspectRatio,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
                if (_text != null)
                  Positioned(
                    left: _dragPosition.dx,
                    top: _dragPosition.dy,
                    child: Draggable(
                      onDraggableCanceled: (Velocity velocity, Offset offset) {
                        setState(() {
                          _dragPosition = Offset(
                            offset.dx,
                            offset.dy - 93,
                          );
                        });
                      },
                      childWhenDragging: RepaintBoundary(
                        key: _globalKey,
                        child: Text(
                          _text!,
                          style: _selectedTextStyle.copyWith(
                            color: AppColors.transparent,
                          ),
                        ),
                      ),
                      feedback: Material(
                        color: AppColors.transparent,
                        child: Text(
                          _text!,
                          style: _selectedTextStyle.copyWith(
                            color: _selectedTextColor,
                          ),
                        ),
                      ),
                      child: RepaintBoundary(
                        key: _globalKey,
                        child: Text(
                          _text!,
                          style: _selectedTextStyle.copyWith(
                            color: _selectedTextColor,
                          ),
                        ),
                      ),
                    ),
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
                  right: 5,
                  child: InkWell(
                    onTap: _addText,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: WebsafeSvg.asset(
                        ImageAssets.icText,
                        width: 28,
                      ),
                    ),
                  ),
                ),
                if (!_showCalendar)
                  Positioned(
                    top: 65,
                    right: 6,
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: WebsafeSvg.asset(
                          ImageAssets.icCalendar,
                          width: 24,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _showCalendar = true;
                        });
                      },
                    ),
                  )
                else
                  Positioned(
                    left: 0,
                    top: 85,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 245,
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                        decoration: BoxDecoration(
                          borderRadius: AppBorders.roundedBorder15,
                          color: AppColors.blue,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .upcomingAvailability,
                                style: AppFontStyles.k12BoldTextStyle.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            InkWell(
                              child: Container(
                                height: 34,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: AppBorders.roundedBorder5,
                                  color: AppColors.lightBlue,
                                ),
                                child: Text(
                                  '15 Minute Meeting',
                                  style:
                                      AppFontStyles.k10MediumTextStyle.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _calendlyUrl =
                                      'https://calendly.com/josh-hava/15min';
                                  _showCalendar = false;
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              child: InkWell(
                                child: Container(
                                  height: 34,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: AppBorders.roundedBorder5,
                                    color: AppColors.lightBlue,
                                  ),
                                  child: Text(
                                    '30 Minute Meeting',
                                    style: AppFontStyles.k10MediumTextStyle
                                        .copyWith(
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _calendlyUrl =
                                        'https://calendly.com/josh-hava/30min';
                                    _showCalendar = false;
                                  });
                                },
                              ),
                            ),
                            InkWell(
                              child: Container(
                                height: 34,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: AppBorders.roundedBorder5,
                                  color: AppColors.lightBlue,
                                ),
                                child: Text(
                                  '60 Minute Meeting',
                                  style:
                                      AppFontStyles.k10MediumTextStyle.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _calendlyUrl =
                                      'https://calendly.com/josh-hava/60min';
                                  _showCalendar = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  left: 45,
                  right: 45,
                  bottom: 55,
                  child: AppRoundedRectangleButton(
                    buttonType: AppButtonType.green,
                    text: AppLocalizations.of(context)!.share,
                    loading: _sending,
                    onTap: _sendVideo,
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
