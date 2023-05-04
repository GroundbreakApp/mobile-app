import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:ground_break/models/models.dart';

class UploadService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static const String _gifsCollectionName = 'gifs';

  static Future<String?> uploadFile({
    required String path,
    required File file,
    required String fileExtension,
  }) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        final String fileName =
            '${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
        final Reference reference =
            _storage.ref().child('gifs/$uid/$path/$fileName');
        final UploadTask uploadTask = reference.putFile(file);
        final TaskSnapshot downloadUrl = await uploadTask;
        final String url = await downloadUrl.ref.getDownloadURL();
        return url;
      } catch (e) {
        if (kDebugMode) {
          print('[uploadFile] ${e.toString()}');
        }
        return null;
      }
    } else {
      if (kDebugMode) {
        print('[uploadFile] not signed in');
      }
      return null;
    }
  }

  static String get newMediaId {
    return FirebaseFirestore.instance.collection(_gifsCollectionName).doc().id;
  }

  static Future<MediaModel?> createMedia(MediaModel media) async {
    try {
      String docId = media.id.isEmpty ? newMediaId : media.id;
      MediaModel mediaModel = media.copyWith(
        id: docId,
        creator: FirebaseAuth.instance.currentUser?.uid,
      );
      await FirebaseFirestore.instance
          .collection(_gifsCollectionName)
          .doc(docId)
          .set(
            mediaModel.toJson(),
            SetOptions(merge: true),
          );
      return mediaModel;
    } catch (e) {
      if (kDebugMode) {
        print('[createMedia] ${e.toString()}');
      }
      return null;
    }
  }

  static Stream<List<MediaModel>> getMedia$() {
    try {
      return FirebaseFirestore.instance
          .collection(_gifsCollectionName)
          .snapshots()
          .map(
            (event) => event.docs
                .map(
                  (e) => MediaModel.fromSnapshot(e),
                )
                .toList(),
          );
    } catch (e) {
      if (kDebugMode) {
        print('[getMedia] ${e.toString()}');
      }
      return Stream.value([]);
    }
  }
}
