class PostModel {
  final String id;
  final String url;
  final String? description;
  final bool isFavorite;
  final String? type;

  PostModel({
    required this.id,
    required this.url,
    this.description,
    this.isFavorite = false,
    this.type,
  });

  PostModel copyWith({
    String? id,
    String? url,
    String? description,
    bool? isFavorite,
    String? type,
  }) {
    return PostModel(
      id: id ?? this.id,
      url: url ?? this.url,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      type: type ?? this.type,
    );
  }
}
