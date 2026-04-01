import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';
import 'package:alai_oosai/features/auth/data/family_member_model.dart';

const double _kCardRadius = 14.0;
const double _kAvatarSize = 52.0;

class MemberListItem extends StatelessWidget {
  final FamilyMemberModel member;
  final VoidCallback? onTap;

  const MemberListItem({super.key, required this.member, this.onTap});

  @override
  Widget build(BuildContext context) {
    switch (member.status) {
      case MemberStatus.selected:
        return _SelectedItem(member: member, onTap: onTap);
      case MemberStatus.selectable:
        return _SelectableItem(member: member, onTap: onTap);
      case MemberStatus.alreadyRegistered:
        return _AlreadyRegisteredItem(member: member);
      case MemberStatus.verificationPending:
        return _VerificationPendingItem(member: member, onTap: onTap);
    }
  }
}

class _SelectedItem extends StatelessWidget {
  final FamilyMemberModel member;
  final VoidCallback? onTap;

  const _SelectedItem({required this.member, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(_kCardRadius),
          border: Border.all(
            color: AuthColors.primary.withAlpha(128),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(color: AuthColors.primary.withAlpha(30), blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                _MemberAvatar(imageUrl: member.imageUrl, size: _kAvatarSize),
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AuthColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.surface, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                member.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            const Icon(
              Icons.radio_button_checked,
              color: AuthColors.primary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectableItem extends StatefulWidget {
  final FamilyMemberModel member;
  final VoidCallback? onTap;

  const _SelectableItem({required this.member, this.onTap});

  @override
  State<_SelectableItem> createState() => _SelectableItemState();
}

class _SelectableItemState extends State<_SelectableItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _pressed ? colors.surfaceContainer : colors.surface,
          borderRadius: BorderRadius.circular(_kCardRadius),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Row(
          children: [
            _MemberAvatar(imageUrl: widget.member.imageUrl, size: _kAvatarSize),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                widget.member.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            Icon(
              Icons.radio_button_unchecked,
              color: _pressed ? AuthColors.primary : colors.outlineVariant,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _AlreadyRegisteredItem extends StatelessWidget {
  final FamilyMemberModel member;

  const _AlreadyRegisteredItem({required this.member});

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return Opacity(
      opacity: 0.65,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(_kCardRadius),
          border: Border.all(color: colors.outlineVariant.withAlpha(80)),
        ),
        child: Row(
          children: [
            ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
              ]),
              child: _MemberAvatar(
                imageUrl: member.imageUrl,
                size: _kAvatarSize,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colors.onSurface,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Already registered',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF14532D).withAlpha(30),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFF16A34A).withAlpha(60),
                ),
              ),
              child: const Text(
                'Active',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4ADE80),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerificationPendingItem extends StatelessWidget {
  final FamilyMemberModel member;
  final VoidCallback? onTap;

  const _VerificationPendingItem({required this.member, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(_kCardRadius),
          border: Border.all(color: const Color(0xFFF59E0B).withAlpha(80)),
        ),
        child: Row(
          children: [
            _MemberAvatar(imageUrl: member.imageUrl, size: _kAvatarSize),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colors.onSurface,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tap to complete verification',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withAlpha(30),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFFF59E0B).withAlpha(100),
                ),
              ),
              child: const Text(
                'Verification\nPending',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFF59E0B),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const _MemberAvatar({required this.imageUrl, required this.size});

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: size,
        height: size,
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: colors.surfaceHigh),
              )
            : Container(color: colors.surfaceHigh),
      ),
    );
  }
}
