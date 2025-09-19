abstract class UserUpdateState {}

class UserUpdateInitial extends UserUpdateState {}

class UserUpdateLoading extends UserUpdateState {}

class UserUpdateSuccess extends UserUpdateState {
  final String message;

  UserUpdateSuccess({required this.message});
}

class UserUpdateFailure extends UserUpdateState {
  final String error;

  UserUpdateFailure({required this.error});
}