import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add calculation history
  Future<void> addCalculationToHistory(String expression, String result) async {
    await _firestore.collection('calculations').add({
      'expression': expression,
      'result': result,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Clear all history
  Future<void> clearAllHistory() async {
    var batch = _firestore.batch();
    var snapshots = await _firestore.collection('calculations').get();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // Get calculations history
  Stream<List<Map<String, dynamic>>> getCalculationsHistory() {
    return _firestore
        .collection('calculations')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Delete a specific calculation
  Future<void> deleteCalculation(String id) async {
    await _firestore.collection('calculations').doc(id).delete();
  }
}
