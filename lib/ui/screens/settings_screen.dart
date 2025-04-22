import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../data/models/pomodoro_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late PomodoroSettings _settings;
  late TextEditingController _focusDurationController;
  late TextEditingController _shortBreakController;
  late TextEditingController _longBreakController;
  late TextEditingController _sessionsBeforeLongBreakController;
  
  @override
  void initState() {
    super.initState();
    _settings = Provider.of<SettingsProvider>(context, listen: false).settings;
    
    _focusDurationController = TextEditingController(text: _settings.focusDuration.toString());
    _shortBreakController = TextEditingController(text: _settings.shortBreakDuration.toString());
    _longBreakController = TextEditingController(text: _settings.longBreakDuration.toString());
    _sessionsBeforeLongBreakController = TextEditingController(text: _settings.sessionsBeforeLongBreak.toString());
  }
  
  @override
  void dispose() {
    _focusDurationController.dispose();
    _shortBreakController.dispose();
    _longBreakController.dispose();
    _sessionsBeforeLongBreakController.dispose();
    super.dispose();
  }
  
  void _saveSettings() {
    final newSettings = _settings.copyWith(
      focusDuration: int.tryParse(_focusDurationController.text) ?? _settings.focusDuration,
      shortBreakDuration: int.tryParse(_shortBreakController.text) ?? _settings.shortBreakDuration,
      longBreakDuration: int.tryParse(_longBreakController.text) ?? _settings.longBreakDuration,
      sessionsBeforeLongBreak: int.tryParse(_sessionsBeforeLongBreakController.text) ?? _settings.sessionsBeforeLongBreak,
    );
    
    Provider.of<SettingsProvider>(context, listen: false).updateSettings(newSettings);
    Navigator.of(context).pop();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Timer Duration'),
          _buildDurationInput(
            label: 'Focus Time (minutes)',
            controller: _focusDurationController,
            icon: Icons.timer,
            iconColor: Colors.red,
          ),
          _buildDurationInput(
            label: 'Short Break (minutes)',
            controller: _shortBreakController,
            icon: Icons.coffee,
            iconColor: Colors.green,
          ),
          _buildDurationInput(
            label: 'Long Break (minutes)',
            controller: _longBreakController,
            icon: Icons.hotel,
            iconColor: Colors.blue,
          ),
          _buildDurationInput(
            label: 'Sessions Before Long Break',
            controller: _sessionsBeforeLongBreakController,
            icon: Icons.repeat,
            iconColor: Colors.purple,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Behavior'),
          SwitchListTile(
            title: const Text('Auto-start Breaks'),
            subtitle: const Text('Automatically start breaks after focus sessions'),
            value: _settings.autoStartBreaks,
            onChanged: (value) {
              setState(() {
                _settings = _settings.copyWith(autoStartBreaks: value);
              });
            },
          ),
          SwitchListTile(
            title: const Text('Auto-start Focus'),
            subtitle: const Text('Automatically start focus after breaks'),
            value: _settings.autoStartPomodoros,
            onChanged: (value) {
              setState(() {
                _settings = _settings.copyWith(autoStartPomodoros: value);
              });
            },
          ),
          SwitchListTile(
            title: const Text('Show Notifications'),
            subtitle: const Text('Get notified when timer ends'),
            value: _settings.showNotifications,
            onChanged: (value) {
              setState(() {
                _settings = _settings.copyWith(showNotifications: value);
              });
            },
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _settings = PomodoroSettings();
                  _focusDurationController.text = _settings.focusDuration.toString();
                  _shortBreakController.text = _settings.shortBreakDuration.toString();
                  _longBreakController.text = _settings.longBreakDuration.toString();
                  _sessionsBeforeLongBreakController.text = _settings.sessionsBeforeLongBreak.toString();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Reset to Defaults'),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
  
  Widget _buildDurationInput({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}