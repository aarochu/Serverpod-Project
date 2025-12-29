import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/preferences_service.dart';
import '../providers/demo_provider.dart';

/// Settings screen with organized sections
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String? _selectedTheme;
  String? _selectedTimeRange;
  bool _demoMode = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final theme = await PreferencesService.getThemeMode();
    final timeRange = await PreferencesService.getTimeRange();
    final demoMode = ref.read(demoModeProvider);
    
    setState(() {
      _selectedTheme = theme ?? 'system';
      _selectedTimeRange = timeRange ?? 'allTime';
      _demoMode = demoMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Appearance section
          _buildSection(
            context,
            'Appearance',
            [
              _buildThemeSelector(context),
              const Divider(),
            ],
          ),
          // Notifications section
          _buildSection(
            context,
            'Notifications',
            [
              SwitchListTile(
                title: const Text('Enable notifications'),
                subtitle: const Text('Receive notifications for review updates'),
                value: true, // TODO: Implement notification preferences
                onChanged: (value) {
                  // TODO: Save notification preference
                },
              ),
              const Divider(),
            ],
          ),
          // Demo section
          _buildSection(
            context,
            'Demo Mode',
            [
              SwitchListTile(
                title: const Text('Enable demo mode'),
                subtitle: const Text('Enable demo walkthrough and optimizations'),
                value: _demoMode,
                onChanged: (value) async {
                  await ref.read(demoModeProvider.notifier).setDemoMode(value);
                  setState(() {
                    _demoMode = value;
                  });
                },
              ),
              const Divider(),
            ],
          ),
          // Data section
          _buildSection(
            context,
            'Data',
            [
              ListTile(
                title: const Text('Clear cache'),
                subtitle: const Text('Clear cached data and preferences'),
                leading: const Icon(Icons.delete_outline),
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Clear Cache'),
                      content: const Text('Are you sure you want to clear all cached data?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  );
                  
                  if (confirmed == true) {
                    await PreferencesService.clearAll();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cache cleared')),
                      );
                    }
                  }
                },
              ),
              const Divider(),
            ],
          ),
          // About section
          _buildSection(
            context,
            'About',
            [
              ListTile(
                title: const Text('Version'),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                title: const Text('Team'),
                subtitle: const Text('Person 1 (Backend Lead) • Person 2 (Frontend Lead)'),
              ),
              ListTile(
                title: const Text('Hackathon'),
                subtitle: const Text('Serverpod 3 Hackathon 2025'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    return ExpansionTile(
      title: const Text('Theme'),
      subtitle: Text(_selectedTheme ?? 'System'),
      children: [
        RadioListTile<String>(
          title: const Text('Light'),
          value: 'light',
          groupValue: _selectedTheme,
          onChanged: (value) async {
            if (value != null) {
              await PreferencesService.setThemeMode(value);
              setState(() {
                _selectedTheme = value;
              });
            }
          },
        ),
        RadioListTile<String>(
          title: const Text('Dark'),
          value: 'dark',
          groupValue: _selectedTheme,
          onChanged: (value) async {
            if (value != null) {
              await PreferencesService.setThemeMode(value);
              setState(() {
                _selectedTheme = value;
              });
            }
          },
        ),
        RadioListTile<String>(
          title: const Text('System'),
          value: 'system',
          groupValue: _selectedTheme,
          onChanged: (value) async {
            if (value != null) {
              await PreferencesService.setThemeMode(value);
              setState(() {
                _selectedTheme = value;
              });
            }
          },
        ),
      ],
    );
  }
}

