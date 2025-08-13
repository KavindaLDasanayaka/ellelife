import 'package:ellelife/src/user/data/user_repos_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ellelife/src/user/domain/entities/user_model.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SerachUserEvent>(_filterUsers);
  }

  void _filterUsers(final SerachUserEvent event, final Emitter emit) async {
    emit(SearchLoading());
    List<UserModel?> _users = await UserReposImpl().getAllusers();
    List<UserModel?> _filteredUsers = _users
        .where(
          (user) =>
              user!.name.toLowerCase().contains(event.queary.toLowerCase()),
        )
        .toList();

    emit(SearchLoaded(users: _filteredUsers));
  }
}
