import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ground_break/services/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class RecordingService {
  static String encoder = Platform.isIOS
      ? '-c:v h264 -c:a aac -vprofile main -pix_fmt yuv420p'
      : '-c:v mpeg4 -c:a aac';
  static Future<File?> convertVideo(File video) async {
    String filePath = await FileService.getTemporaryFilePath(
      directoryName: 'recordings',
      fileName: '${video.path.split('/').last.split('.').first}_converted.mp4',
    );
    String command = '-i ${video.path} $encoder $filePath';
    FFmpegSession session = await FFmpegKit.execute(command);
    ReturnCode? returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      if (kDebugMode) {
        print('[convertVideo] encoder $encoder');
        print('[convertVideo] saved to $filePath');
      }
      return File(filePath);
    } else {
      if (kDebugMode) {
        print('[convertVideo] error');
      }
      return null;
    }
  }

  static Future<File?> mergeVideos(List<File> videos) async {
    String filePath = await FileService.getTemporaryFilePath(
      directoryName: 'recordings',
      fileName: 'output.mp4',
    );

    String fileNames = videos.map((e) => '-i ${e.path}').join(' ');
    String commandToExecute = videos.length > 1
        ? '-y $fileNames -r 24000/1001 -filter_complex \'[0:v:0][0:a:0][1:v:0][1:a:0]concat=n=${videos.length}:v=1:a=1[out]\' -map \'[out]\' $encoder $filePath'
        : '-i ${videos[0].path} $encoder $filePath';
    // FFmpegKit.executeAsync(
    //   commandToExecute,
    //   (_) {},
    //   (log) {
    //     print(log.getMessage());
    //   },
    // );
    // return null;
    FFmpegSession session = await FFmpegKit.execute(commandToExecute);
    ReturnCode? returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      if (kDebugMode) {
        print('[mergeVideos] encoder $encoder');
        print('[mergeVideos] saved to $filePath');
      }
      return File(filePath);
    } else {
      if (kDebugMode) {
        print('[mergeVideos] error');
      }
      return null;
    }
  }

  static Future<File?> addWatermark({
    required File video,
    required File image,
    required Size videoSize,
    required Size imageSize,
    required Offset offset,
  }) async {
    double imageWidthRatio = imageSize.width / videoSize.width;
    double imageHeightRatio = imageSize.height / videoSize.height;
    double offsetXRatio = offset.dx / videoSize.width;
    double offsetYRatio = offset.dy / videoSize.height;
    String filePath = await FileService.getTemporaryFilePath(
      directoryName: 'recordings',
      fileName: 'output_watermark.mp4',
    );
    String command =
        '-i ${video.path} -i ${image.path} -filter_complex "[1][0]scale2ref=w=iw*$imageWidthRatio:h=ih*$imageHeightRatio[logo][video];[video][logo]overlay=W*$offsetXRatio:H*$offsetYRatio" $encoder copy $filePath';
    FFmpegSession session = await FFmpegKit.execute(command);
    ReturnCode? returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      if (kDebugMode) {
        print('[addWatermark] encoder $encoder');
        print('[addWatermark] saved to $filePath');
      }
      return File(filePath);
    } else {
      if (kDebugMode) {
        print('[addWatermark] error');
      }
      return null;
    }
  }

  static Future<File?> generateGif(File video) async {
    String filePath = await FileService.getTemporaryFilePath(
      directoryName: 'recordings',
      fileName: 'output_gif.gif',
    );
    String command =
        '-i ${video.path} -vf "fps=10,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 $filePath';
    FFmpegSession session = await FFmpegKit.execute(command);
    ReturnCode? returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      if (kDebugMode) {
        print('[generateGif] saved to $filePath');
      }
      return File(filePath);
    } else {
      if (kDebugMode) {
        print('[generateGif] error');
      }
      return null;
    }
  }

  static Future<bool> saveGif(String path) async {
    // bool statuses = await (Platform.isAndroid
    //         ? Permission.photos
    //         : Permission.photosAddOnly)
    //     .request()
    //     .isGranted;
    // if (statuses) {
    dynamic result = await ImageGallerySaver.saveFile(
      path,
      name: '${DateTime.now().millisecondsSinceEpoch}.gif',
    );
    if (result['isSuccess']) {
      if (kDebugMode) {
        print('[save gif] success');
      }
    } else {
      if (kDebugMode) {
        print('[save gif] failed: ${result['errorMessage']}');
      }
    }
    return result['isSuccess'];
    // } else {
    //   if (kDebugMode) {
    //     print('[save gif] failed: permission ungranted');
    //   }
    //   return false;
    // }
  }
}
