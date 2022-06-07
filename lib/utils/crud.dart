import 'package:cloud_firestore/cloud_firestore.dart';

class CRUD {
  static Future getDocs(String collection) async {
    return await FirebaseFirestore.instance.collection(collection).get();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> streamData(
      String collection) async* {
    yield* FirebaseFirestore.instance.collection(collection).snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> streamDataByField(
      String collection, String queryField, dynamic queryValue) async* {
    yield* FirebaseFirestore.instance
        .collection(collection)
        .where(queryField, isEqualTo: queryValue)
        .snapshots();
  }

  static Future addDoc(String collection, Map<String, dynamic> body) async {
    return await FirebaseFirestore.instance.collection(collection).add(body);
  }

  static Future updateDoc(String collection, id, body) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .update(body);
  }

  static Future deleteDoc(String collection, String id) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .delete();
  }
}
