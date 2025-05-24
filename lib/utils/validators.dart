String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return 'Email is required';
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Password is required';
  if (value.length < 6) return 'Password must be at least 6 characters';
  return null;
}

String? confirmPassword(String? confirm, String original) {
  if (confirm != original) return 'Passwords do not match';
  return null;
}

String? validatePhoneNumber(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Phone number is required';
  }

  final pattern = RegExp(r'^\+601[0-46-9]\d{7,8}$');

  if (!pattern.hasMatch(value.trim())) {
    return 'Enter a valid Malaysian phone number';
  }
  return null;
}

