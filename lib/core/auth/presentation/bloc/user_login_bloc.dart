import 'package:ellelife/core/auth/data/user_auth_repo_impl.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_login_event.dart';
part 'user_login_state.dart';

class UserLoginBloc extends Bloc<UserLoginEvent, UserLoginState> {
  UserLoginBloc() : super(UserLoginInitial()) {
    on<UserLogEvent>(_userLogEvent);
    on<SignUpWithGoogleEvent>(_signInWithGoogle);
  }

  Future<void> _userLogEvent(
    final UserLogEvent event,
    final Emitter emit,
  ) async {
    emit(UserLoginLoading());
    await UserAuthService().signInWithEmailAndPassword(
      email: event.userName,
      password: event.password,
    );

    emit(UserLoggedIn());
  }

  Future<void> _signInWithGoogle(
    final SignUpWithGoogleEvent event,
    final Emitter emit,
  ) async {
    emit(UserLoginLoading());
    await UserAuthService().signInWithGoogle();
    emit(UserLoggedIn());
  }
}
