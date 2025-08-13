import 'package:ellelife/src/teams/data/teams_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ellelife/src/teams/domain/entities/team.dart';

part 'team_register_event.dart';
part 'team_register_state.dart';

class TeamRegisterBloc extends Bloc<TeamRegisterEvent, TeamRegisterState> {
  TeamRegisterBloc() : super(TeamRegisterInitial()) {
    on<TeamRegisteringEvent>(_teamRegister);
    on<TeamRegisterInitEvent>((event, emit) {
      emit(TeamRegisterInitial());
    });
  }

  Future<void> _teamRegister(TeamRegisteringEvent event, Emitter emit) async {
    emit(TeamRegisterInitial());
    await TeamsRepoImpl().saveTeam(event.team);
    emit(TeamRegisteredState());
  }
}
