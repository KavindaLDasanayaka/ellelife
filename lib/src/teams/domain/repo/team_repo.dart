import 'package:ellelife/src/teams/domain/entities/team.dart';

abstract class TeamRepo {
  Future<void> saveTeam(Team team);
  Future<void> deleteTeam(String teamId);
  Future<void> updateTeam(String teamId);
  Future<Team?> getTeamById(String teamId);
  Stream<List<Team?>> getCurrentteams();
  Future<List<Team?>> getAllteams();
}
