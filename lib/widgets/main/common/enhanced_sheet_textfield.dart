import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class EnhancedSheetTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final VoidCallback onIncrement;
  final String? suffix;
  final IconData? icon;

  const EnhancedSheetTextfield({
    required this.controller,
    required this.label,
    required this.onIncrement,
    this.hint,
    this.suffix,
    this.icon,
    super.key,
  });

  @override
  State<EnhancedSheetTextfield> createState() => _EnhancedSheetTextfieldState();
}

class _EnhancedSheetTextfieldState extends State<EnhancedSheetTextfield>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleIncrement() {
    HapticFeedback.lightImpact();
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onIncrement();
  }

  void _handleSuffixTap() {
    if (widget.suffix != null) {
      HapticFeedback.selectionClick();
      widget.controller.text = widget.suffix!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 16,
                  color: CupertinoColors.systemGrey,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
        ),

        // Input Container
        Container(
          decoration: BoxDecoration(
            color: _isFocused
                ? cupertinoTheme.scaffoldBackgroundColor
                : cupertinoTheme.scaffoldBackgroundColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isFocused
                  ? cupertinoTheme.primaryColor.withValues(alpha: 0.3)
                  : cupertinoTheme.primaryColor.withValues(alpha: 0.1),
              width: _isFocused ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Text Field
              Expanded(
                child: CupertinoTextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                  placeholder: widget.hint ?? "0",
                  placeholderStyle: const TextStyle(
                    color: CupertinoColors.systemGrey2,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const BoxDecoration(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  onTapOutside: (event) {
                    _focusNode.unfocus();
                  },
                ),
              ),

              // Suffix and Increment Button
              Container(
                padding: const EdgeInsets.only(right: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Suffix (if available)
                    if (widget.suffix != null)
                      GestureDetector(
                        onTap: _handleSuffixTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: cupertinoTheme.primaryColor
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "/${widget.suffix}",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: cupertinoTheme.primaryColor,
                            ),
                          ),
                        ),
                      ),

                    if (widget.suffix != null) const SizedBox(width: 8),

                    // Increment Button
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 0,
                        onPressed: _handleIncrement,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: cupertinoTheme.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            CupertinoIcons.add,
                            color: CupertinoColors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
