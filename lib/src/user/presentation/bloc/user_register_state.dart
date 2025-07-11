part of 'user_register_bloc.dart';

sealed class UserRegisterState {}

final class UserRegisterInitial extends UserRegisterState {}

final class UserRegisteringLoading extends UserRegisterState {}

final class UserRegisteringSuccess extends UserRegisterState {}

final class UserRegisteringError extends UserRegisterState {
  final String message;
  UserRegisteringError({required this.message});
}
