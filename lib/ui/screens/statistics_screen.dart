import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/statistics_provider.dart';
import '../../data/models/pomodoro_session.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Load statistics when the screen is first opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StatisticsProvider>(context, listen: false).loadStatistics();
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Summary'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          SummaryTab(),
          HistoryTab(),
        ],
      ),
    );
  }
}

class SummaryTab extends StatelessWidget {
  const SummaryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statisticsProvider = Provider.of<StatisticsProvider>(context);
    
    if (statisticsProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    final stats = statisticsProvider.statistics;
    final totalHours = (stats['totalDuration'] / 60).toStringAsFixed(1);
    final completionRate = stats['totalSessions'] > 0
        ? ((stats['completedSessions'] / stats['totalSessions']) * 100).toStringAsFixed(1)
        : '0';
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Study Summary',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          
          // Stats cards
          Row(
            children: [
              _buildStatCard(
                context,
                'Total Sessions',
                stats['totalSessions'].toString(),
                Icons.repeat,
                Colors.blue,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                context,
                'Total Hours',
                totalHours,
                Icons.access_time,
                Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard(
                context,
                'Completed',
                stats['completedSessions'].toString(),
                Icons.check_circle,
                Colors.orange,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                context,
                'Completion Rate',
                '$completionRate%',
                Icons.trending_up,
                Colors.purple,
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          Text(
            'Weekly Activity',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          
          // Weekly chart
          SizedBox(
            height: 200,
            child: _buildWeeklyChart(context, statisticsProvider),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildWeeklyChart(BuildContext context, StatisticsProvider provider) {
    final dailyData = provider.getDailyTotalsByWeek();
    final entries = dailyData.entries.toList();
    
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: dailyData.values.fold(0, (max, value) => value > max ? value : max) * 1.2,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value < 0 || value >= entries.length) return const Text('');
                return Text(entries[value.toInt()].key);
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()}');
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        barGroups: List.generate(entries.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: entries[index].value.toDouble(),
                color: Colors.blue,
                width: 12,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class HistoryTab extends StatelessWidget {
  const HistoryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statisticsProvider = Provider.of<StatisticsProvider>(context);
    final sessions = statisticsProvider.sessions;
    
    if (statisticsProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (sessions.isEmpty) {
      return const Center(
        child: Text('No sessions recorded yet'),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        return _buildSessionItem(context, sessions[index]);
      },
    );
  }
  
  Widget _buildSessionItem(BuildContext context, PomodoroSession session) {
    final date = session.startTime;
    final formattedDate = '${date.day}/${date.month}/${date.year}';
    final formattedTime = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: session.isCompleted ? Colors.green : Colors.red,
          child: Icon(
            session.isCompleted ? Icons.check : Icons.close,
            color: Colors.white,
          ),
        ),
        title: Text('${session.duration} min. session'),
        subtitle: Text('$formattedDate at $formattedTime'),
        trailing: Text(
          session.isCompleted ? 'Completed' : 'Incomplete',
          style: TextStyle(
            color: session.isCompleted ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}