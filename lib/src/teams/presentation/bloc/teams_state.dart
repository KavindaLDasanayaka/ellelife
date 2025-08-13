part of 'teams_bloc.dart';

@immutable
sealed class TeamsState {}

final class TeamsInitial extends TeamsState {}

final class SearchingTeams extends TeamsState {}

final class SearchedTeams extends TeamsState {
  final List<Team?> filteredTeams;

  SearchedTeams({required this.filteredTeams});
}

final class SearchingTeamsError extends TeamsState {
  final String message;

  SearchingTeamsError({required this.message});
}
