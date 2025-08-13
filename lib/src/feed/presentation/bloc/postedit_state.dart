part of 'postedit_bloc.dart';

sealed class PosteditState {}

final class PosteditInitial extends PosteditState {}

final class PosteditSavingState extends PosteditState {}

final class PostEditedState extends PosteditState {
  final Post post;

  PostEditedState({required this.post});
}

final class PostEditErrorState extends PosteditState {}
