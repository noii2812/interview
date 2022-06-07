import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  final DocumentReference documentReference;
  final String studentName;
  final String className;
  final String email;
  final String gender;
  final String dob;
  final String departmentId;
  final List<Subjects> subjects;
  final bool isDisabled;

  StudentModel.data(this.documentReference,
      {required this.studentName,
      required this.className,
      required this.email,
      required this.gender,
      required this.dob,
      required this.departmentId,
      required this.subjects,
      required this.isDisabled});

  factory StudentModel.from(DocumentSnapshot<Map<String, dynamic>> document) {
    return StudentModel.data(document.reference,
        studentName: document.data()?['name'],
        className: document.data()?['className'],
        email: document.data()?['email'],
        gender: document.data()?['gender'],
        dob: document.data()?['dob'],
        departmentId: document.data()?['departmentId'],
        subjects: List<Subjects>.from(
            document.data()?["subjects"].map((x) => Subjects.fromJson(x))),
        isDisabled: document.data()!['isDisabled'] ?? false);
  }
}

class Subjects {
  final String subjectId;
  final String name;
  final double score;

  Subjects({required this.subjectId, required this.name, required this.score});

  factory Subjects.fromJson(Map<String, dynamic> json) {
    return Subjects(
        subjectId: json['subjectId'] ?? "",
        name: json['name'] ?? "",
        score: json['score'] ?? 0);
  }
}
