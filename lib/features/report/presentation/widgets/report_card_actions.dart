import 'package:flutter/material.dart';
import 'package:alai_oosai/core/constants/app_constants.dart';

class ReportCardActions extends StatelessWidget {
  final VoidCallback? onView;
  final VoidCallback? onDownload;

  const ReportCardActions({super.key, this.onView, this.onDownload});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: ReportActionButton(
              label: 'View PDF',
              icon: Icons.visibility_outlined,
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              onTap: onView,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ReportActionButton(
              label: 'Download',
              icon: Icons.download_outlined,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              onTap: onDownload,
            ),
          ),
        ],
      ),
    );
  }
}

class ReportActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback? onTap;

  const ReportActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    this.onTap,
  });

  @override
  State<ReportActionButton> createState() => ReportActionButtonState();
}

class ReportActionButtonState extends State<ReportActionButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isPressed
                ? widget.backgroundColor.withAlpha(200)
                : widget.backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 16, color: widget.foregroundColor),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: widget.foregroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
