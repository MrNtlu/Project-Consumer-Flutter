import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:watchlistfy/models/auth/user_stats.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/utils/extensions.dart';

class ProfileChart extends StatelessWidget {
  final List<Logs> logs;

  const ProfileChart(this.logs, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0.5),
          labelPlacement: LabelPlacement.onTicks,
          labelStyle: TextStyle(
            color: CupertinoTheme.of(context).bgTextColor
          ),
          labelRotation: -30,
          labelIntersectAction: AxisLabelIntersectAction.rotate45,
        ),
        primaryYAxis: const NumericAxis(
          axisLine: AxisLine(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorTickLines: MajorTickLines(size: 0),
          isVisible: true,
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          canShowMarker: true,
          format: 'point.y',
          duration: 1000,
        ),
        series: <CartesianSeries>[
          LineSeries<Logs, String>(
            markerSettings: MarkerSettings(isVisible: true, color: CupertinoTheme.of(context).bgTextColor),
            color: AppColors().primaryColor,
            dataSource: logs.reversed.toList(),
            xValueMapper: (Logs logs, _) => DateTime.tryParse(logs.createdAt)!.dateToHumanDate(),
            yValueMapper: (Logs logs, _) => logs.count,
            dataLabelMapper: (data, index) => data.count.toString(),
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              color: CupertinoTheme.of(context).bgTextColor
            ),
          ),
        ],
        zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true,
          enablePanning: true,
          enableSelectionZooming: true,
          selectionRectBorderColor: Colors.red,
          selectionRectBorderWidth: 1,
          selectionRectColor: Colors.grey
        ),
      ),
    );
  }
}