part of 'postedit_bloc.dart';

sealed class PosteditEvent {}

final class UpdatePost extends PosteditEvent {
  final File? file;
  final Mood mood;
  final String caption;
  final String postId;

  UpdatePost(
    this.file, {
    required this.mood,
    required this.caption,
    required this.postId,
  });
}
