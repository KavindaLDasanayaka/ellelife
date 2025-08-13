class Team {
  final String teamId;
  final String teamName;
  final String village;
  final int contactNo;
  final String teamPhoto;

  Team({
    required this.teamId,
    required this.teamName,
    required this.village,
    required this.contactNo,
    required this.teamPhoto,
  });

  Map<String, dynamic> toJson() {
    return {
      "teamName": teamName,
      "village": village,
      "contactNo": contactNo,
      "teamPhoto": teamPhoto,
    };
  }

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamId: json["teamId"] ?? "",
      teamName: json["teamName"],
      village: json["village"],
      contactNo: json["contactNo"],
      teamPhoto: json["teamPhoto"],
    );
  }
}
