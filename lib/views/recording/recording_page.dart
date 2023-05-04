// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ground_break/constants/constants.dart';
import 'package:ground_break/l10n/app_localizations.dart';
import 'package:ground_break/services/services.dart';
import 'package:ground_break/utils/utils.dart';
import 'package:ground_break/views/pages.dart';
import 'package:intl/intl.dart';
import 'package:websafe_svg/websafe_svg.dart';

class RecordingPage extends StatefulWidget {
  const RecordingPage({Key? key}) : super(key: key);

  static Route route() =>
      AppUIUtils.fadeTransitionBuilder(const RecordingPage());

  @override
  State<StatefulWidget> createState() {
    return _RecordingPageState();
  }
}

class _RecordingPageState extends State<RecordingPage> {
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  String? _error;

  Duration _recordingMaxDuration = Duration(seconds: recordingLengths[1]);
  FlashMode _flashMode = FlashMode.off;
  bool _isRearCamera = true;
  bool _isRecording = false;
  bool _processing = false;

  final List<XFile> _recordings = [];

  Timer? _timer;

  final Duration _interval = const Duration(milliseconds: 100);
  final ValueNotifier<Duration> _recordingDurationListener =
      ValueNotifier(Duration.zero);

  @override
  void initState() {
    super.initState();

    _initiateCamera();
    // CalendlyService.fetchCalendlyEventTypes();
  }

  void _onTimer(Timer _) {
    _recordingDurationListener.value =
        _recordingDurationListener.value + _interval;
    if (_recordingDurationListener.value + _interval * 2 >=
        _recordingMaxDuration) {
      _stopRecording();
    }
  }

  Future<void> _initiateCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        CameraController controller = CameraController(
          _cameras
              .firstWhere((c) => c.lensDirection == CameraLensDirection.back),
          ResolutionPreset.max,
        );
        await controller.initialize();
        setState(() {
          _cameraController = controller;
        });
      } else {
        setState(() {
          _error = 'No Camera Available';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _toggleCamera() async {
    if (_cameras.isNotEmpty) {
      CameraController controller = CameraController(
        _isRearCamera
            ? _cameras
                .firstWhere((c) => c.lensDirection == CameraLensDirection.front)
            : _cameras
                .firstWhere((c) => c.lensDirection == CameraLensDirection.back),
        ResolutionPreset.max,
      );
      await controller.initialize();
      setState(() {
        _cameraController = controller;
        _isRearCamera = !_isRearCamera;
      });
    }
  }

  Future<void> _toggleFlash() async {
    int index = FlashMode.values.indexOf(_flashMode);
    index = index == FlashMode.values.length - 1 ? 0 : index + 1;
    await _cameraController?.setFlashMode(FlashMode.values[index]);
    setState(() {
      _flashMode = FlashMode.values[index];
    });
  }

  Future<void> _startRecording() async {
    if (_cameraController != null && !_isRecording) {
      setState(() {
        _isRecording = true;
      });
      _cameraController!.startVideoRecording();
      _timer = Timer.periodic(_interval, _onTimer);
    }
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    if (_cameraController != null && _isRecording) {
      setState(() {
        _isRecording = false;
      });
      XFile file = await _cameraController!.stopVideoRecording();
      setState(() {
        _recordings.add(file);
      });
    }
  }

  Future<void> _navigateNextStep() async {
    try {
      setState(() {
        _processing = true;
      });
      File? merged = await RecordingService.mergeVideos(
        _recordings.map((e) => File(e.path)).toList(),
      );
      if (merged != null && mounted) {
        _cameraController = null;
        Navigator.of(context).push(
          VideoPreviewPage.route(video: merged),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    if (mounted) {
      setState(() {
        _processing = false;
      });
    }
  }

  Widget _recordButton() {
    return GestureDetector(
      child: _recordings.isEmpty && !_isRecording
          ? Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.yellowGreen,
                  width: 6,
                ),
              ),
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
              ),
            )
          : Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withOpacity(0.5),
                  ),
                  child: Container(
                    width: 23,
                    height: 23,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.yellowGreen,
                    ),
                    value: _recordingDurationListener.value.inMilliseconds
                            .toDouble() /
                        _recordingMaxDuration.inMilliseconds.toDouble(),
                  ),
                ),
              ],
            ),
      // onTap: () {
      //   if (_isRecording) {
      //     _stopRecording();
      //   } else {
      //     _startRecording();
      //   }
      // },
      onLongPressStart: (details) {
        _startRecording();
      },
      onLongPressEnd: (details) {
        _stopRecording();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Builder(
        builder: (context) {
          if (_error != null) {
            return Center(
              child: Text(
                _error!,
                style: AppFontStyles.k14TextStyle.copyWith(
                  color: AppColors.black,
                ),
              ),
            );
          } else if (_cameraController == null && _recordings.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Stack(
              fit: StackFit.expand,
              children: [
                if (_cameraController != null)
                  Transform.scale(
                    scale: 1 /
                        (_cameraController!.value.aspectRatio *
                            MediaQuery.of(context).size.aspectRatio),
                    alignment: Alignment.center,
                    child: Center(
                      child: CameraPreview(
                        _cameraController!,
                      ),
                    ),
                  )
                else
                  Container(),
                Positioned(
                  left: 40,
                  right: 40,
                  bottom: 105,
                  child: AnimatedBuilder(
                    animation: _recordingDurationListener,
                    builder: (context, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_recordingDurationListener.value.inSeconds > 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Text(
                                '${NumberFormat('00').format(_recordingDurationListener.value.inSeconds ~/ 60)}:${NumberFormat('00').format(_recordingDurationListener.value.inSeconds % 60)}',
                                textAlign: TextAlign.center,
                                style: AppFontStyles.k15BoldTextStyle.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              if (_recordings.isNotEmpty)
                                InkWell(
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.white,
                                    ),
                                    child: const Icon(
                                      Icons.close_rounded,
                                      size: 24,
                                      color: AppColors.gray,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _recordings.clear();
                                      _recordingDurationListener.value =
                                          Duration.zero;
                                    });
                                  },
                                ),
                              _recordButton(),
                              if (_recordings.isNotEmpty)
                                InkWell(
                                  onTap:
                                      !_processing ? _navigateNextStep : null,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.yellowGreen,
                                    ),
                                    child: !_processing
                                        ? const Icon(
                                            Icons.check_rounded,
                                            size: 24,
                                            color: AppColors.gray,
                                          )
                                        : const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              color: AppColors.gray,
                                            ),
                                          ),
                                  ),
                                )
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                if (_recordings.isEmpty && !_isRecording)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 55),
                        ...recordingLengths
                            .map(
                              (length) => InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 6,
                                        ),
                                        child: Text(
                                          '${length}s',
                                          style: AppFontStyles.k15BoldTextStyle
                                              .copyWith(
                                            color: AppColors.white.withOpacity(
                                              length ==
                                                      _recordingMaxDuration
                                                          .inSeconds
                                                  ? 1
                                                  : 0.6,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 5,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.white.withOpacity(
                                            length ==
                                                    _recordingMaxDuration
                                                        .inSeconds
                                                ? 1
                                                : 0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _recordingMaxDuration =
                                        Duration(seconds: length);
                                  });
                                },
                              ),
                            )
                            .toList(),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.templates,
                              style: AppFontStyles.k15BoldTextStyle.copyWith(
                                color: AppColors.white.withOpacity(0.6),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MediaTemplatesPage.route(),
                              (route) => route.isFirst,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                Positioned(
                  top: 25,
                  right: 5,
                  child: InkWell(
                    onTap: _toggleCamera,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          WebsafeSvg.asset(
                            ImageAssets.icFlip,
                            width: 27,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: Text(
                              AppLocalizations.of(context)!.flip,
                              style: AppFontStyles.k10BoldTextStyle.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 90,
                  right: 5,
                  child: InkWell(
                    onTap: _toggleFlash,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          WebsafeSvg.asset(
                            ImageAssets.icFlash,
                            width: 27,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: Text(
                              AppLocalizations.of(context)!.flash,
                              style: AppFontStyles.k10BoldTextStyle.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 30,
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: WebsafeSvg.asset(
                        ImageAssets.icClose,
                        width: 16.5,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MediaTemplatesPage.route(),
                        (route) => route.isFirst,
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
