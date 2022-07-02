import 'package:flutter/material.dart';

class BodyWidget extends StatelessWidget {
  const BodyWidget({
    required this.duration,
    required this.data,
    required this.responseSize,
    super.key,
  });

  final Duration duration;
  final Object? data;
  final String responseSize;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Function took ${duration.inMilliseconds} ms'),
              const SizedBox(height: 4),
              Text('Response size: $responseSize'),
              const SizedBox(height: 4),
              const Text('Response Data:'),
              const SizedBox(height: 4),
              Text(data.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
