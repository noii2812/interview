import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soknoy_interview/model/student_model.dart';
import 'package:soknoy_interview/utils/crud.dart';
import 'dart:js' as js;

abstract class StudentInterface {
  static void addNewStudent() {}
  static void updateStudent() {}
  static void getAllStudent() {}
  static void deleteStudent() {}
  static streamStudents() {}
}

String colletionName = "student";

class StudentFuctions implements StudentInterface {
  static Future addNewStudent(body) async {
    try {
      return await CRUD.addDoc(colletionName, body);
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  static Future<void> deleteStudent(String id) async {
    var body = {"isDisabled": true};
    try {
      return await CRUD.updateDoc(colletionName, id, body).whenComplete(() {
        js.context.callMethod("showAlert", ["Student is deleted"]);
      });
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  static Stream<List<StudentModel>>? streamStudents() {
    try {
      Stream<List<StudentModel>> students = CRUD.streamData("student").map((e) {
        return List<StudentModel>.from(e.docs.map((e) => StudentModel.from(e)))
            .where((element) => !element.isDisabled)
            .toList();
      });
      return students;
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  void getAllStudent() {
    // TODO: implement getAllStudent
  }

  static Future<void> updateStudent(studentId, updateBody) async {
    try {
      return await CRUD.updateDoc(colletionName, studentId, updateBody);
    } on FirebaseException catch (e) {
      throw e;
    }
  }
}
