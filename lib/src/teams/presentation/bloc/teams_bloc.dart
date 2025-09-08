import 'package:ellelife/src/teams/data/teams_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ellelife/src/teams/domain/entities/team.dart';
import 'package:flutter/material.dart';

part 'teams_event.dart';
part 'teams_state.dart';

class TeamsBloc extends Bloc<TeamsEvent, TeamsState> {
  TeamsBloc() : super(TeamsInitial()) {
    on<SearchTeam>(_searchTeam);
    on<TeamsInitEvent>((event, emit) {
      emit(TeamsInitial());
    });
  }

  Future<void> _searchTeam(final SearchTeam event, final Emitter emit) async {
    try {
      // If search query is empty, return to initial state
      if (event.query.trim().isEmpty) {
        emit(TeamsInitial());
        return;
      }

      emit(SearchingTeams());
      List<Team?> teams = await TeamsRepoImpl().getAllteams();

      // Filter teams by both team name and village
      List<Team?> filteredTeams = teams.where((team) {
        if (team == null) return false;

        final teamName = team.teamName.toLowerCase();
        final village = team.village.toLowerCase();
        final query = event.query.toLowerCase().trim();

        return teamName.contains(query) || village.contains(query);
      }).toList();

      emit(SearchedTeams(filteredTeams: filteredTeams));
    } catch (error) {
      emit(SearchingTeamsError(message: 'Failed to search teams: $error'));
    }
  }
}
