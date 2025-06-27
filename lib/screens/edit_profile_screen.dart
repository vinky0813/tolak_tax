import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tolak_tax/data/avatar_options.dart';
import '../services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _displayNameController;
  String? _selectedAvatarUrl;
  bool _isLoading = false;
  User? _currentUser;

  final List<String> avatarOptions = AvatarOptions;

  @override
  void initState() {
    super.initState();
    _currentUser = Provider.of<AuthService>(context, listen: false).currentUser;
    _displayNameController = TextEditingController(text: _currentUser?.displayName ?? '');
    _selectedAvatarUrl = _currentUser?.photoURL;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() { _isLoading = true; });
    try {
      if (_currentUser != null) {
        await _currentUser!.updateDisplayName(_displayNameController.text);
        if (_selectedAvatarUrl != null) {
          await _currentUser!.updatePhotoURL(_selectedAvatarUrl);
        }
        await _currentUser!.reload();
        _currentUser = Provider.of<AuthService>(context, listen: false).currentUser;
        await Provider.of<AuthService>(context, listen: false).refreshUser();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: ${e.message}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) { setState(() { _isLoading = false; }); }
    }
  }

  void _showAvatarSelectionDialog(ColorScheme colorScheme) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select an Avatar'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: avatarOptions.length,
              itemBuilder: (context, index) {
                final url = avatarOptions[index];
                return GestureDetector(
                  onTap: () {
                    setState(() { _selectedAvatarUrl = url; });
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    backgroundColor: colorScheme.surfaceVariant,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.network(
                        url,
                        placeholderBuilder: (context) => const CircularProgressIndicator(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final labelStyle = theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold);

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 120.0,
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Edit Profile',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              centerTitle: false,
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildAvatarSelector(colorScheme),
                      const SizedBox(height: 32),

                      Text('Display Name', style: labelStyle),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _displayNameController,
                        decoration: const InputDecoration(hintText: 'Enter your display name'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Display name cannot be empty.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      Text('Email Address', style: labelStyle),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: _currentUser?.email ?? 'No email provided',
                        readOnly: true,
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                        decoration: InputDecoration(
                          fillColor: colorScheme.surfaceVariant,
                          filled: true,
                          border: theme.inputDecorationTheme.border?.copyWith(borderSide: BorderSide.none),
                          enabledBorder: theme.inputDecorationTheme.border?.copyWith(borderSide: BorderSide.none),
                          focusedBorder: theme.inputDecorationTheme.border?.copyWith(borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 24),

                      if (_currentUser?.phoneNumber?.isNotEmpty ?? false) ...[
                        Text('Phone Number', style: labelStyle),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: _currentUser!.phoneNumber,
                          readOnly: true,
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                          decoration: InputDecoration(
                            fillColor: colorScheme.surfaceVariant,
                            filled: true,
                            border: theme.inputDecorationTheme.border?.copyWith(borderSide: BorderSide.none),
                            enabledBorder: theme.inputDecorationTheme.border?.copyWith(borderSide: BorderSide.none),
                            focusedBorder: theme.inputDecorationTheme.border?.copyWith(borderSide: BorderSide.none),
                          ),
                        ),
                      ],

                      const Spacer(),

                      ElevatedButton(
                        onPressed: _isLoading ? null : _updateProfile,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                            : const Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSelector(ColorScheme colorScheme) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: colorScheme.primary.withOpacity(0.1),
            child: _selectedAvatarUrl != null && _selectedAvatarUrl!.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: SvgPicture.network(
                _selectedAvatarUrl!,
                placeholderBuilder: (context) => const CircularProgressIndicator(),
              ),
            )
                : Icon(Icons.person, size: 60, color: colorScheme.primary),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => _showAvatarSelectionDialog(colorScheme),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.surface, width: 3),
                ),
                child: Icon(Icons.edit, color: colorScheme.onPrimary, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}