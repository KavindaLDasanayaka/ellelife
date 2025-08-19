import 'dart:io';

import 'package:ellelife/src/teams/data/team_storage.dart';
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
    emit(TeamRegisteringState());

    try {
      String? imageUrl0;
      if (event.image != null) {
        final imageUrl = await TeamStorage().uploadImageToCloudinary(
          event.image!,
        );
        imageUrl0 = imageUrl!;
      }

      final Team team = Team(
        teamId: "",
        teamName: event.teamName,
        village: event.village,
        contactNo: event.contactNo,
        teamPhoto: imageUrl0 ?? "",
      );
      await TeamsRepoImpl().saveTeam(team);
    } catch (err) {
      throw Exception("Error in saving image $err");
    }
    emit(TeamRegisteredState());
  }
}
