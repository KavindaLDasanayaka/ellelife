part of 'post_home_bloc.dart';

@immutable
sealed class PostHomeState {}

final class PostHomeInitial extends PostHomeState {}

final class PostsLoading extends PostHomeState {}

final class PostsLoadingError extends PostHomeState {}

final class PostsLoaded extends PostHomeState {}
