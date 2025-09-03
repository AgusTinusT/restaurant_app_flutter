import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/features/authentication/auth_service.dart';
import 'package:restaurant_app/features/authentication/models/user_model.dart'
    as app_user;
import 'package:restaurant_app/features/authentication/services/user_service.dart';
import 'package:restaurant_app/features/detail/ui/edit_profile_screen.dart';
import 'package:restaurant_app/features/favorite/provider/favorites_provider.dart';
import 'package:restaurant_app/features/setting/provider/local_notification_provider.dart';
import 'package:restaurant_app/features/setting/provider/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _showResetConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Reset Favorit?'),
          content: const Text(
            'Aksi ini akan menghapus semua restoran dari daftar favorit Anda. Aksi ini tidak dapat dibatalkan.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(
                'Reset',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onPressed: () {
                context.read<FavoritesProvider>().clearFavorites();
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Daftar favorit telah direset.'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _ProfileSection(),
        const Divider(),
        const _SectionHeader(title: 'Tampilan'),
        const _ThemeSelectionSection(),
        const Divider(),
        const _SectionHeader(title: 'Notifikasi'),
        const _NotificationToggleSection(),
        const Divider(),
        const _SectionHeader(title: 'Data Aplikasi'),
        _AppDataSection(onResetTap: _showResetConfirmationDialog),
        const Divider(),
        const _SectionHeader(title: 'Akun'),
        const _AccountSection(),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final userService = context.read<UserService>();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, authSnapshot) {
        final firebaseUser = authSnapshot.data;
        if (firebaseUser == null) {
          return const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person_outline)),
            title: Text('Pengguna tidak dikenal'),
            subtitle: Text('Silakan login kembali'),
          );
        }

        return FutureBuilder<app_user.User?>(
          future: userService.getUserProfile(firebaseUser.uid),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return ListTile(
                leading: const CircleAvatar(child: CircularProgressIndicator()),
                title: const Text('Memuat nama...'),
                subtitle: Text(firebaseUser.email ?? 'Memuat email...'),
              );
            }

            final userProfile = profileSnapshot.data;
            final displayName = userProfile?.name ?? 'Nama tidak diatur';
            final email =
                userProfile?.email ??
                firebaseUser.email ??
                'Email tidak ditemukan';

            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(displayName),
              subtitle: Text(email),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).pushNamed(EditProfileScreen.routeName);
              },
            );
          },
        );
      },
    );
  }
}

class _ThemeSelectionSection extends StatelessWidget {
  const _ThemeSelectionSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final themeOptions = [
          {'title': 'Light Mode', 'value': ThemeMode.light, 'subtitle': null},
          {'title': 'Dark Mode', 'value': ThemeMode.dark, 'subtitle': null},
          {
            'title': 'System Default',
            'value': ThemeMode.system,
            'subtitle': 'Mengikuti tema perangkat',
          },
        ];

        return Column(
          children:
              themeOptions.map((option) {
                return RadioListTile<ThemeMode>(
                  title: Text(option['title'] as String),
                  subtitle:
                      option['subtitle'] != null
                          ? Text(option['subtitle'] as String)
                          : null,
                  value: option['value'] as ThemeMode,
                  groupValue: themeProvider.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      themeProvider.changeTheme(value);
                    }
                  },
                );
              }).toList(),
        );
      },
    );
  }
}

class _NotificationToggleSection extends StatelessWidget {
  const _NotificationToggleSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalNotificationProvider>(
      builder: (context, localNotificationProvider, child) {
        return SwitchListTile(
          title: const Text('Daily Reminder'),
          subtitle: const Text('Rekomendasi restoran setiap jam 11 pagi'),
          value: localNotificationProvider.isDailyReminderActive,
          onChanged: (value) async {
            await localNotificationProvider.setDailyReminder(value);
          },
        );
      },
    );
  }
}

class _AppDataSection extends StatelessWidget {
  final VoidCallback onResetTap;

  const _AppDataSection({required this.onResetTap});

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    return ListTile(
      leading: Icon(Icons.delete_forever, color: errorColor),
      title: Text('Reset Daftar Favorit', style: TextStyle(color: errorColor)),
      onTap: onResetTap,
    );
  }
}

class _AccountSection extends StatelessWidget {
  const _AccountSection();

  Future<void> _logout(BuildContext context) async {
    final authService = context.read<AuthService>();
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text('Logout'),
      onTap: () => _logout(context),
    );
  }
}
