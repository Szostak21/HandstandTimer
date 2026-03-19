import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
            child: Text(
              'Settings',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _SectionHeader(title: 'Detection', theme: theme),
          _SettingsTile(
            icon: Icons.sensors,
            title: 'Confidence Threshold',
            subtitle: '75%',
            colorScheme: colorScheme,
            theme: theme,
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.camera_front_outlined,
            title: 'Camera Selection',
            subtitle: 'Front camera',
            colorScheme: colorScheme,
            theme: theme,
            onTap: () {},
          ),

          const SizedBox(height: 16),
          _SectionHeader(title: 'Timer', theme: theme),
          _SettingsTile(
            icon: Icons.vibration,
            title: 'Haptic Feedback',
            subtitle: 'Vibrate on start & stop',
            colorScheme: colorScheme,
            theme: theme,
            trailing: Switch(value: true, onChanged: (_) {}),
          ),
          _SettingsTile(
            icon: Icons.volume_up_outlined,
            title: 'Sound Effects',
            subtitle: 'Play audio cues',
            colorScheme: colorScheme,
            theme: theme,
            trailing: Switch(value: false, onChanged: (_) {}),
          ),

          const SizedBox(height: 16),
          _SectionHeader(title: 'Data', theme: theme),
          _SettingsTile(
            icon: Icons.delete_outline,
            title: 'Clear All Sessions',
            subtitle: 'Remove all saved data',
            colorScheme: colorScheme,
            theme: theme,
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.file_download_outlined,
            title: 'Export Data',
            subtitle: 'Save sessions as CSV',
            colorScheme: colorScheme,
            theme: theme,
            onTap: () {},
          ),

          const SizedBox(height: 16),
          _SectionHeader(title: 'About', theme: theme),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'Version',
            subtitle: '0.1.0 — Phase 1 Skeleton',
            colorScheme: colorScheme,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.theme});

  final String title;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
      child: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colorScheme,
    required this.theme,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      leading: Icon(icon, color: colorScheme.primary.withAlpha(180)),
      title: Text(title, style: theme.textTheme.bodyLarge),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurface.withAlpha(120),
        ),
      ),
      trailing: trailing ??
          (onTap != null
              ? Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurface.withAlpha(60),
                )
              : null),
      onTap: onTap,
    );
  }
}
