import 'dart:io';

import 'package:ellelife/core/utils/mood.dart';
import 'package:ellelife/src/feed/data/post_repo_impl.dart';
import 'package:ellelife/src/feed/data/post_storage.dart';
import 'package:ellelife/src/feed/domain/entities/post.dart';
import 'package:ellelife/src/user/data/user_repos_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_create_event.dart';
part 'post_create_state.dart';

class PostCreateBloc extends Bloc<PostCreateEvent, PostCreateState> {
  PostCreateBloc() : super(PostCreateInitial(mood: Mood.happy, null)) {
    on<PostCreatingEvent>(_postCreating);
    on<PostInitEvent>((event, emit) {
      emit(PostCreateInitial(mood: Mood.happy, null));
    });
    on<MoodSelection>((event, emit) {
      emit(PostCreateInitial(mood: event.mood, event.file));
    });
    on<ImageSelectEvent>((event, emit) {
      emit(PostCreateInitial(mood: event.mood, event.file));
    });
  }

  Future<void> _postCreating(
    final PostCreatingEvent event,
    final Emitter emit,
  ) async {
    emit(PostCreateLoading());

    try {
      String? _imageUrl;
      if (event.file != null) {
        final imageUrl = await PostStorage().uploadImageToCloudinary(
          imageFile: event.file!,
        );
        _imageUrl = imageUrl!;
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
            postId: "",
            datePublished: DateTime.now(),
            postImage: _imageUrl!,
            profImage: userDetails.imageUrl,
          );

          await PostRepoImpl().savePost(post);

          emit(PostCreated());
        }
      }
    } catch (err) {
      print("error in saving post ui:$err");
      throw Exception("Connection Error!");
    }
  }
}
