part of 'team_register_bloc.dart';

sealed class TeamRegisterState {}

final class TeamRegisterInitial extends TeamRegisterState {}

final class TeamRegisteringState extends TeamRegisterState {}

final class TeamRegisteredState extends TeamRegisterState {}

final class TeamRegisterErrorState extends TeamRegisterState {}
