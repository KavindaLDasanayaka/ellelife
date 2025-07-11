part of 'user_register_bloc.dart';

sealed class UserRegisterEvent {}

final class UserRegiteringEvent extends UserRegisterEvent {
  final UserModel user;
  final String password;

  UserRegiteringEvent({required this.user, required this.password});
}
