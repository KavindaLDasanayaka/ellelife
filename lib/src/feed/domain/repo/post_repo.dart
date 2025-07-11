import 'package:ellelife/src/feed/domain/entities/post.dart';

abstract class PostRepo {
  Future<Post> getPost();

  Future<void> savePost(Post post);

  Stream<List<Post>> getPostStream();

  Future<void> likePost({required String postId, required String userId});

  Future<void> disLikePost({required String postId, required String userId});

  Future<bool> hasUserLikedPost({
    required String postId,
    required String userId,
  });

  Future<void> deletePost({required String postId, required String publicId});

  Future<List<String>> getAllUserPostImages({required String userId});

  Future<int> getUserPostsCount(String userId);
}
