import 'package:flutter/cupertino.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:watchlistfy/models/auth/user_stats.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'dart:math' as math;

class ProfileChart extends StatelessWidget {
  final List<Logs> logs;
  final List<ContentTypeDistribution>? contentTypeDistribution;

  const ProfileChart(this.logs, {this.contentTypeDistribution, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (logs.isNotEmpty) _buildActivityChart(context),
        if (contentTypeDistribution != null &&
            contentTypeDistribution!.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildPieChart(context),
        ],
      ],
    );
  }

  Widget _buildActivityChart(BuildContext context) {
    if (logs.isEmpty) return const SizedBox.shrink();

    final maxCount = logs.map((e) => e.count).reduce(math.max);
    const chartHeight = 120.0; // Further reduced height
    const barWidth = 45.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors().primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.chart_bar_fill,
                      size: 16,
                      color: AppColors().primaryColor,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "Activity Chart",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: CupertinoTheme.of(context).barBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Peak: $maxCount",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity, // Full width
            height: chartHeight + 40, // Further reduced total height
            decoration: BoxDecoration(
              color: CupertinoTheme.of(context).barBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: IntrinsicHeight(
                  // Ensures consistent height
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: logs.reversed.map((log) {
                      final barHeight = maxCount > 0
                          ? (log.count / maxCount) * chartHeight
                          : 0.0;
                      final date = DateTime.tryParse(log.createdAt);
                      final isHighest = log.count == maxCount;

                      return Container(
                        width: barWidth + 12,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Count label - using Flexible to prevent overflow
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isHighest
                                      ? AppColors().primaryColor
                                      : AppColors()
                                          .primaryColor
                                          .withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors()
                                          .primaryColor
                                          .withValues(alpha: 0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  log.count.toString(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: CupertinoColors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Bar - using Flexible to prevent overflow
                            Flexible(
                              flex: 3, // Give more space to the bar
                              child: Container(
                                width: barWidth,
                                height: math.max(barHeight, 4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: isHighest
                                        ? [
                                            AppColors().primaryColor,
                                            AppColors()
                                                .primaryColor
                                                .withValues(alpha: 0.7),
                                          ]
                                        : [
                                            AppColors()
                                                .primaryColor
                                                .withValues(alpha: 0.8),
                                            AppColors()
                                                .primaryColor
                                                .withValues(alpha: 0.5),
                                          ],
                                  ),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8),
                                    bottom: Radius.circular(4),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors()
                                          .primaryColor
                                          .withValues(alpha: 0.2),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            // Date label - using Flexible to prevent overflow
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 3, vertical: 1),
                                decoration: BoxDecoration(
                                  color: CupertinoTheme.of(context)
                                      .barBackgroundColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _formatDateLabel(date),
                                  style: const TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w500,
                                    color: CupertinoColors.systemGrey,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Activity summary - Full width
          Row(
            children: [
              _buildActivityStat("Total Days", logs.length.toString(),
                  CupertinoIcons.calendar, context),
              const SizedBox(width: 8),
              _buildActivityStat(
                  "Total Activity",
                  logs.fold(0, (sum, log) => sum + log.count).toString(),
                  CupertinoIcons.flame_fill,
                  context),
              const SizedBox(width: 8),
              _buildActivityStat(
                  "Average",
                  (logs.fold(0, (sum, log) => sum + log.count) / logs.length)
                      .toStringAsFixed(1),
                  CupertinoIcons.chart_bar,
                  context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityStat(
      String label, String value, IconData icon, BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: CupertinoTheme.of(context).barBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: AppColors().primaryColor,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors().primaryColor,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                color: CupertinoColors.systemGrey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateLabel(DateTime? date) {
    if (date == null) return "N/A";

    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return "Today";
    if (difference == 1) return "Yesterday";
    if (difference < 7) return "${difference}d ago";

    return date.dateToHumanDate();
  }

  Widget _buildPieChart(BuildContext context) {
    if (contentTypeDistribution == null || contentTypeDistribution!.isEmpty) {
      return const SizedBox.shrink();
    }

    const double pieSize = 200.0;
    final colors = [
      AppColors().primaryColor,
      AppColors().primaryColor.withValues(alpha: 0.8),
      AppColors().primaryColor.withValues(alpha: 0.6),
      AppColors().primaryColor.withValues(alpha: 0.4),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Content Distribution",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: pieSize,
                height: pieSize,
                child: CustomPaint(
                  painter: PieChartPainter(contentTypeDistribution!, colors),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      contentTypeDistribution!.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final contentType = ContentType.values
                        .where((e) => e.request == item.contentType)
                        .firstOrNull;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: colors[index % colors.length],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "${contentType?.value ?? item.contentType}: ${item.percentage.toStringAsFixed(1)}%",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final List<ContentTypeDistribution> data;
  final List<Color> colors;

  PieChartPainter(this.data, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;

    double startAngle = -math.pi / 2; // Start from top

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i].percentage / 100) * 2 * math.pi;
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
