// experience_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'experience_model.dart';

class ExperienceService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('experiences');

  Future<void> addExperience(Experience exp) {
    return _collection.add(exp.toMap());
  }

  Future<void> addReview(String experienceId, Review review) {
    return _collection.doc(experienceId).update({
      'reviews': FieldValue.arrayUnion([review.toMap()])
    });
  }

  Stream<List<Experience>> getExperiences() {
    return _collection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Experience.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList());
  }
}