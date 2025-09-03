import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/features/detail/ui/profile_provider.dart';
import 'package:restaurant_app/widgets/primary_submit_button_widget.dart';
import 'package:restaurant_app/widgets/text_form_field_widget.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = '/edit-profile';

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();

    final initialName = context.read<ProfileProvider>().userName ?? '';
    _nameController = TextEditingController(text: initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ProfileProvider>();
    final newName = _nameController.text;

    final success = await provider.updateUserName(newName);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Nama berhasil diperbarui!'),
            backgroundColor: Colors.green[600],
          ),
        );

        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Gagal memperbarui nama.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<ProfileProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PrimaryTextFormField(
                controller: _nameController,
                labelText: 'Nama Lengkap',
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 32),
              PrimarySubmitButton(
                text: 'SIMPAN PERUBAHAN',
                onPressed: _handleSave,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
