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

//TODO Change it to radio type button, only single selection.
// Selected should be highlighted
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
      builder: (BuildContext context) => SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 60 + (ContentType.values.length * 50) + 32,
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
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: ContentType.values.length,
                  itemExtent: 50,
                  itemBuilder: (context, index) {
                    var isSelected = ContentType.values.indexOf(contentProvider.selectedContent) == index;
        
                    return CupertinoButton(
                      color: isSelected ? CupertinoTheme.of(context).primaryColor : CupertinoTheme.of(context).bgColor,
                      onPressed: (){
                        if (!isSelected) {
                          contentProvider.setContentType(ContentType.values[index]);
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        ContentType.values[index].value,
                        style: TextStyle(
                          color: CupertinoTheme.of(context).bgTextColor,
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
