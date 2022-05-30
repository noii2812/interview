import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentModel {
  final DocumentReference documentReference;
  final String name;

  DepartmentModel.data(
    this.documentReference, {
    required this.name,
  });

  factory DepartmentModel.from(DocumentSnapshot document) {
    return DepartmentModel.data(
      document.reference,
      name: document['name'],
    );
  }
}
