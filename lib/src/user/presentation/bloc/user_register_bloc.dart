import 'package:ellelife/src/user/data/user_repos_impl.dart';
import 'package:ellelife/src/user/domain/entities/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'user_register_event.dart';
part 'user_register_state.dart';

class UserRegisterBloc extends Bloc<UserRegisterEvent, UserRegisterState> {
  UserRegisterBloc() : super(UserRegisterInitial()) {
    on<UserRegiteringEvent>(_userRegistering);
  }

  Future<void> _userRegistering(
    final UserRegiteringEvent event,
    final Emitter emit,
  ) async {
    emit(UserRegisteringLoading());
    await UserReposImpl().saveUser(event.user, event.password);
    emit(UserRegisteringSuccess());
  }
}
