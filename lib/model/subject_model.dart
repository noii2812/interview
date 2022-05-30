import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectModel {
  final DocumentReference documentReference;
  final String name;
  final double score;
  SubjectModel.data(
    this.documentReference, {
    required this.name,
    required this.score,
  });

  factory SubjectModel.from(DocumentSnapshot document) {
    return SubjectModel.data(document.reference,
        name: document['name'], score: document['score']);
  }
}
