import 'package:ellelife/src/teams/data/teams_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ellelife/src/teams/domain/entities/team.dart';
import 'package:flutter/material.dart';

part 'teams_event.dart';
part 'teams_state.dart';

class TeamsBloc extends Bloc<TeamsEvent, TeamsState> {
  TeamsBloc() : super(TeamsInitial()) {
    on<SearchTeam>(_searchTeam);
  }

  Future<void> _searchTeam(final SearchTeam event, final Emitter emit) async {
    emit(SearchingTeams());
    List<Team?> _teams = await TeamsRepoImpl().getAllteams();
    List<Team?> _filteredTeams = _teams
        .where(
          (team) =>
              team!.teamName.toLowerCase().contains(event.query.toLowerCase()),
        )
        .toList();

    emit(SearchedTeams(filteredTeams: _filteredTeams));
  }
}
