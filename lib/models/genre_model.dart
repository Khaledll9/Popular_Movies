class GenreModel {
  final int id;
  final String name;
  GenreModel({required this.id, required this.name});

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(id: json['id'], name: json['name']);
  }
  @override
  String toString() {
    return "MoviesGenre(id: $id, name: $name)";
  }
}
