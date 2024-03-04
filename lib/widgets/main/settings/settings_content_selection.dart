import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/static/colors.dart';

class SettingsContentSelection extends StatefulWidget {
  final GlobalProvider _provider;

  const SettingsContentSelection(this._provider, {super.key});

  @override
  State<SettingsContentSelection> createState() => _SettingsContentSelectionState();
}

class _SettingsContentSelectionState extends State<SettingsContentSelection> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            widget._provider.contentType.value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CupertinoTheme.of(context).primaryColor,
            ),
          ),
          onPressed: () {
            _showPickerDialog();
          }
        ),
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
            color: CupertinoTheme.of(context).onBgColor,
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
                    var isSelected = ContentType.values.indexOf(widget._provider.contentType) == index;

                    return CupertinoButton(
                      color: isSelected ? CupertinoTheme.of(context).primaryColor : CupertinoTheme.of(context).onBgColor,
                      onPressed: (){
                        if (!isSelected) {
                          widget._provider.setContentType(ContentType.values[index]);
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        ContentType.values[index].value,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? CupertinoColors.white : CupertinoTheme.of(context).bgTextColor,
                        ),
                      ),
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}