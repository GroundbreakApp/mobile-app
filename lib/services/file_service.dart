import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileService {
  static Future<String> getTemporaryFilePath({
    required String directoryName,
    required String fileName,
  }) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    String basePath = '$dir/$directoryName';
    String filePath = '$basePath/$fileName';

    if (!Directory(basePath).existsSync()) {
      await Directory(basePath).create(recursive: true);
    }
    if (await File(filePath).exists()) {
      await File(filePath).delete();
    }
    return filePath;
  }
}
