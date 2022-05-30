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
  StudentModel.data(this.documentReference,
      {required this.studentName,
      required this.className,
      required this.email,
      required this.gender,
      required this.dob,
      required this.departmentId,
      required this.subjects});

  factory StudentModel.from(DocumentSnapshot document) {
    return StudentModel.data(document.reference,
        studentName: document['name'],
        className: document['className'],
        email: document['email'],
        gender: document['gender'],
        dob: document['dob'],
        departmentId: document['departmentId'],
        subjects: List<Subjects>.from(
            document["subjects"].map((x) => Subjects.fromJson(x))));
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
