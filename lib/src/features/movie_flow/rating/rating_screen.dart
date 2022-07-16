import 'package:flutter/material.dart';

import 'package:movie_recommendation_app/src/core/constants.dart';
import 'package:movie_recommendation_app/src/core/widgets/primary_button.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({
    Key? key,
    required this.nextPage,
    required this.previousPage,
  }) : super(key: key);

  final VoidCallback nextPage;
  final VoidCallback previousPage;

  @override
  createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double rating = 5.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: widget.previousPage),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'Select a minimum rating\nranging from 1 - 10',
              style: theme.textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  rating.ceil().toString(),
                  style: theme.textTheme.headline2,
                ),
                const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                  size: 62.0,
                ),
              ],
            ),
            const Spacer(),
            Slider(
              onChanged: (value) {
                setState(() {
                  rating = value;
                });
              },
              value: rating,
              min: 1.0,
              max: 10.0,
              divisions: 9,
              label: rating.ceil().toString(),
            ),
            const Spacer(),
            PrimaryButton(
              onPressed: widget.nextPage,
              text: 'Yes please',
            ),
            const SizedBox(height: kMediumSpacing),
          ],
        ),
      ),
    );
  }
}
