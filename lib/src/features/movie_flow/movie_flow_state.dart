import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movie_recommendation_app/src/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendation_app/src/features/movie_flow/result/movie.dart';

@immutable
class MovieFlowState {
  final PageController pageController;
  final int rating;
  final int yearsBack;
  final AsyncValue<List<Genre>> genres;
  final AsyncValue<Movie> movie;

  const MovieFlowState({
    required this.pageController,
    required this.movie,
    required this.genres,
    this.rating = 5,
    this.yearsBack = 10,
  });

  MovieFlowState copyWith({
    PageController? pageController,
    int? rating,
    int? yearsBack,
    AsyncValue<List<Genre>>? genres,
    AsyncValue<Movie>? movie,
  }) =>
      MovieFlowState(
        pageController: pageController ?? this.pageController,
        rating: rating ?? this.rating,
        yearsBack: yearsBack ?? this.yearsBack,
        genres: genres ?? this.genres,
        movie: movie ?? this.movie,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovieFlowState &&
          other.pageController == pageController &&
          other.rating == rating &&
          other.yearsBack == yearsBack &&
          other.genres == genres &&
          other.movie == movie);

  @override
  int get hashCode =>
      pageController.hashCode ^
      rating.hashCode ^
      yearsBack.hashCode ^
      genres.hashCode ^
      movie.hashCode;
}
