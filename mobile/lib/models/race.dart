class Race {
  final int idRace;
  final String grandPrix;
  final String circuit;
  final String country;
  final int round;
  final String raceDate;
  final bool isSprint;

  Race({
    required this.idRace,
    required this.grandPrix,
    required this.circuit,
    required this.country,
    required this.round,
    required this.raceDate,
    required this.isSprint,
  });

  factory Race.fromJson(Map<String, dynamic> json) {
    return Race(
      idRace: json['id_race'],
      grandPrix: json['grand_prix'],
      circuit: json['circuit'],
      country: json['country'],
      round: json['round'],
      raceDate: json['race_date'].toString(),
      isSprint: json['is_sprint'] == 1 ||
          json['is_sprint'] == true,
    );
  }
}