import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/ai/suggestion_response.dart';
import 'package:watchlistfy/models/main/common/request/consume_later_body.dart';
import 'package:watchlistfy/models/main/common/request/id_body.dart';
import 'package:watchlistfy/providers/main/ai/ai_recommendations_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';

class AISuggestionContentCell extends StatefulWidget {
  final SuggestionResponse suggestion;
  final AIRecommendationsProvider provider;
  final VoidCallback onTap;

  const AISuggestionContentCell({
    required this.suggestion,
    required this.provider,
    required this.onTap,
    super.key,
  });

  @override
  State<AISuggestionContentCell> createState() =>
      _AISuggestionContentCellState();
}

class _AISuggestionContentCellState extends State<AISuggestionContentCell> {
  bool _isConsumeLaterLoading = false;
  bool _isNotInterestedLoading = false;

  // Cache frequently accessed values
  late final Color _primaryColor;
  late final String _optimizedImageUrl;
  late final LinearGradient _overlayGradient;
  late final BorderRadius _borderRadius;
  late final List<BoxShadow> _buttonShadow;

  @override
  void initState() {
    super.initState();

    // Cache expensive computations and frequently accessed values
    _primaryColor = AppColors().primaryColor;
    _optimizedImageUrl =
        widget.suggestion.imageUrl.replaceAll("original", "w500");
    _overlayGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0x00000000), // CupertinoColors.black.withValues(alpha: 0.0)
        Color(0xD9000000), // CupertinoColors.black.withValues(alpha: 0.85)
      ],
    );
    _borderRadius = const BorderRadius.only(
      bottomLeft: Radius.circular(12),
      bottomRight: Radius.circular(12),
    );
    _buttonShadow = const [
      BoxShadow(
        color:
            Color(0x40000000), // CupertinoColors.black.withValues(alpha: 0.25)
        offset: Offset(0, 2),
        blurRadius: 4,
      ),
    ];
  }

  Future<void> _handleConsumeLater() async {
    if (_isConsumeLaterLoading || _isNotInterestedLoading) return;

    setState(() {
      _isConsumeLaterLoading = true;
    });

    try {
      final isCurrentlyAdded = widget.suggestion.consumeLater != null;

      if (isCurrentlyAdded) {
        final response = await widget.provider.deleteConsumeLaterObject(
          IDBody(widget.suggestion.consumeLater!.id),
        );

        if (response.error == null) {
          widget.provider.updateItemConsumeLater(
            widget.suggestion.consumeLater?.id ?? '',
            widget.suggestion.contentID,
            false,
          );
        }
      } else {
        final response = await widget.provider.createConsumeLaterObject(
          ConsumeLaterBody(
            widget.suggestion.contentID,
            widget.suggestion.contentExternalID,
            widget.suggestion.contentType,
          ),
        );

        if (response.error == null && response.data != null) {
          widget.provider.updateItemConsumeLater(
            response.data?.id ?? '',
            widget.suggestion.contentID,
            true,
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isConsumeLaterLoading = false;
        });
      }
    }
  }

  Future<void> _handleNotInterested() async {
    if (_isConsumeLaterLoading || _isNotInterestedLoading) return;

    setState(() {
      _isNotInterestedLoading = true;
    });

    try {
      final isCurrentlyNotInterested = widget.suggestion.isNotInterested;

      final response = await widget.provider.markAndUnmarkAsNotInterested(
        widget.suggestion.contentID,
        widget.suggestion.contentType,
        isCurrentlyNotInterested,
      );

      if (response.error == null) {
        widget.provider.updateItemNotInterested(
          widget.suggestion.contentID,
          !isCurrentlyNotInterested,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isNotInterestedLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cache button states to avoid repeated null checks
    final isConsumeLaterActive = widget.suggestion.consumeLater != null;
    final isNotInterestedActive = widget.suggestion.isNotInterested;
    final isGameContent =
        widget.suggestion.contentType == ContentType.game.request;

    return RepaintBoundary(
      child: Stack(
        children: [
          // Base ContentCell
          GestureDetector(
            onTap: widget.onTap,
            child: ContentCell(
              _optimizedImageUrl,
              widget.suggestion.titleEn,
              forceRatio: true,
            ),
          ),

          // Game title overlay (positioned above buttons)
          if (isGameContent)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x00000000), // Transparent
                      Color(0x80000000), // Semi-transparent black
                    ],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                child: Text(
                  widget.suggestion.titleEn,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.white,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // Button overlay at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: _overlayGradient,
                borderRadius: _borderRadius,
              ),
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
              child: Row(
                children: [
                  // Consume Later Button
                  Expanded(
                    child: _ActionButton(
                      isLoading: _isConsumeLaterLoading,
                      isActive: isConsumeLaterActive,
                      onPressed: _handleConsumeLater,
                      activeColor: _primaryColor,
                      activeIcon: FontAwesomeIcons.check,
                      inactiveIcon: FontAwesomeIcons.clock,
                      activeText: "Added",
                      inactiveText: "Later",
                      isDisabled:
                          _isConsumeLaterLoading || _isNotInterestedLoading,
                      buttonShadow: _buttonShadow,
                    ),
                  ),

                  const SizedBox(width: 6),

                  // Not Interested Button
                  Expanded(
                    child: _ActionButton(
                      isLoading: _isNotInterestedLoading,
                      isActive: isNotInterestedActive,
                      onPressed: _handleNotInterested,
                      activeColor: CupertinoColors.systemRed,
                      activeIcon: FontAwesomeIcons.xmark,
                      inactiveIcon: FontAwesomeIcons.thumbsDown,
                      activeText: "Disliked",
                      inactiveText: "No",
                      isDisabled:
                          _isConsumeLaterLoading || _isNotInterestedLoading,
                      buttonShadow: _buttonShadow,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Optimized action button as a separate widget to reduce build complexity
class _ActionButton extends StatelessWidget {
  final bool isLoading;
  final bool isActive;
  final VoidCallback onPressed;
  final Color activeColor;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String activeText;
  final String inactiveText;
  final bool isDisabled;
  final List<BoxShadow> buttonShadow;

  const _ActionButton({
    required this.isLoading,
    required this.isActive,
    required this.onPressed,
    required this.activeColor,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.activeText,
    required this.inactiveText,
    required this.isDisabled,
    required this.buttonShadow,
  });

  @override
  Widget build(BuildContext context) {
    // Cache computed values
    final backgroundColor = isActive
        ? activeColor
        : const Color(
            0xE6FFFFFF); // CupertinoColors.white.withValues(alpha: 0.9)
    final iconColor =
        isActive ? CupertinoColors.white : CupertinoColors.systemGrey;
    final textColor = iconColor;
    final displayText = isActive ? activeText : inactiveText;
    final displayIcon = isActive ? activeIcon : inactiveIcon;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      onPressed: isDisabled ? null : onPressed,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: buttonShadow,
        ),
        child: isLoading
            ? Center(
                child: CupertinoActivityIndicator(
                  radius: 10,
                  color: isActive ? CupertinoColors.white : activeColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    displayIcon,
                    size: 14,
                    color: iconColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    displayText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
