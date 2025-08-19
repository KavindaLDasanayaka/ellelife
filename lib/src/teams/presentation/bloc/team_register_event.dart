part of 'team_register_bloc.dart';

sealed class TeamRegisterEvent {}

final class TeamRegisteringEvent extends TeamRegisterEvent {
  final File? image;
  final String teamName;
  final String village;
  final int contactNo;

  TeamRegisteringEvent({
    required this.image,
    required this.teamName,
    required this.village,
    required this.contactNo,
  });
}

final class TeamRegisterInitEvent extends TeamRegisterEvent {}
