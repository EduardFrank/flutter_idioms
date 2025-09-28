import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:idioms/repos/repo.dart';
import 'package:idioms/widgets/idiom_card.dart';
import 'package:idioms/widgets/idiom_dialog.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> with SingleTickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  int weekOffset = 0;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _previousDay() => setState(() => selectedDate = selectedDate.subtract(const Duration(days: 1)));
  void _nextDay() => setState(() => selectedDate = selectedDate.add(const Duration(days: 1)));
  void _previousWeek() => setState(() { weekOffset--; _animationController.forward(from: 0); });
  void _nextWeek() => setState(() { weekOffset++; _animationController.forward(from: 0); });

  List<Map<String, dynamic>> _getWeeklyData(Repo repo) {
    final today = DateTime.now();
    final monday = DateTime(today.year, today.month, today.day)
        .subtract(Duration(days: today.weekday - 1 - weekOffset * 7));

    List<Map<String, dynamic>> data = [];
    for (int i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));
      final idiomsLearned = repo.getIdiomsLearnedOnDate(day);
      
      data.add({
        'date': day,
        'learned': idiomsLearned.length,
      });
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = Provider.of<Repo>(context, listen: false);
    final idioms = repo.getIdiomsLearnedOnDate(selectedDate);
    final weeklyData = _getWeeklyData(repo);
    final idiomOfTheDay = repo.getIdiomOfTheDay();

    final maxY = (weeklyData.map((d) => d['learned'] as int).fold<int>(0, (a, b) => a > b ? a : b) + 1).toDouble();
    final weekStart = weeklyData.first['date'] as DateTime;
    final weekEnd = weeklyData.last['date'] as DateTime;

    // Prepare spots for line chart
    final learnedSpots  = List.generate(7, (i) => FlSpot(i.toDouble(), (weeklyData[i]['learned']  as int).toDouble()));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Streak display
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.orange, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Day streak: ${repo.calculateDayStreak(DateTime.now())} days',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Idiom of the day section
              InkWell(
                onTap: () {
                  if (idiomOfTheDay != null) {
                    showDialog(
                      context: context,
                      builder: (context) => IdiomDialog(
                        idiom: idiomOfTheDay,
                      ),
                    );
                  }
                },
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      border: Border.all(color: Colors.blue[200]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Idiom of the Day',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Builder(
                          builder: (context) {

                            if (idiomOfTheDay != null) {
                              return Text(
                                '"${idiomOfTheDay.idiom}" \n ${idiomOfTheDay.definition}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            } else {
                              return const Text(
                                'No new idioms available! Great job!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Top row: week navigation and selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(icon: const Icon(Icons.arrow_left), onPressed: _previousWeek),
                  GestureDetector(
                    onTap: _showDateWeekPicker, // <-- open modal
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              '${DateFormat('dd MMM').format(weekStart)} – ${DateFormat('dd MMM').format(weekEnd)}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.arrow_right), onPressed: _nextWeek),
                ],
              ),

              const SizedBox(height: 8),

              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendTile(Colors.blue, "Learned"),
                ],
              ),

              const SizedBox(height: 8),

              // Line chart
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: maxY,
                    gridData: FlGridData(show: true, horizontalInterval: 1, drawHorizontalLine: true, drawVerticalLine: false),
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const weekday = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                            if (value - (value.toInt().toDouble()) > 0.1) {
                              return Text('');
                            }

                            int index = value.toInt();
                            if (index >= 0 && index < 7) {
                              return Text(weekday[index], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true, interval: 1, reservedSize: 30),
                      ),
                    ),
                    lineBarsData: [
                      // Learned line
                      LineChartBarData(
                        spots: learnedSpots,
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [Colors.blue.withOpacity(0.3), Colors.blue.withOpacity(0.0)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      handleBuiltInTouches: true,
                      touchCallback: (event, response) {
                        if (response != null &&
                            response.lineBarSpots != null &&
                            response.lineBarSpots!.isNotEmpty) {
                          final index = response.lineBarSpots!.first.x.toInt();
                          setState(() {
                            selectedDate = weeklyData[index]['date'] as DateTime;
                          });
                        }
                      },
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (c) => Colors.black87,
                        getTooltipItems: (spots) {
                          return spots.map((spot) {
                            return LineTooltipItem(
                              '${spot.y.toInt()}',
                              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Date navigation row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(icon: const Icon(Icons.arrow_left), onPressed: _previousDay),
                  GestureDetector(
                    onTap: _showDateWeekPicker, // <-- open modal for date selection
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('dd MMM yyyy').format(selectedDate),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.arrow_right), onPressed: _nextDay),
                ],
              ),

              const SizedBox(height: 16),

              // Idioms list
              Column(
                children: idioms.map((idiom) {
                  return IdiomCard(
                    idiom: idiom,
                    progress: repo.getProgressByIdiom(idiom),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendTile(Color color, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _showDateWeekPicker() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        DateTime tempSelectedDate = selectedDate;
        int tempWeekOffset = weekOffset;

        return StatefulBuilder(builder: (context, setModalState) {
          return SizedBox(
            height: 400,
            child: Column(
              children: [
                // Tabs
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () => setModalState(() => _activeTab = 0),
                      child: Text('Day',
                          style: TextStyle(
                            fontWeight: _activeTab == 0 ? FontWeight.bold : FontWeight.normal,
                            fontSize: 16,
                          )),
                    ),
                    TextButton(
                      onPressed: () => setModalState(() => _activeTab = 1),
                      child: Text('Week',
                          style: TextStyle(
                            fontWeight: _activeTab == 1 ? FontWeight.bold : FontWeight.normal,
                            fontSize: 16,
                          )),
                    ),
                  ],
                ),
                const Divider(),

                Expanded(
                  child: _activeTab == 0
                  // Day picker
                      ? CalendarDatePicker(
                    initialDate: tempSelectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    onDateChanged: (date) => setModalState(() => tempSelectedDate = date),
                  )
                  // Week picker
                      : ListView.builder(
                    itemCount: 20, // show last 20 weeks
                    itemBuilder: (context, index) {
                      final monday = DateTime.now()
                          .subtract(Duration(days: DateTime.now().weekday - 1 + index * 7));
                      final sunday = monday.add(const Duration(days: 6));
                      return ListTile(
                        title: Text(
                            '${DateFormat('dd MMM').format(monday)} – ${DateFormat('dd MMM').format(sunday)}'),
                        onTap: () => setModalState(() => tempWeekOffset = -index),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel')),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (_activeTab == 0) {
                                selectedDate = tempSelectedDate;
                              } else {
                                weekOffset = tempWeekOffset;
                              }
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text('Select')),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  int _activeTab = 0; // 0 = Day, 1 = Week
}