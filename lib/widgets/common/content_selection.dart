import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/static/colors.dart';

class ContentSelection extends StatefulWidget {
  const ContentSelection({super.key});

  @override
  State<ContentSelection> createState() => _ContentSelectionState();
}

class _ContentSelectionState extends State<ContentSelection> {
  late final ContentProvider contentProvider;
  var isInit = false;

  @override
  void didChangeDependencies() {
    if (!isInit) {
      contentProvider = Provider.of<ContentProvider>(context);
      isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            contentProvider.selectedContent.value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CupertinoTheme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            CupertinoIcons.arrowtriangle_down_circle_fill,
            size: 14,
            color: CupertinoTheme.of(context).primaryColor,
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
                    var isSelected = ContentType.values.indexOf(contentProvider.selectedContent) == index;
        
                    return CupertinoButton(
                      color: isSelected ? CupertinoTheme.of(context).primaryColor : CupertinoTheme.of(context).onBgColor,
                      onPressed: (){
                        if (!isSelected) {
                          contentProvider.setContentType(ContentType.values[index]);
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
