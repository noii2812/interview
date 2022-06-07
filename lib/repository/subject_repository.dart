import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soknoy_interview/utils/crud.dart';

abstract class SubjectInterface {
  static void addNewSubject() {}
  static void updateSubject() {}
  static void getAllSubject() {}
  static void deleteSubject() {}
  static streamSubjects() {}
}

String collectionName = "subject";

class SubjectFunctions implements SubjectInterface {
  static Future addNewSubject(body) async {
    try {
      return await CRUD.addDoc(collectionName, body);
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> streamSubjects() async* {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> subjects =
          CRUD.streamData(collectionName);
      yield* subjects;
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  static Future<void> updateSubjects(id, body) async {
    try {
      return await CRUD.updateDoc(collectionName, id, body);
    } on FirebaseException catch (e) {
      throw e;
    }
  }
}
