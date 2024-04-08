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
        margin: const EdgeInsets.all(3),
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
          labelPlacement: MediaQuery.of(context).orientation == Orientation.portrait
          ? LabelPlacement.betweenTicks
          : LabelPlacement.onTicks,
          labelStyle: TextStyle(
            color: CupertinoTheme.of(context).bgTextColor,
          ),
          labelRotation: -30,
          labelIntersectAction: AxisLabelIntersectAction.rotate45,
        ),
        primaryYAxis: const NumericAxis(
          axisLine: AxisLine(width: 0),
          majorGridLines: MajorGridLines(width: 0.5),
          majorTickLines: MajorTickLines(size: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          isVisible: true,
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          canShowMarker: true,
          format: 'point.y',
          duration: 1000,
        ),
        series: <CartesianSeries>[
          SplineAreaSeries<Logs, String>(
            markerSettings: MarkerSettings(
              isVisible: true,
              color: CupertinoTheme.of(context).bgTextColor,
            ),
            dataSource: logs.reversed.toList(),
            xValueMapper: (Logs logs, _) => DateTime.tryParse(logs.createdAt)!.dateToHumanDate(),
            yValueMapper: (Logs logs, _) => logs.count,
            dataLabelMapper: (data, index) => data.count.toString(),
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              borderRadius: 6,
              textStyle: TextStyle(color: CupertinoTheme.of(context).bgTextColor, fontWeight: FontWeight.bold),
              labelAlignment: ChartDataLabelAlignment.top,
              useSeriesColor: true,
              showZeroValue: false,
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors().primaryColor, AppColors().primaryColor.withOpacity(0.5)],
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