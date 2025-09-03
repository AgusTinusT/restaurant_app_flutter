import 'package:flutter/material.dart';

class AuthNavigationTextButton extends StatelessWidget {
  final String mainText;
  final String buttonText;
  final VoidCallback onPressed;

  const AuthNavigationTextButton({
    super.key,
    required this.mainText,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(mainText),
        TextButton(onPressed: onPressed, child: Text(buttonText)),
      ],
    );
  }
}
