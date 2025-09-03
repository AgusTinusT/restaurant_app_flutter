import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/features/authentication/auth_provider.dart';
import 'package:restaurant_app/features/authentication/screens/register_screen.dart';
import 'package:restaurant_app/widgets/auth_navigation_text_button.dart';
import 'package:restaurant_app/widgets/primary_submit_button_widget.dart';
import 'package:restaurant_app/widgets/text_form_field_widget.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signIn(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Login failed.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SvgPicture.asset(
                  'assets/images/undraw_breakfast_rgx5.svg',
                  height: 200,
                ),
                const SizedBox(height: 24),
                Text(
                  'Temukan hidangan lezat di dekat Anda!',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 48),
                PrimaryTextFormField(
                  controller: _emailController,
                  labelText: 'Email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Masukkan alamat email yang valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                PrimaryTextFormField(
                  controller: _passwordController,
                  labelText: 'Password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Password harus terdiri dari minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                PrimarySubmitButton(
                  text: 'LOGIN',
                  onPressed: _handleLogin,
                  isLoading: authProvider.state == AuthViewState.loading,
                ),
                const SizedBox(height: 24),

                AuthNavigationTextButton(
                  mainText: "Belum punya akun?",
                  buttonText: 'Daftar di sini',
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      RegisterScreen.routeName,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
