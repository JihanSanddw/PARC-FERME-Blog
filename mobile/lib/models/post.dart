class Post {
  final int idPost;
  final String title;
  final String? slug;
  final String? excerpt;
  final String content;
  final String? image;

  final int idCategory;
  final String category;

  final int idAuthor;
  final String author;

  final int? idDriver;
  final String? driver;

  final int? idTeam;
  final String? team;

  final int? idRace;
  final String? race;
  final String? circuit;
  final String? raceDate;

  final bool isFeatured;

  Post({
    required this.idPost,
    required this.title,
    this.slug,
    this.excerpt,
    required this.content,
    this.image,
    required this.idCategory,
    required this.category,
    required this.idAuthor,
    required this.author,
    this.idDriver,
    this.driver,
    this.idTeam,
    this.team,
    this.idRace,
    this.race,
    this.circuit,
    this.raceDate,
    required this.isFeatured,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      idPost: json['id_post'],
      title: json['title'],
      slug: json['slug'],
      excerpt: json['excerpt'],
      content: json['content'],
      image: json['image'],

      idCategory: json['id_category'],
      category: json['category'],

      idAuthor: json['id_author'],
      author: json['author'],

      idDriver: json['id_driver'],
      driver: json['driver'],

      idTeam: json['id_team'],
      team: json['team'],

      idRace: json['id_race'],
      race: json['race'],
      circuit: json['circuit'],
      raceDate: json['race_date'],

      isFeatured: json['is_featured'] == 1 || json['is_featured'] == true,
    );
  }
}
