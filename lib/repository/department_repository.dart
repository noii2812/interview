import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soknoy_interview/utils/crud.dart';

abstract class DepartmentInterface {
  static void addNewDepartment() {}
  static void updateDepartment() {}
  static void getAllDepartment() {}
  static void deleteDepartment() {}
  static streamDepartments() {}
}

String collectionName = "department";

class DepartmentFunctions implements DepartmentInterface {
  static Future addNewDepartment(body) async {
    try {
      return await CRUD.addDoc(collectionName, body);
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      streamDepartments() async* {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> departments =
          CRUD.streamData(collectionName);
      yield* departments;
    } on FirebaseException catch (e) {
      throw e;
    }
  }
}
