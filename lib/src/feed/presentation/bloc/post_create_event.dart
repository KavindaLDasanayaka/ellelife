part of 'post_create_bloc.dart';

sealed class PostCreateEvent {}

final class PostCreatingEvent extends PostCreateEvent {
  final File? file;
  final Mood mood;
  final String caption;

  PostCreatingEvent(this.file, {required this.mood, required this.caption});
}

final class PostInitEvent extends PostCreateEvent {}

final class MoodSelection extends PostCreateEvent {
  final File? file;
  final Mood mood;

  MoodSelection(this.file, {required this.mood});
}

final class ImageSelectEvent extends PostCreateEvent {
  final File file;
  final Mood mood;
  ImageSelectEvent({required this.file, required this.mood});
}
