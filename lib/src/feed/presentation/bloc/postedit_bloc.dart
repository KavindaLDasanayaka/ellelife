import 'dart:io';

import 'package:ellelife/core/utils/mood.dart';
import 'package:ellelife/src/feed/data/post_repo_impl.dart';
import 'package:ellelife/src/feed/data/post_storage.dart';
import 'package:ellelife/src/feed/domain/entities/post.dart';
import 'package:ellelife/src/user/data/user_repos_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'postedit_event.dart';
part 'postedit_state.dart';

class PosteditBloc extends Bloc<PosteditEvent, PosteditState> {
  PosteditBloc() : super(PosteditInitial()) {
    on<UpdatePost>(_updatePost);
  }

  Future<void> _updatePost(UpdatePost event, Emitter emit) async {
    emit(PosteditSavingState());
    try {
      String? imageUrl0;
      if (event.file != null) {
        // Upload new image if provided
        final imageUrl = await PostStorage().uploadImageToCloudinary(
          imageFile: event.file!,
        );
        imageUrl0 = imageUrl!;
      } else {
        // Preserve existing image when no new image is provided
        // We'll get the existing post to preserve its image
        final existingPost = await PostRepoImpl().getPostById(event.postId);
        if (existingPost != null) {
          imageUrl0 = existingPost.postImage;
        } else {
          // Fallback to empty string if we can't get the existing post
          imageUrl0 = '';
        }
      }
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userDetails = await UserReposImpl().getUserById(user.uid);
        
        // Get the existing post to preserve certain fields
        final existingPost = await PostRepoImpl().getPostById(event.postId);

        if (userDetails != null) {
          final post = Post(
            postCaption: event.caption,
            mood: event.mood,
            userId: userDetails.userId,
            username: userDetails.name,
            likes: existingPost?.likes ?? 0, // Preserve likes from existing post
            postId: event.postId,
            datePublished: existingPost?.datePublished ?? DateTime.now(), // Preserve date from existing post
            postImage: imageUrl0,
            profImage: userDetails.imageUrl,
          );

          await PostRepoImpl().updatePost(post);

          emit(PostEditedState(post: post));
        }
      }
    } catch (err) {
      print("error in saving post ui:$err");
      emit(PostEditErrorState());
    }
  }
}