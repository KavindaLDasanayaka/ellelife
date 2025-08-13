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
        final imageUrl = await PostStorage().uploadImageToCloudinary(
          imageFile: event.file!,
        );
        imageUrl0 = imageUrl!;
      }
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userDetails = await UserReposImpl().getUserById(user.uid);

        if (userDetails != null) {
          final post = Post(
            postCaption: event.caption,
            mood: event.mood,
            userId: userDetails.userId,
            username: userDetails.name,
            likes: 0,
            postId: event.postId,
            datePublished: DateTime.now(),
            postImage: imageUrl0!,
            profImage: userDetails.imageUrl,
          );

          await PostRepoImpl().updatePost(post);

          emit(PostEditedState(post: post));
        }
      }
    } catch (err) {
      print("error in saving post ui:$err");
      throw Exception("Connection Error!");
    }
  }
}
