import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:livingmanage/KeyName.dart';
import 'package:livingmanage/data/model/AuthorizationItem.dart';
import 'package:livingmanage/data/model/SharedPerson.dart';

class HomeProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;

  final onAirAuthorizationPublisher = StreamController<List<AuthorizationItem>>();
  Stream<List<AuthorizationItem>> get onAirAuthorizationStream => onAirAuthorizationPublisher.stream;

  final onSharedPeopleImagesPublisher = StreamController<List<SharedPerson>>();
  Stream<List<SharedPerson>> get onSharedPeopleImagesStream => onSharedPeopleImagesPublisher.stream;

  Future<void> reqSharedPeople(String id) async {
    QuerySnapshot<Map<String, dynamic>> data = await db.collection(COLLECTION_SHARED)
        .doc(id)
        .collection(COLLECTION_SHARED_PEOPLE)
        .get();

    List<SharedPerson> imageUrls = [];
    for (var element in data.docs) {
      imageUrls.add(SharedPerson.fromMap(element.data()));
    }

    onSharedPeopleImagesPublisher.sink.add(imageUrls);
  }

  Future<List<AuthorizationItem>> reqOnAirAuthorization(String id) async {
    QuerySnapshot<Map<String, dynamic>> data = await db.collection(COLLECTION_KEY_AUTHORIZATION)
        .doc(id)
        .collection(COLLECTION_ON_AIR_AUTHORIZATION)
        .get();

    List<AuthorizationItem> imageUrls = [];
    for (var element in data.docs) {
      imageUrls.add(AuthorizationItem.fromMap(element.data()));
    }

    onAirAuthorizationPublisher.sink.add(imageUrls);
    return imageUrls;
  }
}