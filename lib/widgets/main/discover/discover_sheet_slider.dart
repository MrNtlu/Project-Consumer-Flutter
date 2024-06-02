import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/main/common/details_title.dart';

// ignore: must_be_immutable
class DiscoverSheetSlider extends StatefulWidget {
  final int max;
  final int min;
  final int div;
  int? value;

  DiscoverSheetSlider({
    this.max = 8,
    this.min = 4,
    this.div = 4,
    this.value,
    super.key,
  });

  @override
  State<DiscoverSheetSlider> createState() => _DiscoverSheetSliderState();
}

class _DiscoverSheetSliderState extends State<DiscoverSheetSlider> {
  @override
  Widget build(BuildContext context) {
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
                    color: CupertinoTheme.of(context).bgColor,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 9.5,
                        thumbColor: AppColors().primaryColor,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12, elevation: 3),
                        activeTickMarkColor: CupertinoTheme.of(context).bgTextColor,
                        inactiveTickMarkColor: CupertinoTheme.of(context).bgColor,
                        inactiveTrackColor: CupertinoTheme.of(context).bgTextColor,
                      ),
                      child: Slider(
                        activeColor: AppColors().primaryColor,
                        label: widget.value != null ? "${widget.value}+" : "Not Selected",
                        value: widget.value != null ? widget.value!.toDouble() : widget.min.toDouble(),
                        min: widget.min.toDouble(),
                        max: widget.max.toDouble(),
                        divisions: widget.div,
                        onChanged: (val) {
                          setState(() {
                            if (val > widget.min) {
                              widget.value = val.toInt();
                            } else {
                              widget.value = null;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 75,
                  child: Text(
                    widget.value != null ? "${widget.value}+" : "Not Selected",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
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