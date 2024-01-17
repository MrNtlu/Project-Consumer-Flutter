import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';

class EmailField extends StatelessWidget {
  final TextEditingController _controller;
  final String label;

  const EmailField(this._controller, {
    this.label = "Email",
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: _controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      maxLines: 1,
      prefix: Padding(
        padding: const EdgeInsets.only(left: 12, top: 16, bottom: 16),
        child: SizedBox(
          width: 90,
          child: Text(
            label,
            style: TextStyle(
              color: CupertinoTheme.of(context).bgTextColor, 
              fontSize: 16
            ),
          ),
        ),
      ),
      placeholder: "Enter $label",
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).onBgColor,
        borderRadius: BorderRadius.circular(8)
      ),
      style: const TextStyle(fontSize: 16),
      padding: const EdgeInsets.all(8),
    );
  }
}