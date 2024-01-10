import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/providers/main/profile/user_list_content_selection_provider.dart';
import 'package:watchlistfy/static/colors.dart';

class UserListContentSelection extends StatefulWidget {
  final UserListContentSelectionProvider provider;

  const UserListContentSelection(this.provider, {super.key});

  @override
  State<UserListContentSelection> createState() => _UserListContentSelectionState();
}

class _UserListContentSelectionState extends State<UserListContentSelection> {
  
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.provider.selectedContent.value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: CupertinoTheme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            CupertinoIcons.arrowtriangle_down_circle_fill,
            size: 13,
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
          padding: const EdgeInsets.all(16),
          height: 60 + (ContentType.values.length * 50) + 32,
          color: CupertinoTheme.of(context).bgColor,
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
                    var isSelected = ContentType.values.indexOf(widget.provider.selectedContent) == index;
        
                    return CupertinoButton(
                      color: isSelected ? CupertinoTheme.of(context).primaryColor : CupertinoTheme.of(context).bgColor,
                      onPressed: (){
                        if (!isSelected) {
                          widget.provider.setContentType(ContentType.values[index]);
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