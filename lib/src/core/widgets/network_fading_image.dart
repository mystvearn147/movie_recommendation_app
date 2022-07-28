import 'package:flutter/material.dart';

class NetworkFadingImage extends StatelessWidget {
  const NetworkFadingImage({
    Key? key,
    required this.path,
  }) : super(key: key);

  final String path;

  @override
  Widget build(BuildContext context) => Image.network(
        path,
        fit: BoxFit.cover,
        frameBuilder: (
          BuildContext context,
          Widget child,
          int? frame,
          bool wasSynchronouslyLoaded,
        ) =>
            wasSynchronouslyLoaded
                ? child
                : AnimatedOpacity(
                    opacity: frame == null ? 0.0 : 1.0,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeOut,
                    child: child,
                  ),
        errorBuilder: (context, err, stacktrace) => const SizedBox(),
      );
}
