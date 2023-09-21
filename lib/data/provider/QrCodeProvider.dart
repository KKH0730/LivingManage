import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:livingmanage/KeyName.dart';

class QrCodeProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;

  Future<bool> reqUpdateSharedPerson(
      String id,
      String name,
      String profileUrl,
      String hostId,
      String hostName,
      String hostProfileUrl
  ) async {
    QuerySnapshot<Map<String, dynamic>> data = await db.collection(COLLECTION_SHARED)
        .doc(id)
        .collection(COLLECTION_SHARED_PEOPLE)
        .add();

    List<SharedPerson> imageUrls = [];
    for (var element in data.docs) {
      imageUrls.add(SharedPerson.fromMap(element.data()));
    }

    onSharedPeopleImagesPublisher.sink.add(imageUrls);
    return false;
  }
}