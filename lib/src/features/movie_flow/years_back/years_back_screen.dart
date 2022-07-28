import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movie_recommendation_app/src/core/constants.dart';
import 'package:movie_recommendation_app/src/core/widgets/primary_button.dart';
import 'package:movie_recommendation_app/src/features/movie_flow/movie_flow_controller.dart';
import 'package:movie_recommendation_app/src/features/movie_flow/result/result_screen.dart';

class YearsBackScreen extends ConsumerWidget {
  const YearsBackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed:
              ref.read(movieFlowControllerProvider.notifier).previousPage,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'How many years back should we check for?',
              style: theme.textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ref.watch(movieFlowControllerProvider).yearsBack.toString(),
                  style: theme.textTheme.headline2,
                ),
                Text(
                  'Years back',
                  style: theme.textTheme.headline4?.copyWith(
                    color: theme.textTheme.headline4?.color?.withOpacity(0.62),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Slider(
              onChanged: (value) {
                ref
                    .read(movieFlowControllerProvider.notifier)
                    .updateYearsBack(value.toInt());
              },
              value:
                  ref.watch(movieFlowControllerProvider).yearsBack.toDouble(),
              min: 0.0,
              max: 70.0,
              divisions: 70,
              label:
                  ref.watch(movieFlowControllerProvider).yearsBack.toString(),
            ),
            const Spacer(),
            PrimaryButton(
              onPressed: () async {
                final navigator = Navigator.of(context);

                await ref
                    .read(movieFlowControllerProvider.notifier)
                    .getRecommendedMovie();

                navigator.push(ResultScreen.route());
              },
              text: 'Amazing',
              isLoading:
                  ref.watch(movieFlowControllerProvider).movie is AsyncLoading,
            ),
            const SizedBox(height: kMediumSpacing),
          ],
        ),
      ),
    );
  }
}
