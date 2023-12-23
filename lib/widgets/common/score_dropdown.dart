import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';

// ignore: must_be_immutable
class ScoreDropdown extends StatefulWidget {
  int? selectedValue;
  final List<int> scoreList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  ScoreDropdown({this.selectedValue, super.key});

  @override
  State<ScoreDropdown> createState() => _ScoreDropdownState();
}

class _ScoreDropdownState extends State<ScoreDropdown> {
  int _selectedItem = 5;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => Container(
            padding: const EdgeInsets.only(top: 3),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        child: const Text("Cancel", style: TextStyle(color: CupertinoColors.destructiveRed)), 
                        onPressed: () {
                          Navigator.pop(context);
                          _selectedItem = widget.selectedValue ?? 5;
                        }
                      ),
                      CupertinoButton(
                        child: const Text("Select", style: TextStyle(color: CupertinoColors.activeBlue, fontWeight: FontWeight.bold)), 
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            widget.selectedValue = _selectedItem;
                          });
                        }
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 150,
                    child: CupertinoPicker(
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: 35,
                      scrollController: FixedExtentScrollController(
                        initialItem: widget.selectedValue != null ? widget.selectedValue! - 1 : 4,
                      ),
                      onSelectedItemChanged: (int selectedItem) {
                        _selectedItem = selectedItem + 1;
                      },
                      children: List<Widget>.generate(widget.scoreList.length, (int index) {
                        return Center(child: Text(widget.scoreList[index].toString()));
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: CupertinoTheme.of(context).bgColor,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Score",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              )
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.selectedValue != null ? '${widget.selectedValue} ⭐️' : 'No Selection',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: CupertinoTheme.of(context).bgTextColor
                      )
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, size: 24, color: CupertinoTheme.of(context).bgTextColor)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
