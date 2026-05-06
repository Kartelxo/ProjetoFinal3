import 'package:flutter/material.dart';

/// A reusable, opinionated button used across the app.
///
/// Usage:
/// AppButton(onPressed: () {}, label: 'Save');
class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color? color;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final IconData? icon;

  const AppButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.color,
    this.textColor,
    this.padding,
    this.elevation,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, color: textColor ?? Colors.white) : const SizedBox.shrink(),
      label: Text(label, style: TextStyle(color: textColor ?? Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? theme.colorScheme.primary,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: elevation ?? 2,
        textStyle: theme.textTheme.labelLarge,
      ),
    );
  }
}
