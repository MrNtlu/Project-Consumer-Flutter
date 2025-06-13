import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/main/base_details.dart';
import 'package:watchlistfy/providers/main/details_sheet_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/common/notification_overlay.dart';
import 'package:watchlistfy/widgets/common/score_dropdown.dart';
import 'package:watchlistfy/widgets/main/common/details_sheet_status.dart';

class EnhancedDetailsSheet extends StatefulWidget {
  final String title;
  final BaseUserList? userList;
  final List<Widget> customFields;
  final Future<void> Function() onSave;
  final Future<void> Function()? onUpdate;
  final String? Function()? validator;

  const EnhancedDetailsSheet({
    required this.title,
    required this.customFields,
    required this.onSave,
    this.userList,
    this.onUpdate,
    this.validator,
    super.key,
  });

  @override
  State<EnhancedDetailsSheet> createState() => EnhancedDetailsSheetState();
}

class EnhancedDetailsSheetState extends State<EnhancedDetailsSheet>
    with SingleTickerProviderStateMixin {
  late final DetailsSheetProvider _provider;
  late final ScoreDropdown _scoreDropdown;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _provider = DetailsSheetProvider();

    if (widget.userList != null) {
      _provider.initStatus(Constants.UserListStatus.firstWhere(
        (element) => element.request == widget.userList!.status,
      ));
    }

    _scoreDropdown = ScoreDropdown(
      selectedValue: widget.userList?.score,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _fadeController.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_isLoading.value) return;

    final validationError = widget.validator?.call();
    if (validationError != null) {
      if (mounted) {
        NotificationOverlay().show(
          context,
          title: "Validation Error",
          message: validationError,
          isError: true,
        );
      }
      return;
    }

    _isLoading.value = true;
    HapticFeedback.lightImpact();

    try {
      if (widget.userList != null && widget.onUpdate != null) {
        await widget.onUpdate!();

        if (mounted && !_isDisposed) {
          Navigator.pop(context);
          NotificationOverlay().show(
            context,
            title: "Success",
            message: "Successfully updated your list!",
          );
        }
      } else {
        await widget.onSave();

        if (mounted && !_isDisposed) {
          Navigator.pop(context);
          NotificationOverlay().show(
            context,
            title: "Success",
            message: "Successfully added to your list!",
          );
        }
      }
    } catch (error) {
      if (mounted && !_isDisposed) {
        NotificationOverlay().show(
          context,
          title: "Error",
          message: error.toString(),
          isError: true,
        );
      }
    } finally {
      if (!_isDisposed) {
        _isLoading.value = false;
      }
    }
  }

  Future<void> _handleCancel() async {
    HapticFeedback.lightImpact();
    Navigator.pop(context);
  }

  Widget _buildSectionCard({
    required String title,
    required Widget child,
    IconData? icon,
  }) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cupertinoTheme.barBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cupertinoTheme.primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 16,
                      color: cupertinoTheme.primaryColor,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: cupertinoTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, title.isEmpty ? 16 : 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedScoreSection() {
    return _buildSectionCard(
      title: "Rating",
      icon: CupertinoIcons.star_fill,
      child: _scoreDropdown,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return ChangeNotifierProvider.value(
      value: _provider,
      child: Consumer<DetailsSheetProvider>(
        builder: (context, provider, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: mediaQuery.size.height * 0.9,
              ),
              decoration: BoxDecoration(
                color: cupertinoTheme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with Title and Close Button
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Column(
                      children: [
                        // Title Row with Close Button
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.userList != null
                                        ? "Update your progress and rating"
                                        : "Add to your watchlist with details",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: CupertinoColors.systemGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Close Button
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: _handleCancel,
                              child: const Icon(
                                CupertinoIcons.xmark_circle_fill,
                                size: 28,
                                color: CupertinoColors.systemGrey3,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Save Button
                        ValueListenableBuilder<bool>(
                          valueListenable: _isLoading,
                          builder: (context, isLoading, child) {
                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: isLoading
                                    ? null
                                    : const LinearGradient(
                                        colors: [
                                          CupertinoColors.activeBlue,
                                          Color(0xFF0066CC),
                                        ],
                                      ),
                                color: isLoading
                                    ? CupertinoColors.systemGrey4
                                    : null,
                              ),
                              child: CupertinoButton(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                onPressed: isLoading ? null : _handleSave,
                                child: isLoading
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CupertinoActivityIndicator(
                                            color: CupertinoColors.white),
                                      )
                                    : Text(
                                        widget.userList != null
                                            ? "Update"
                                            : "Save",
                                        style: TextStyle(
                                          color: isLoading
                                              ? CupertinoColors.systemGrey2
                                              : CupertinoColors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 20 + mediaQuery.viewInsets.bottom,
                      ),
                      child: Column(
                        children: [
                          // Status Section
                          _buildSectionCard(
                            title: "Status",
                            icon: CupertinoIcons.checkmark_circle_fill,
                            child: DetailsSheetStatus(provider),
                          ),

                          // Score Section
                          _buildEnhancedScoreSection(),

                          // Custom Fields Section
                          if (widget.customFields.isNotEmpty)
                            _buildSectionCard(
                              title: "Progress",
                              icon: CupertinoIcons.chart_bar_fill,
                              child: Column(
                                children: widget.customFields,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  DetailsSheetProvider get provider => _provider;
  ScoreDropdown get scoreDropdown => _scoreDropdown;
}
