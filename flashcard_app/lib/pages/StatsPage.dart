import 'package:flashcard_app/models/FlashCard.dart';
import 'package:flashcard_app/models/FlashCardData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final flashCardData = Provider.of<FlashCardData>(context);
    final decks = flashCardData.flashCardsList;

    int totalReviews = decks.fold(0, (sum, card) => sum + card.reviews);
    int totalCards = decks.length;

    // Ratings Count
    int againCount = decks.where((card) => card.rating == Rating.Again).length;
    int hardCount = decks.where((card) => card.rating == Rating.Hard).length;
    int goodCount = decks.where((card) => card.rating == Rating.Good).length;
    int easyCount = decks.where((card) => card.rating == Rating.Easy).length;

    // Pie Chart Data
    final List<_ChartData> chartData = [
      _ChartData('Again', againCount, Colors.red),
      _ChartData('Hard', hardCount, Colors.orange),
      _ChartData('Good', goodCount, Colors.blue),
      _ChartData('Easy', easyCount, Colors.green),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Overview Section
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Overview",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Total Cards Reviewed: $totalReviews",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Total Cards: $totalCards",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: totalReviews / (totalCards > 0 ? totalCards : 1),
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.purple,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Review Progress: ${((totalReviews / (totalCards > 0 ? totalCards : 1)) * 100).toStringAsFixed(1)}%",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Pie Chart Section
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Rating Distribution",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SfCircularChart(
                      legend: Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap,
                        position: LegendPosition.bottom,
                      ),
                      series: <PieSeries<_ChartData, String>>[
                        PieSeries<_ChartData, String>(
                          dataSource: chartData,
                          xValueMapper: (_ChartData data, _) => data.label,
                          yValueMapper: (_ChartData data, _) => data.value,
                          pointColorMapper: (_ChartData data, _) => data.color,
                          dataLabelMapper: (_ChartData data, _) => "${data.value}",
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Rating Breakdown Section
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Rating Breakdown",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildRatingRow("Again", againCount, Colors.red),
                    const Divider(),
                    _buildRatingRow("Hard", hardCount, Colors.orange),
                    const Divider(),
                    _buildRatingRow("Good", goodCount, Colors.blue),
                    const Divider(),
                    _buildRatingRow("Easy", easyCount, Colors.green),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingRow(String label, int count, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.circle, size: 12, color: color),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
        Text("$count", style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}

class _ChartData {
  final String label;
  final int value;
  final Color color;

  _ChartData(this.label, this.value, this.color);
}
