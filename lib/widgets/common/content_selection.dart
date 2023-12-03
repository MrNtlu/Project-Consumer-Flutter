import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';

class ContentSelection extends StatefulWidget {
  const ContentSelection({super.key});

  @override
  State<ContentSelection> createState() => _ContentSelectionState();
}

//TODO Change it to radio type button, only single selection.
// Selected should be highlighted
class _ContentSelectionState extends State<ContentSelection> {
  late final ContentProvider contentProvider;
  late FixedExtentScrollController scrollController;
  final double itemExtent = 35.0;
  var isInit = false;

  @override
  void didChangeDependencies() {
    if (!isInit) {
      contentProvider = Provider.of<ContentProvider>(context);
      scrollController = FixedExtentScrollController(
        initialItem: ContentType.values.indexOf(contentProvider.selectedContent),
      );
      isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Row(
        children: [
          Text(
            contentProvider.selectedContent.value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: CupertinoTheme.of(context).bgTextColor,
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            CupertinoIcons.arrowtriangle_down_circle_fill,
            size: 13,
            color: CupertinoTheme.of(context).bgTextColor,
          )
        ],
      ), 
      onPressed: () {
        _showPickerDialog();
      }
    );
  }

  void _showPickerDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        padding: const EdgeInsets.all(16),
        color: CupertinoTheme.of(context).bgColor,
        child: Column(
          children: [
            const Text(
              "Select Content Type",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ClickableListWheelScrollView(
                itemHeight: itemExtent,
                itemCount: ContentType.values.length,
                scrollController: scrollController,
                onItemTapCallback: (selectedItem) {
                  scrollController = FixedExtentScrollController(
                    initialItem: ContentType.values.indexOf(contentProvider.selectedContent),
                  );
                  contentProvider.setContentType(ContentType.values[selectedItem]);
                },
                child: ListWheelScrollView.useDelegate(
                  controller: scrollController,
                  itemExtent: itemExtent,
                  physics: const FixedExtentScrollPhysics(),
                  overAndUnderCenterOpacity: 0.5,
                  perspective: 0.002,
                  magnification: 1.2,
                  squeeze: 1.2,
                  useMagnifier: true,
                  onSelectedItemChanged: (int selectedItem) {
                    scrollController = FixedExtentScrollController(
                      initialItem: ContentType.values.indexOf(contentProvider.selectedContent),
                    );
                    contentProvider.setContentType(ContentType.values[selectedItem]);
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      return Center(
                        child: Text(
                          ContentType.values[index].value,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500, 
                            fontSize: 16, 
                          ),
                        )
                      );
                    },
                    childCount: ContentType.values.length
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
