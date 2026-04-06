import 'package:flutter/material.dart';
import 'package:alai_oosai/core/constants/app_constants.dart';
import 'package:alai_oosai/features/auth/data/auth_service.dart';
import 'package:alai_oosai/features/profile/data/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _profile;
  bool _isLoading = true;
  String? _error;
  bool _isEditing = false;
  bool _isSaving = false;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final profile = await ProfileService.fetchProfile();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _nameCtrl.text = profile.name;
        _emailCtrl.text = profile.email ?? '';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty')),
      );
      return;
    }
    setState(() => _isSaving = true);
    try {
      final updated = await ProfileService.updateProfile(
        name: name,
        email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      );
      if (!mounted) return;
      AuthService.userName = updated.name;
      setState(() {
        _profile = updated;
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red.shade600,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _nameCtrl.text = _profile?.name ?? '';
      _emailCtrl.text = _profile?.email ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.slate900,
          ),
        ),
        actions: [
          if (_profile != null && !_isEditing)
            TextButton(
              onPressed: () => setState(() => _isEditing = true),
              child: const Text(
                'Edit',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? _ErrorView(error: _error!, onRetry: _loadProfile)
              : _ProfileBody(
                  profile: _profile!,
                  isEditing: _isEditing,
                  isSaving: _isSaving,
                  nameCtrl: _nameCtrl,
                  emailCtrl: _emailCtrl,
                  onSave: _saveProfile,
                  onCancel: _cancelEdit,
                ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final UserProfile profile;
  final bool isEditing;
  final bool isSaving;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const _ProfileBody({
    required this.profile,
    required this.isEditing,
    required this.isSaving,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          // Avatar circle
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            profile.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.slate900,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              profile.role.replaceAll('_', ' ').toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Info card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.slate100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate700,
                  ),
                ),
                const SizedBox(height: 16),
                // Phone (read-only)
                _InfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: profile.phone,
                  readOnly: true,
                ),
                const SizedBox(height: 14),
                // Name (editable)
                isEditing
                    ? _EditField(
                        icon: Icons.person_outline,
                        label: 'Name',
                        controller: nameCtrl,
                      )
                    : _InfoRow(
                        icon: Icons.person_outline,
                        label: 'Name',
                        value: profile.name,
                      ),
                const SizedBox(height: 14),
                // Email (editable)
                isEditing
                    ? _EditField(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                      )
                    : _InfoRow(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: profile.email?.isNotEmpty == true
                            ? profile.email!
                            : 'Not set',
                        muted: profile.email == null || profile.email!.isEmpty,
                      ),
              ],
            ),
          ),
          if (isEditing) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isSaving ? null : onCancel,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.slate300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.slate600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isSaving ? null : onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool readOnly;
  final bool muted;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.readOnly = false,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.slate100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppColors.slate500),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.slate400,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: muted ? AppColors.slate400 : AppColors.slate800,
                ),
              ),
            ],
          ),
        ),
        if (readOnly)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.slate100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Locked',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.slate400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

class _EditField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _EditField({
    required this.icon,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.slate800,
            ),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(
                fontSize: 12,
                color: AppColors.slate400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.slate200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.slate500, fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
