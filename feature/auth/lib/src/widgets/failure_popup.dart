import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

@RoutePage()
class FailurePopupView extends StatelessWidget {
  final String exceptionMessage;
  const FailurePopupView({super.key, required this.exceptionMessage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router.pop();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Icon(
                    Icons.error_outline,
                    size: 42,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Something went wrong!',
                  ),
                  const SizedBox(height: 20),
                  Text(exceptionMessage),
                  const SizedBox(height: 10),
                  const Text('Please try again.'),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        context.router.pop();
                      },
                      child: const Text(
                        'OK',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
