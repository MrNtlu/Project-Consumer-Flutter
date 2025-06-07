import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/static/colors.dart';

class SettingsContentSelection extends StatelessWidget {
  final GlobalProvider provider;

  const SettingsContentSelection(this.provider, {super.key});

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              provider.contentType.value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: cupertinoTheme.primaryColor,
              ),
            ),
            onPressed: () {
              _showPickerDialog(
                context,
                cupertinoTheme,
              );
            }),
      ],
    );
  }

  void _showPickerDialog(
    BuildContext context,
    CupertinoThemeData cupertinoTheme,
  ) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          padding: const EdgeInsets.all(16),
          height: 60 + (ContentType.values.length * 50) + 24,
          decoration: BoxDecoration(
            color: cupertinoTheme.onBgColor,
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
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
                      var isSelected =
                          ContentType.values.indexOf(provider.contentType) ==
                              index;

                      return CupertinoButton(
                        color: isSelected
                            ? cupertinoTheme.primaryColor
                            : cupertinoTheme.onBgColor,
                        onPressed: () {
                          if (!isSelected) {
                            provider.setContentType(ContentType.values[index]);
                          }
                          Navigator.pop(context);
                        },
                        child: Text(
                          ContentType.values[index].value,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? CupertinoColors.white
                                : cupertinoTheme.bgTextColor,
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
