part of 'post_create_bloc.dart';

sealed class PostCreateState {}

final class PostCreateInitial extends PostCreateState {
  final Mood mood;
  File? imageFile;
  PostCreateInitial(this.imageFile, {required this.mood});
}

final class PostCreateLoading extends PostCreateState {}

final class PostCreateError extends PostCreateState {
  final String message;

  PostCreateError({required this.message});
}

final class PostCreated extends PostCreateState {}
