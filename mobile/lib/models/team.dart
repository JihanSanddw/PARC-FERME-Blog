class Team {
  final int idTeam;
  final String name;
  final String shortName;
  final String country;
  final String? logo;

  Team({
    required this.idTeam,
    required this.name,
    required this.shortName,
    required this.country,
    this.logo,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      idTeam: json['id_team'],
      name: json['name'],
      shortName: json['short_name'],
      country: json['country'],
      logo: json['logo'],
    );
  }
}