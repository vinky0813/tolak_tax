import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tolak_tax/services/auth_service.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  int _currentStep = 0;

  String? _selectedAvatar;

  final List<String> stepTitles = [
    'Enter Your Display Name!',
    'Select Your Avatar!',
    'Review and Confirm',
  ];

  // https://www.dicebear.com/playground/
  final List<String> _avatarOptions = [
    'https://api.dicebear.com/9.x/adventurer/svg?seed=Emery',
    'https://api.dicebear.com/9.x/adventurer/svg?seed=Christopher',
    'https://api.dicebear.com/9.x/adventurer/svg?seed=Adrian',
    'https://api.dicebear.com/9.x/adventurer/svg?seed=Destiny',
    'https://api.dicebear.com/9.x/adventurer/svg?seed=Jude',
    'https://api.dicebear.com/9.x/adventurer/svg?seed=Mason',
    'https://api.dicebear.com/9.x/adventurer/svg?seed=Vivian',
    'https://api.dicebear.com/9.x/adventurer/svg?seed=Maria',
    'https://api.dicebear.com/9.x/adventurer/svg?seed=Sophia',
    'https://api.dicebear.com/9.x/adventurer/svg?seed=Nolan',
    'https://api.dicebear.com/9.x/adventurer/svg?seed=Jameson',
    'https://api.dicebear.com/9.x/adventurer/svg?seed=Maria',
    'https://api.dicebear.com/9.x/adventurer/svg?seed=Sara',
    'https://api.dicebear.com/9.x/adventurer/svg?seed=Aiden',
    'https://api.dicebear.com/9.x/adventurer/svg?seed=Ryan',
    'https://api.dicebear.com/9.x/adventurer/svg?seed=Liam',
  ];

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentStep == 0 && !_formKey.currentState!.validate()) {
      return;
    }

    if (_currentStep == 1 && _selectedAvatar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select an avatar to continue.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (_currentStep < stepTitles.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _onBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _onFinish() async {
    final _authService = Provider.of<AuthService>(context, listen: false);
    final String displayName = _displayNameController.text.trim();
    final String? avatarUrl = _selectedAvatar;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try{
      final User? user = _authService.currentUser;

      if (user == null) {
        throw Exception('No user is currently signed in.');
      }

      await user.updateDisplayName(displayName);
      await user.updatePhotoURL(avatarUrl);

      await user.reload();

      if (kDebugMode) {
        final updatedUser = _authService.currentUser;
        print('Profile updated successfully for: ${updatedUser?.displayName}');
        print('New photo URL: ${updatedUser?.photoURL}');
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('An unexpected error occurred. Please try again.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      debugPrint('Generic Exception: $e');
    }

    Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLastStep = _currentStep == stepTitles.length - 1;

    final ScrollPhysics scrollPhysics = _currentStep == 1
        ? const ClampingScrollPhysics()
        : const NeverScrollableScrollPhysics();

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          physics: scrollPhysics,
          slivers: [
            SliverAppBar(
              surfaceTintColor: colorScheme.primary,
              backgroundColor: colorScheme.primary,
              expandedHeight: 170,
              pinned: true,
              stretch: true,
              automaticallyImplyLeading: false,
              leading: _currentStep > 0
                  ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _onBack)
                  : null,
              flexibleSpace: FlexibleSpaceBar(
                title: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Row(
                    key: ValueKey<int>(_currentStep),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularStepProgressIndicator(
                        totalSteps: stepTitles.length,
                        currentStep: _currentStep + 1,
                        stepSize: 5,
                        selectedColor: colorScheme.onPrimary,
                        unselectedColor: colorScheme.onPrimary.withOpacity(0.4),
                        padding: 0,
                        width: 32,
                        height: 32,
                        roundedCap: (_, __) => true,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        stepTitles[_currentStep],
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              fillOverscroll: true,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      bottom: 88,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                        child: KeyedSubtree(
                          key: ValueKey<int>(_currentStep),
                          child: _buildStepContent(_currentStep, theme, colorScheme),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: _buildNavigation(
                            isLastStep: isLastStep,
                            colorScheme: colorScheme),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(int step, ThemeData theme, ColorScheme colorScheme) {
    switch (step) {
      case 0:
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            key: const ValueKey(0),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'First, what should everyone call you?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _displayNameController,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Display name cannot be empty.'
                    : null,
                autofocus: true,
              ),
            ],
          ),
        );
      case 1:
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _avatarOptions.length,
            itemBuilder: (context, index) {
              final avatarUrl = _avatarOptions[index];
              final isSelected = _selectedAvatar == avatarUrl;

              return GestureDetector(
                onTap: () => setState(() => _selectedAvatar = avatarUrl),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                  ),
                  child: ClipOval(
                    child: SvgPicture.network(
                      avatarUrl,
                      placeholderBuilder: (context) => const Center(
                          child: CircularProgressIndicator.adaptive(strokeWidth: 2)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      case 2:
        return Column(
          key: const ValueKey(2),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              child: _selectedAvatar != null
                  ? ClipOval(child: SvgPicture.network(_selectedAvatar!))
                  : const Icon(Icons.person, size: 60),
            ),
            const SizedBox(height: 24),
            Text(
              _displayNameController.text,
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Looking good! Ready to get started?',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        );
      default:
        return Container();
    }
  }

  Widget _buildNavigation(
      {required bool isLastStep, required ColorScheme colorScheme}) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isLastStep ? _onFinish : _onNext,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          backgroundColor: isLastStep ? Colors.green : colorScheme.primary,
        ),
        child: Text(isLastStep ? 'Finish & Create Profile' : 'Next'),
      ),
    );
  }
}
