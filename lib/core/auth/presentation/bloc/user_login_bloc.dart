import 'package:ellelife/core/auth/data/user_auth_repo_impl.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_login_event.dart';
part 'user_login_state.dart';

class UserLoginBloc extends Bloc<UserLoginEvent, UserLoginState> {
  UserLoginBloc() : super(UserLoginInitial()) {
    on<UserLogEvent>(_userLogEvent);
    on<SignUpWithGoogleEvent>(_signInWithGoogle);
    on<ForgotPasswordEvent>(_forgotPasswordEvent);
    on<UserLogoutEvent>((event, emit) {
      emit(UserLoginInitial());
    });
  }

  Future<void> _userLogEvent(
    final UserLogEvent event,
    final Emitter emit,
  ) async {
    try {
      emit(UserLoginLoading());
      await UserAuthService().signInWithEmailAndPassword(
        email: event.userName,
        password: event.password,
      );

      emit(UserLoggedIn());
    } catch (err) {
      emit(UserLoginError(message: "Email or Password is Incorrect!"));
      throw Exception("Login Error! $err");
    }
  }

  Future<void> _signInWithGoogle(
    final SignUpWithGoogleEvent event,
    final Emitter emit,
  ) async {
    emit(UserLoginLoading());
    await UserAuthService().signInWithGoogle();
    emit(UserLoggedIn());
  }

  Future<void> _forgotPasswordEvent(
    final ForgotPasswordEvent event,
    final Emitter emit,
  ) async {
    try {
      emit(ForgotPasswordLoading());
      await UserAuthService().resetPassword(event.email);
      emit(
        ForgotPasswordSuccess(
          message:
              "Password reset email sent successfully! Please check your inbox.",
        ),
      );
    } catch (err) {
      emit(
        ForgotPasswordError(
          message:
              "Failed to send password reset email. Please check the email address and try again.",
        ),
      );
    }
  }
}
