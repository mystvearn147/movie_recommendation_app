import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movie_recommendation_app/src/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendation_app/src/features/movie_flow/movie_repository.dart';
import 'package:movie_recommendation_app/src/features/movie_flow/result/movie.dart';

final movieServiceProvider = Provider<MovieService>((ref) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return TMDBMovieService(movieRepository);
});

abstract class MovieService {
  Future<List<Genre>> getGenres();
  Future<Movie> getRecommendedMovie(
    int rating,
    int yearsBack,
    List<Genre> genres, [
    DateTime? yearsBackFromDate,
  ]);
}

class TMDBMovieService implements MovieService {
  TMDBMovieService(this._movieRepository);

  final MovieRepository _movieRepository;

  @override
  Future<List<Genre>> getGenres() async {
    final genreEntities = await _movieRepository.getMovieGenres();
    return genreEntities.map(Genre.fromEntity).toList();
  }

  @override
  Future<Movie> getRecommendedMovie(
    int rating,
    int yearsBack,
    List<Genre> genres, [
    DateTime? yearsBackFromDate,
  ]) async {
    final date = yearsBackFromDate ?? DateTime.now();
    final year = date.year - yearsBack;
    final genreIds = genres.map((genre) => genre.id).toList().join(',');

    final movieEntities = await _movieRepository.getRecommendedMovies(
      rating.toDouble(),
      '$year-01-01',
      genreIds,
    );
    final movies = movieEntities
        .map((entity) => Movie.fromEntity(entity, genres))
        .toList();

    final rnd = Random();
    return movies[rnd.nextInt(movies.length)];
  }
}
