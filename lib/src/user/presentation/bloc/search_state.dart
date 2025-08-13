part of 'search_bloc.dart';

sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchLoaded extends SearchState {
  final List<UserModel?> users;

  SearchLoaded({required this.users});
}

final class SearchError extends SearchState {
  final String message;

  SearchError({required this.message});
}
