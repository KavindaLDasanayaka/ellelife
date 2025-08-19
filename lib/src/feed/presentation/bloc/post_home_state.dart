part of 'post_home_bloc.dart';

sealed class PostHomeState {}

final class PostHomeInitial extends PostHomeState {}

final class PostsLoading extends PostHomeState {}

final class PostsLoadingError extends PostHomeState {}

final class PostsLoaded extends PostHomeState {
  final List<Post> posts;

  PostsLoaded({required this.posts});
}
