import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movie_recommendation_app/src/core/constants.dart';
import 'package:movie_recommendation_app/src/core/widgets/primary_button.dart';
import 'package:movie_recommendation_app/src/features/movie_flow/movie_flow_controller.dart';
import 'package:movie_recommendation_app/src/features/movie_flow/result/movie.dart';

class CoverImage extends StatelessWidget {
  const CoverImage({Key? key}) : super(key: key);

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
          child: const Placeholder(),
        ),
      );
}

class MovieImageDetails extends ConsumerWidget {
  const MovieImageDetails({
    Key? key,
    required this.movie,
    required this.movieHeight,
  }) : super(key: key);

  final Movie movie;
  final double movieHeight;

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
            child: const Placeholder(),
          ),
          const SizedBox(width: kMediumSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: theme.textTheme.headline6,
                ),
                Text(
                  movie.genresCommaSeparated,
                  style: theme.textTheme.bodyText2,
                ),
                Row(
                  children: [
                    Text(
                      movie.voteAverage.toString(),
                      style: theme.textTheme.bodyText2?.copyWith(
                        color:
                            theme.textTheme.bodyText2?.color?.withOpacity(0.62),
                      ),
                    ),
                    const Icon(
                      Icons.star_rounded,
                      size: 20.0,
                      color: Colors.amber,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResultScreen extends ConsumerWidget {
  const ResultScreen({Key? key}) : super(key: key);

  static route({bool fullscreenDialog = true}) => MaterialPageRoute(
        builder: (context) => const ResultScreen(),
      );

  final double movieHeight = 150.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const CoverImage(),
                      Positioned(
                        width: MediaQuery.of(context).size.width,
                        bottom: (movieHeight / 2) * -1,
                        child: MovieImageDetails(
                          movie: ref.watch(movieFlowControllerProvider).movie,
                          movieHeight: movieHeight,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: movieHeight / 2),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      ref.watch(movieFlowControllerProvider).movie.overview,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
            ),
            PrimaryButton(
              onPressed: () => Navigator.of(context).pop(),
              text: 'Find another movie',
            ),
            const SizedBox(height: kMediumSpacing),
          ],
        ),
      );
}
