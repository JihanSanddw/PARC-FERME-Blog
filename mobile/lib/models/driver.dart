class Driver {
  final int idDriver;
  final String name;
  final String abbreviation;
  final String nationality;
  final int number;
  final int idTeam;
  final String? image;

  Driver({
    required this.idDriver,
    required this.name,
    required this.abbreviation,
    required this.nationality,
    required this.number,
    required this.idTeam,
    this.image,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      idDriver: json['id_driver'],
      name: json['name'],
      abbreviation: json['abbreviation'],
      nationality: json['nationality'],
      number: json['number'],
      idTeam: json['id_team'],
      image: json['image'],
    );
  }
}