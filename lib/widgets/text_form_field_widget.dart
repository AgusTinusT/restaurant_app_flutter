import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/text_form_field_provider.dart';

class PrimaryTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputAction textInputAction;

  const PrimaryTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.isPassword = false,
    this.textInputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          TextFormFieldProvider()..setInitialObscureText(isPassword),
      child: Consumer<TextFormFieldProvider>(
        builder: (context, provider, child) {
          return TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: provider.obscureText,
            textInputAction: textInputAction,
            decoration: InputDecoration(
              labelText: labelText,
              prefixIcon: Icon(prefixIcon),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        provider.obscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        provider.toggleObscureText();
                      },
                    )
                  : null,
            ),
            validator: validator,
          );
        },
      ),
    );
  }
}
