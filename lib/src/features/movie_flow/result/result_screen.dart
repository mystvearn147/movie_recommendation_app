import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movie_recommendation_app/src/core/constants.dart';
import 'package:movie_recommendation_app/src/core/failure.dart';
import 'package:movie_recommendation_app/src/core/widgets/failure_screen.dart';
import 'package:movie_recommendation_app/src/core/widgets/network_fading_image.dart';
import 'package:movie_recommendation_app/src/core/widgets/primary_button.dart';
import 'package:movie_recommendation_app/src/features/movie_flow/movie_flow_controller.dart';
import 'package:movie_recommendation_app/src/features/movie_flow/result/movie.dart';

class CoverImage extends StatelessWidget {
  const CoverImage({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(minHeight: 298.0),
        child: ShaderMask(
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromLTRB(
              0.0,
              0.0,
              rect.width,
              rect.height,
            ),
          ),
          blendMode: BlendMode.dstIn,
          child: NetworkFadingImage(path: movie.backdropPath ?? ''),
        ),
      );
}

class MovieImageDetails extends ConsumerWidget {
  const MovieImageDetails({
    Key? key,
    required this.movie,
    required this.movieHeight,
    required this.titleOpacity,
    required this.ratingOpacity,
    required this.genreOpacity,
  }) : super(key: key);

  final Movie movie;
  final double movieHeight;
  final Animation<double> titleOpacity;
  final Animation<double> genreOpacity;
  final Animation<double> ratingOpacity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          SizedBox(
            width: 100.0,
            height: movieHeight,
            child: NetworkFadingImage(path: movie.posterPath ?? ''),
          ),
          const SizedBox(width: kMediumSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeTransition(
                  opacity: titleOpacity,
                  child: Text(
                    movie.title,
                    style: theme.textTheme.headline6,
                  ),
                ),
                FadeTransition(
                  opacity: genreOpacity,
                  child: Text(
                    movie.genresCommaSeparated,
                    style: theme.textTheme.bodyText2,
                  ),
                ),
                FadeTransition(
                  opacity: ratingOpacity,
                  child: Row(
                    children: [
                      Text(
                        movie.voteAverage.toString(),
                        style: theme.textTheme.bodyText2?.copyWith(
                          color: theme.textTheme.bodyText2?.color
                              ?.withOpacity(0.62),
                        ),
                      ),
                      const Icon(
                        Icons.star_rounded,
                        size: 20.0,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResultScreenAnimator extends StatefulWidget {
  const ResultScreenAnimator({Key? key}) : super(key: key);

  @override
  createState() => _ResultScreenAnimatorState();
}

class _ResultScreenAnimatorState extends State<ResultScreenAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ResultScreen(animationController: _controller);
}

class ResultScreen extends ConsumerWidget {
  ResultScreen({
    Key? key,
    required this.animationController,
  })  : titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.0, 0.3),
          ),
        ),
        genreOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.3, 0.4),
          ),
        ),
        ratingOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.4, 0.6),
          ),
        ),
        descriptionOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.6, 0.8),
          ),
        ),
        buttonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.8, 1.0),
          ),
        ),
        super(key: key);

  static route({bool fullscreenDialog = true}) => MaterialPageRoute(
        builder: (context) => const ResultScreenAnimator(),
        fullscreenDialog: fullscreenDialog,
      );

  final AnimationController animationController;
  final Animation<double> titleOpacity;
  final Animation<double> genreOpacity;
  final Animation<double> ratingOpacity;
  final Animation<double> descriptionOpacity;
  final Animation<double> buttonOpacity;

  final double movieHeight = 150.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(movieFlowControllerProvider).movie.when(
            data: (movie) => Scaffold(
              appBar: AppBar(),
              body: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CoverImage(movie: movie),
                            Positioned(
                              width: MediaQuery.of(context).size.width,
                              bottom: (movieHeight / 2) * -1,
                              child: MovieImageDetails(
                                movie: movie,
                                movieHeight: movieHeight,
                                titleOpacity: titleOpacity,
                                ratingOpacity: ratingOpacity,
                                genreOpacity: genreOpacity,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: movieHeight / 2),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: FadeTransition(
                            opacity: descriptionOpacity,
                            child: Text(
                              movie.overview,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FadeTransition(
                    opacity: buttonOpacity,
                    child: PrimaryButton(
                      onPressed: () => Navigator.of(context).pop(),
                      text: 'Find another movie',
                    ),
                  ),
                  const SizedBox(height: kMediumSpacing),
                ],
              ),
            ),
            loading: () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stacktrace) => (error is Failure)
                ? FailureScreen(message: error.message)
                : const FailureScreen(
                    message: 'Something went wrong on our end',
                  ),
          );
}
