import 'package:flutter/foundation.dart';

import 'package:movie_recommendation_app/src/features/movie_flow/genre/genre_entity.dart';

@immutable
class Genre {
  final String name;
  final bool isSelected;
  final int id;

  const Genre({
    required this.name,
    this.id = 0,
    this.isSelected = false,
  });

  factory Genre.fromEntity(GenreEntity entity) => Genre(
        name: entity.name,
        id: entity.id,
        isSelected: false,
      );

  Genre toggleSelected() => Genre(
        name: name,
        id: id,
        isSelected: !isSelected,
      );

  @override
  String toString() => 'Genre(name: $name, isSelected: $isSelected, id: $id)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Genre &&
          other.name == name &&
          other.isSelected == isSelected &&
          other.id == id);

  @override
  int get hashCode => name.hashCode ^ isSelected.hashCode ^ id.hashCode;
}
