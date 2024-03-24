import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/recommendation/request/recommendation_body.dart';
import 'package:watchlistfy/pages/main/profile/custom_list_selection_page.dart';
import 'package:watchlistfy/providers/main/profile/custom_list_create_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/widgets/common/message_dialog.dart';

class RecommendationCreatePage extends StatelessWidget {
  final String _contentID;
  final ContentType _contentType;
  final VoidCallback _fetchData;

  const RecommendationCreatePage(
    this._contentID,
    this._contentType,
    this._fetchData,
    {super.key}
  );

  void createRecommendation(
    BuildContext context,
    CustomListCreateProvider createProvider,
    String? reason,
  ) async {
    if (createProvider.selectedContent.isEmpty) {
      showCupertinoDialog(context: context, builder: (_) => const ErrorDialog("Please make a selection."));
      return;
    }

    showCupertinoDialog(context: context, builder: (_) => const LoadingDialog());

    final RecommendationBody createBody = RecommendationBody(
      _contentID,
      createProvider.selectedContent.first.contentID,
      _contentType.request,
      reason
    );

    try {
      final response = await http.post(
        Uri.parse(APIRoutes().recommendationRoutes.createRecommendation),
        body: json.encode(createBody.convertToJson()),
        headers: UserToken().getBearerToken()
      );

      if (context.mounted) {
        Navigator.pop(context);

        var baseMessage = response.getBaseMessageResponse();

        if (baseMessage.error != null && context.mounted){
          showCupertinoDialog(
            context: context,
            builder: (ctx) => ErrorDialog(response.getBaseMessageResponse().error!)
          );
          return;
        }

        if (context.mounted) {
          Navigator.pop(context);

          showCupertinoDialog(
            context: context,
            builder: (ctx) => MessageDialog(baseMessage.message ?? "Unkwown error!")
          );

          _fetchData();
        }
      }
    } catch(error) {
      if (context.mounted) {
        Navigator.pop(context);

        showCupertinoDialog(
          context: context,
          builder: (ctx) => ErrorDialog(error.toString())
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final CustomListCreateProvider customListCreateProvider = CustomListCreateProvider();

    final TextEditingController reasonController = TextEditingController();

    return ChangeNotifierProvider(
      create: (_) => customListCreateProvider,
      lazy: false,
      child: Consumer<CustomListCreateProvider>(
        builder: (context, provider, _) {

          return CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text("Make a Recommendation"),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Reason (Optional)",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    ),
                    const SizedBox(height: 16),
                    CupertinoTextField(
                      maxLength: 250,
                      maxLines: 3,
                      controller: reasonController,
                      placeholder: "Why are you recommending? How is it similar?",
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      decoration: BoxDecoration(
                        color: CupertinoTheme.of(context).onBgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select ${_contentType.value}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    ),
                    if (provider.selectedContent.isNotEmpty)
                    const SizedBox(height: 16),
                    if (provider.selectedContent.isNotEmpty)
                    SizedBox(
                      height: 150,
                      child: Row(
                        children: [
                          ContentCell(
                            provider.selectedContent.first.imageURL ?? '',
                            provider.selectedContent.first.titleOriginal,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 140,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    provider.selectedContent.first.titleEn.isNotEmpty
                                    ? provider.selectedContent.first.titleEn
                                    : provider.selectedContent.first.titleOriginal,
                                    minFontSize: 16,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    wrapWords: true,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  AutoSizeText(
                                    provider.selectedContent.first.titleOriginal,
                                    minFontSize: 12,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: CupertinoColors.systemGrey2
                                    ),
                                  ),
                                  const Spacer(),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: CupertinoButton(
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Remove",
                                            style: TextStyle(color: CupertinoColors.systemRed, fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(width: 6),
                                          Icon(
                                            Icons.remove_circle,
                                            size: 22,
                                            color: CupertinoColors.systemRed,
                                          ),
                                        ],
                                      ),
                                      onPressed: () {
                                        provider.removeContent(provider.selectedContent.first.contentID);
                                      }
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (provider.selectedContent.isEmpty)
                    CupertinoButton(
                      child: const Icon(CupertinoIcons.add_circled_solid, size: 32),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute(
                            builder: (_) => ChangeNotifierProvider<CustomListCreateProvider>.value(
                              value: provider,
                              builder: (context, _) => CustomListSelectionPage(
                                isRecommendation: true,
                                contentType: _contentType,
                              ),
                            )
                          )
                        );
                      }
                    ),
                    const SizedBox(height: 32),
                    const Spacer(),
                    CupertinoButton.filled(
                      child: const Text(
                        "Recommend",
                        style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold)
                      ),
                      onPressed: () {
                        createRecommendation(
                          context,
                          provider,
                          reasonController.text,
                        );
                      }
                    ),
                    const SizedBox(height: 32)
                  ],
                ),
              )
            ),
          );
        }
      ),
    );
  }
}