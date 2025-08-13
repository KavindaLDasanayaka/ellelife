import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ellelife/src/feed/data/post_storage.dart';
import 'package:ellelife/src/feed/domain/entities/post.dart';
import 'package:ellelife/src/feed/domain/repo/post_repo.dart';

class PostRepoImpl extends PostRepo {
  //collection reference
  final CollectionReference _postsCollection = FirebaseFirestore.instance
      .collection("feeds");

  @override
  Future<void> deletePost({
    required String postId,
    required String publicId,
  }) async {
    try {
      await _postsCollection.doc(postId).delete();
      await PostStorage().destroyCloudinaryImage(publicId);
    } catch (err) {
      print("delete post error: $err");
    }
  }

  @override
  Future<void> disLikePost({
    required String postId,
    required String userId,
  }) async {
    try {
      final DocumentReference postLikesRef = _postsCollection
          .doc(postId)
          .collection("likes")
          .doc(userId);

      //delete a document to the likes subcollection
      await postLikesRef.delete();

      //update the post like count in the post document
      final DocumentSnapshot postDoc = await _postsCollection.doc(postId).get();

      final Post post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

      final int newLikes = post.likes - 1;

      //update
      await _postsCollection.doc(postId).update({"likes": newLikes});
      print("Post DisLiked Successfully");
    } catch (err) {
      print("Liking service error : $err");
    }
  }

  @override
  Future<List<String>> getAllUserPostImages({required String userId}) {
    // TODO: implement getAllUserPostImages
    throw UnimplementedError();
  }

  @override
  Future<Post> getPost() {
    // TODO: implement getPost
    throw UnimplementedError();
  }

  @override
  Stream<List<Post>> getPostStream() {
    return _postsCollection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<int> getUserPostsCount(String userId) {
    // TODO: implement getUserPostsCount
    throw UnimplementedError();
  }

  @override
  Future<bool> hasUserLikedPost({
    required String postId,
    required String userId,
  }) async {
    try {
      final DocumentReference postLikeRef = _postsCollection
          .doc(postId)
          .collection("likes")
          .doc(userId);

      final DocumentSnapshot doc = await postLikeRef.get();
      return doc.exists;
    } catch (err) {
      print("Error checking if user liked post : $err");
      return false;
    }
  }

  @override
  Future<void> likePost({
    required String postId,
    required String userId,
  }) async {
    try {
      final DocumentReference postLikesRef = _postsCollection
          .doc(postId)
          .collection("likes")
          .doc(userId);

      //add a document to the likes subcollection
      await postLikesRef.set({"LikedAt": Timestamp.now()});

      //update the post like count in the post document
      final DocumentSnapshot postDoc = await _postsCollection.doc(postId).get();

      final Post post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

      final int newLikes = post.likes + 1;

      //update
      await _postsCollection.doc(postId).update({"likes": newLikes});

      print("Post Liked Successfully");
    } catch (err) {
      print("Liking service error : $err");
    }
  }

  @override
  Future<void> savePost(Post post) async {
    try {
      final DocumentReference docref = await _postsCollection.add(
        post.toJson(),
      );

      final postId = docref.id;

      final postMap = post.toJson();
      postMap["postId"] = postId;

      await docref.set(postMap);
    } catch (err) {
      print("Saving post error: $err");
    }
  }

  @override
  Future<void> updatePost(Post post) async {
    try {
      final Map<String, dynamic> postData = post.toJson();

      await _postsCollection.doc(post.postId).set(postData);
    } catch (err) {
      print("updating post error: $err");
    }
  }
}
