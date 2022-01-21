import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseHelper {
  static String getid() {
    final auth = FirebaseAuth.instance;
    return auth.currentUser.uid;
  }

  static Future<void> addwithid(
      {String collectionpath, String itemid, Map<String, Object> data}) async {
    final firestore = FirebaseFirestore.instance;

    await firestore.collection(collectionpath).doc(itemid).set(data);
  }

  static Future<void> add(
      {String collectionpath, Map<String, Object> data}) async {
    final firestore = FirebaseFirestore.instance;

    await firestore.collection(collectionpath).add(data);
  }

  static Future<void> delete({String collectionpath, String itemid}) async {
    final firestore = FirebaseFirestore.instance;

    await firestore.collection(collectionpath).doc(itemid).delete();
  }

  static Future<List<QueryDocumentSnapshot>> getlist(
      {String collectionpath}) async {
    final firestore = FirebaseFirestore.instance;

    final snapshot = await firestore.collection(collectionpath).get();

    return snapshot.docs;
  }

  static Future<Map<String, dynamic>> getitem(
      {String collectionpath, String itemid}) async {
    final firestore = FirebaseFirestore.instance;

    final docdata =
        await firestore.collection(collectionpath).doc(itemid).get();

    return docdata.data();
  }

  static Future<String> getitemfield(
      {String collectionpath, String itemid, String field}) async {
    final firestore = FirebaseFirestore.instance;

    final docdata =
        await firestore.collection(collectionpath).doc(itemid).get();
    print(docdata.get(field));
    return docdata.get(field);
  }

  static Future<void> update(
      {String collectionpath, String itemid, Map<String, Object> data}) async {
    final firestore = FirebaseFirestore.instance;

    await firestore.collection(collectionpath).doc(itemid).update(data);
  }

  static Future<void> bukcetadd({String locationpath, File file}) async {
    final storage = FirebaseStorage.instance;

    await storage.ref(locationpath).putFile(file);
  }

  static Future<void> bukcetdelete({String locationpath}) async {
    final storage = FirebaseStorage.instance;

    await storage.ref(locationpath).delete();
  }

  static Future<String> bukcetgetlink({String locationpath}) {
    final storage = FirebaseStorage.instance;

    return storage.ref(locationpath).getDownloadURL();
  }

  static Future<void> bukcetadddata({String locationpath, String data}) async {
    final storage = FirebaseStorage.instance;

    await storage.ref(locationpath).putString(data);
  }
}
