import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ellelife/src/feed/domain/entities/reel.dart';

class ReelsRepoImpl {
  final CollectionReference _reelsCollection = FirebaseFirestore.instance
      .collection('reels');

  final Query _orderedReelsQuery = FirebaseFirestore.instance
      .collection('reels')
      .orderBy(
        'createdAt',
        descending: true,
      ); // Order by creation date, newest first

  // Get all reels ordered from latest to oldest
  Stream<List<Reel>> getReelsStream() {
    return _orderedReelsQuery.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => Reel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList();
    });
  }

  // Add a new reel
  Future<void> addReel(Reel reel) async {
    await _reelsCollection.doc(reel.id).set(reel.toMap());
  }

  // Get a single reel by ID
  Future<Reel?> getReelById(String id) async {
    DocumentSnapshot doc = await _reelsCollection.doc(id).get();
    if (doc.exists) {
      return Reel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }
}
