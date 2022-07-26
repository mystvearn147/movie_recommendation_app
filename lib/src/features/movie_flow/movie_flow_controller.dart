import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movie_recommendation_app/src/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendation_app/src/features/movie_flow/movie_flow_state.dart';
import 'package:movie_recommendation_app/src/features/movie_flow/movie_service.dart';
import 'package:movie_recommendation_app/src/features/movie_flow/result/movie.dart';

final movieFlowControllerProvider =
    StateNotifierProvider.autoDispose<MovieFlowController, MovieFlowState>(
        (ref) => MovieFlowController(
              MovieFlowState(
                pageController: PageController(),
                movie: AsyncValue.data(Movie.initial()),
                genres: const AsyncValue.data([]),
              ),
              ref.watch(movieServiceProvider),
            ));

class MovieFlowController extends StateNotifier<MovieFlowState> {
  MovieFlowController(MovieFlowState state, this._movieService) : super(state) {
    loadGenres();
  }

  final MovieService _movieService;

  void toggleSelected(Genre genre) {
    state = state.copyWith(
      genres: AsyncValue.data([
        for (final oldGenre in state.genres.asData!.value)
          (oldGenre == genre) ? oldGenre.toggleSelected() : oldGenre
      ]),
    );
  }

  void updateRating(int updatedRating) {
    state = state.copyWith(rating: updatedRating);
  }

  void updateYearsBack(int updatedYearsBack) {
    state = state.copyWith(yearsBack: updatedYearsBack);
  }

  void nextPage() {
    if (state.pageController.page! >= 1 &&
        !state.genres.asData!.value.any((genre) => genre.isSelected)) {
      return;
    }

    state.pageController.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  void previousPage() {
    state.pageController.previousPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> loadGenres() async {
    state = state.copyWith(genres: const AsyncValue.loading());

    final result = await _movieService.getGenres();
    state = state.copyWith(genres: AsyncValue.data(result));
  }

  Future<void> getRecommendedMovie() async {
    state = state.copyWith(movie: const AsyncValue.loading());

    final selectedGenres = state.genres.asData?.value
            .where((genre) => genre.isSelected)
            .toList(growable: false) ??
        [];
    final result = await _movieService.getRecommendedMovie(
      state.rating,
      state.yearsBack,
      selectedGenres,
    );
    state = state.copyWith(movie: AsyncValue.data(result));
  }

  @override
  void dispose() {
    state.pageController.dispose();
    super.dispose();
  }
}
