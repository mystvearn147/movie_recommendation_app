import 'package:flutter/material.dart';

class FailureBody extends StatelessWidget {
  const FailureBody({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Text(message),
      );
}

class FailureScreen extends StatelessWidget {
  const FailureScreen({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: FailureBody(message: message),
      );
}
