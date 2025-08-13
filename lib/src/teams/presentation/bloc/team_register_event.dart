part of 'team_register_bloc.dart';

sealed class TeamRegisterEvent {}

final class TeamRegisteringEvent extends TeamRegisterEvent {
  final Team team;

  TeamRegisteringEvent({required this.team});
}

final class TeamRegisterInitEvent extends TeamRegisterEvent {}
