import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/subjects.dart';

import '../../KeyName.dart';

class AuthorizationProvider extends ChangeNotifier {
  bool isEnableConfirm = false;

  List<XFile> images = [];
  String title = '';
  String content = '';

  BehaviorSubject<List<XFile>> imagesPublisher = BehaviorSubject.seeded([]);
  BehaviorSubject<bool> loadingPublisher = BehaviorSubject.seeded(false);

  final storage = FirebaseStorage.instanceFor(bucket: 'gs://livingmanage-5df73.appspot.com').ref();
  final db = FirebaseFirestore.instance;

  Future<List<String>> reqUploadImages(String id, String timestamp) async {
    List<String> imageUrls = [];
    for (int i = 0; i < imagesPublisher.value.length; i++) {
      var uploadTask = await storage.child('$id/${timestamp}_num$i').putFile(File(imagesPublisher.value[i].path));
      String url = await uploadTask.ref.getDownloadURL();
      imageUrls.add(url);
    }
    return imageUrls;
  }

  Future<bool> reqNewAuthorization(String id) async {
    loadingPublisher.sink.add(true);

    try {
      var timestamp = DateTime.now().millisecondsSinceEpoch;
      var imageUrls = await reqUploadImages(id, timestamp.toString());

      var data = <String, dynamic>{
        'id': id,
        'title': title,
        'content': content,
        'answer': '',
        'timestamp': timestamp,
        'imageUrls': imageUrls
      };

      await db
          .collection(COLLECTION_KEY_AUTHORIZATION)
          .doc(id)
          .collection(COLLECTION_ON_AIR_AUTHORIZATION)
          .doc(timestamp.toString())
          .set(data);

      loadingPublisher.sink.add(false);
      return true;
    } catch (e) {
      loadingPublisher.sink.add(false);
      return false;
    }
  }
}
