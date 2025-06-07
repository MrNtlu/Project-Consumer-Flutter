import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/providers/main/profile/user_list_content_selection_provider.dart';
import 'package:watchlistfy/static/colors.dart';

class UserListContentSelection extends StatefulWidget {
  final UserListContentSelectionProvider provider;

  const UserListContentSelection(this.provider, {super.key});

  @override
  State<UserListContentSelection> createState() =>
      _UserListContentSelectionState();
}

class _UserListContentSelectionState extends State<UserListContentSelection> {
  bool didInit = false;
  late final CupertinoThemeData cupertinoTheme;

  @override
  void didChangeDependencies() {
    if (!didInit) {
      cupertinoTheme = CupertinoTheme.of(context);
      didInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CupertinoButton(
          onPressed: () {
            widget.provider.decrementContentType();
          },
          minSize: 0,
          padding: const EdgeInsets.all(3),
          child: const Icon(CupertinoIcons.left_chevron, size: 20),
        ),
        const SizedBox(width: 3),
        CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.provider.selectedContent.value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: cupertinoTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  CupertinoIcons.chevron_down_circle_fill,
                  size: 14,
                  color: cupertinoTheme.primaryColor,
                ),
              ],
            ),
          ),
          onPressed: () {
            _showPickerDialog();
          },
        ),
        const SizedBox(width: 3),
        CupertinoButton(
          onPressed: () {
            widget.provider.incrementContentType();
          },
          minSize: 0,
          padding: const EdgeInsets.all(3),
          child: const Icon(
            CupertinoIcons.right_chevron,
            size: 20,
          ),
        ),
        const SizedBox(
          width: 6,
        )
      ],
    );
  }

  void _showPickerDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          padding: const EdgeInsets.all(16),
          height: 60 + (ContentType.values.length * 50) + 24,
          decoration: BoxDecoration(
            color: cupertinoTheme.onBgColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select Content Type",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: ContentType.values.length,
                  itemExtent: 50,
                  itemBuilder: (context, index) {
                    var isSelected = ContentType.values
                            .indexOf(widget.provider.selectedContent) ==
                        index;

                    return CupertinoButton(
                      color: isSelected
                          ? cupertinoTheme.primaryColor
                          : cupertinoTheme.onBgColor,
                      onPressed: () {
                        if (!isSelected) {
                          widget.provider
                              .setContentType(ContentType.values[index]);
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        ContentType.values[index].value,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? CupertinoColors.white
                              : cupertinoTheme.bgTextColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
