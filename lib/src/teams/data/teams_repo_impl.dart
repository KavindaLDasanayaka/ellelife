import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ellelife/src/teams/domain/entities/team.dart';
import 'package:ellelife/src/teams/domain/repo/team_repo.dart';

class TeamsRepoImpl extends TeamRepo {
  final CollectionReference _teamCollection = FirebaseFirestore.instance
      .collection("teams");

  @override
  Future<void> deleteTeam(String teamId) {
    // TODO: implement deleteTeam
    throw UnimplementedError();
  }

  @override
  Stream<List<Team?>> getCurrentteams() {
    try {
      return _teamCollection.snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => Team.fromJson(doc.data() as Map<String, dynamic>))
            .toList(),
      );
    } catch (err) {
      print("error in gettting all teams");
      throw Exception("error $err");
    }
  }

  @override
  Future<Team?> getTeamById(String teamId) async {
    try {
      final doc = await _teamCollection.doc(teamId).get();
      if (doc.exists) {
        return Team.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (error) {
      print('Error getting team: $error');
    }
    return null;
  }

  @override
  Future<void> saveTeam(Team team) async {
    try {
      final DocumentReference docref = await _teamCollection.add(team.toJson());

      final teamId = docref.id;

      final teamMap = team.toJson();
      teamMap["postId"] = teamId;

      await docref.set(teamMap);
    } catch (err) {
      print("Error in saving team $err");
      throw Exception("Error in saving team $err");
    }
  }

  @override
  Future<void> updateTeam(String teamId) {
    // TODO: implement updateTeam
    throw UnimplementedError();
  }

  @override
  Future<List<Team?>> getAllteams() async {
    try {
      final QuerySnapshot snapshot = await _teamCollection.get();

      return snapshot.docs
          .map((doc) => Team.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (err) {
      print("error in gettting all users");
      throw Exception("error $err");
    }
  }
}
