import 'package:flutter/material.dart';

import 'package:movie_recommendation_app/src/core/constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.width = double.infinity,
    this.isLoading = false,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final double width;
  final bool isLoading;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius / 2),
            ),
            fixedSize: Size(
              width,
              48,
            ),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                )
              else
                Text(
                  text,
                  style: Theme.of(context).textTheme.button,
                ),
            ],
          ),
        ),
      );
}
