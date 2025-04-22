import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/statistics_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statistics = Provider.of<StatisticsProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Organizer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Study Organizer',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Boost your productivity with the Pomodoro technique',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            
            // Feature cards
            _buildFeatureCard(
              context,
              title: 'Pomodoro Timer',
              description: 'Stay focused with customizable timed study sessions',
              icon: Icons.timer,
              color: Colors.red,
              onTap: () {
                Navigator.pushNamed(context, '/timer');
              },
            ),
            
            _buildFeatureCard(
              context,
              title: 'Statistics',
              description: 'Track your progress and study habits',
              icon: Icons.bar_chart,
              color: Colors.blue,
              onTap: () {
                statistics.loadStatistics();
                Navigator.pushNamed(context, '/statistics');
              },
            ),
            
            _buildFeatureCard(
              context,
              title: 'Settings',
              description: 'Customize your Pomodoro timer and app preferences',
              icon: Icons.settings,
              color: Colors.green,
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 24),
            
            // Quick tips
            Text(
              'Quick Tips',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildTipCard(
              'The Pomodoro Technique involves working for 25 minutes followed by a 5-minute break.',
              Icons.lightbulb_outline,
            ),
            _buildTipCard(
              'After completing 4 pomodoros, take a longer break of 15-30 minutes.',
              Icons.lightbulb_outline,
            ),
            _buildTipCard(
              'Creating specific study topics helps you track where you spend your time.',
              Icons.lightbulb_outline,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTipCard(String tip, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.amber,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(tip),
          ),
        ],
      ),
    );
  }
}