part of 'teams_bloc.dart';

@immutable
sealed class TeamsEvent {}

final class SearchTeam extends TeamsEvent {
  final String query;

  SearchTeam({required this.query});
}

final class TeamsInitEvent extends TeamsEvent {}
