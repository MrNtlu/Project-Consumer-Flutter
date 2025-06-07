import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/main/common/details_title.dart';

class DiscoverSheetSlider extends StatelessWidget {
  final int max;
  final int min;
  final int div;
  final ValueNotifier<int?> valueNotifier;
  final int? initialValue;

  DiscoverSheetSlider({
    this.max = 8,
    this.min = 4,
    this.div = 4,
    this.initialValue,
    super.key,
  }) : valueNotifier = ValueNotifier(initialValue);

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: DetailsTitle("Rating"),
          ),
          SizedBox(
            height: 45,
            child: Row(
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: Material(
                    color: cupertinoTheme.bgColor,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 9.5,
                        thumbColor: AppColors().primaryColor,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 12,
                          elevation: 3,
                        ),
                        activeTickMarkColor: cupertinoTheme.bgTextColor,
                        inactiveTickMarkColor: cupertinoTheme.bgColor,
                        inactiveTrackColor: cupertinoTheme.bgTextColor,
                      ),
                      child: ValueListenableBuilder(
                          valueListenable: valueNotifier,
                          builder: (context, value, child) {
                            return Slider(
                              activeColor: AppColors().primaryColor,
                              label: value != null ? "$value+" : "Not Selected",
                              value: value != null
                                  ? value.toDouble()
                                  : min.toDouble(),
                              min: min.toDouble(),
                              max: max.toDouble(),
                              divisions: div,
                              onChanged: (val) {
                                if (val > min) {
                                  valueNotifier.value = val.toInt();
                                } else {
                                  valueNotifier.value = null;
                                }
                              },
                            );
                          }),
                    ),
                  ),
                ),
                SizedBox(
                  width: 75,
                  child: ValueListenableBuilder(
                    valueListenable: valueNotifier,
                    builder: (context, value, child) {
                      return Text(
                        value != null ? "$value+" : "Not Selected",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          )
        ],
      ),
    );
  }
}
