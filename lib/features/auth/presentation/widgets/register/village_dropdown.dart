import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';
import 'package:alai_oosai/features/auth/data/village_model.dart';

/// Dropdown field for selecting the user's registered home village.
/// Matches the pill/rounded-rect input style of FamilyRegInputField.

class VillageDropdown extends StatefulWidget {
  final String? selectedVillage;
  final List<VillageModel> villages;
  final ValueChanged<String?> onChanged;
  final bool isLoading;

  const VillageDropdown({
    super.key,
    required this.selectedVillage,
    required this.villages,
    required this.onChanged,
    this.isLoading = false,
  });

  @override
  State<VillageDropdown> createState() => VillageDropdownState();
}

class VillageDropdownState extends State<VillageDropdown> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label — same style as FamilyRegInputField label
        const Text(
          'HOME VILLAGE',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AuthColors.primaryLabel,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 14),
        // If API is loading, show a compact loading row instead of the dropdown
        if (widget.isLoading)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: colors.inputBg,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: [
                const SizedBox(width: 4),
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation(AuthColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Loading villages...',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: colors.inputPlaceholder,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          // Dropdown trigger
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: colors.inputBg,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: _isOpen
                    ? AuthColors.primary.withAlpha(128)
                    : Colors.transparent,
                width: _isOpen ? 1.5 : 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: false,
                child: DropdownButton<String>(
                  value: widget.selectedVillage,
                  isExpanded: true,
                  isDense: false,
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 18),
                    child: AnimatedRotation(
                      turns: _isOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: _isOpen
                            ? AuthColors.primary
                            : colors.onSurfaceMuted,
                        size: 22,
                      ),
                    ),
                  ),
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 22),
                    child: Text(
                      'Select your home village',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: colors.inputPlaceholder,
                      ),
                    ),
                  ),
                  selectedItemBuilder: (context) {
                    return widget.villages.map((village) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 22),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            village.name,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: colors.onSurface,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      );
                    }).toList();
                  },
                  onTap: () => setState(() => _isOpen = !_isOpen),
                  onChanged: (value) {
                    setState(() => _isOpen = false);
                    widget.onChanged(value);
                  },
                  dropdownColor: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  elevation: 4,
                  menuMaxHeight: 260,
                  items: widget.villages.map((village) {
                    final isSelected = village.id == widget.selectedVillage;
                    return DropdownMenuItem<String>(
                      value: village.id,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AuthColors.primary.withAlpha(20)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: isSelected
                                  ? AuthColors.primary
                                  : colors.onSurfaceMuted,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                village.name,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? AuthColors.primary
                                      : colors.onSurface,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_rounded,
                                color: AuthColors.primary,
                                size: 16,
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        const SizedBox(height: 6),
        // Helper text
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Icon(
                Icons.info_outline,
                color: colors.onSurfaceMuted,
                size: 13,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Select the village where your family trust is registered.',
                style: TextStyle(
                  fontSize: 11,
                  color: colors.onSurfaceMuted,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
