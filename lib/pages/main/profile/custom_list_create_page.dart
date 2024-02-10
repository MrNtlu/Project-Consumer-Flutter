import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/models/main/custom-list/custom_list.dart';
import 'package:watchlistfy/models/main/custom-list/request/create_custom_list.dart';
import 'package:watchlistfy/models/main/custom-list/request/custom_list_content.dart';
import 'package:watchlistfy/models/main/custom-list/request/update_custom_list.dart';
import 'package:watchlistfy/pages/main/profile/custom_list_selection_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/profile/custom_list_create_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';
import 'package:watchlistfy/widgets/common/message_dialog.dart';
import 'package:watchlistfy/widgets/main/profile/custom_list_entry_cell.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/widgets/main/profile/custom_list_private_switch.dart';

class CustomListCreatePage extends StatelessWidget {
  final CustomList? customList;
  final VoidCallback _fetchData;

  const CustomListCreatePage(this._fetchData, {this.customList, super.key});

  void handleCustomListOperation(
    BuildContext context,
    CustomListCreateProvider createProvider,
    String title,
    String? description,
    bool isUpdating,
    bool isPrivate,
  ) async {
    if (title.isEmpty) {
      showCupertinoDialog(context: context, builder: (_) => const ErrorDialog("Invalid title. Title can not be empty!"));
      return;
    } else if (createProvider.selectedContent.isEmpty) {
      showCupertinoDialog(context: context, builder: (_) => const ErrorDialog("Please add at least 1 entry."));
      return;
    }
    
    showCupertinoDialog(context: context, builder: (_) => const LoadingDialog());

    final contentList = createProvider.selectedContent.mapIndexed(
      (index, element) => CustomListContentBody(
        index + 1, 
        element.contentID, 
        element.contentExternalID, 
        element.contentExternalIntID, 
        element.contentType
      )
    ).sorted((a, b) => a.order.compareTo(b.order)).toList();

    final CreateCustomList createBody = CreateCustomList(
      title, 
      description, 
      isPrivate, 
      contentList
    );

    final UpdateCustomListBody updateBody = UpdateCustomListBody(
      customList?.id ?? '', 
      title, 
      description, 
      isPrivate,
      contentList
    );

    try {
      final response = isUpdating 
      ? await http.patch(
        Uri.parse(APIRoutes().customListRoutes.updateCustomList),
        body: json.encode(updateBody.convertToJson()),
        headers: UserToken().getBearerToken()
      )
      : await http.post(
        Uri.parse(APIRoutes().customListRoutes.createCustomList),
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
          // if (updateReviewData != null) {
          //   updateReviewData!();
          // }
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
    final AuthenticationProvider authProvider = Provider.of<AuthenticationProvider>(context);

    final isPrivateSwitch = CustomListPrivateSwitch(isPrivate: customList?.isPrivate ?? false);
    final TextEditingController nameController = TextEditingController(text: customList?.name);
    final TextEditingController descriptionController = TextEditingController(text: customList?.description);
    customListCreateProvider.selectedContent = customList?.content.sorted((a, b) => a.order.compareTo(b.order)) ?? [];

    return ChangeNotifierProvider(
      create: (_) => customListCreateProvider,
      lazy: false,
      child: Consumer<CustomListCreateProvider>(
        builder: (context, provider, _) {

          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(customList != null ? "Update List" : "Create a List"),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CupertinoTextField(
                      maxLength: 250,
                      maxLines: 1,
                      controller: nameController,
                      placeholder: "Title",
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      decoration: BoxDecoration(
                        color: CupertinoTheme.of(context).onBgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 6),
                    CupertinoTextField(
                      maxLines: 3,
                      controller: descriptionController,
                      placeholder: "Description (Optional)",
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      decoration: BoxDecoration(
                        color: CupertinoTheme.of(context).onBgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 6),
                    isPrivateSwitch,
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Entries", style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                            CupertinoButton(
                              child: const Icon(CupertinoIcons.add_circled_solid),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).push(
                                  CupertinoPageRoute(
                                    builder: (_) => ChangeNotifierProvider<CustomListCreateProvider>.value(
                                      value: provider,
                                      builder: (context, _) => const CustomListSelectionPage(),
                                    )
                                  )
                                );
                              }
                            )
                          ],
                        ),
                        Text(
                          "${provider.selectedContent.length}/${authProvider.basicUserInfo?.isPremium == true ? "25" : "10"}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: CupertinoColors.systemGrey2
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Flexible(
                      child: ReorderableListView.builder(
                        onReorder: (oldIndex, newIndex) {
                          provider.reOrder(newIndex, oldIndex);
                        },
                        itemCount: provider.selectedContent.isNotEmpty ? provider.selectedContent.length : 1,
                        itemBuilder: (context, index) {
                          if (provider.selectedContent.isEmpty) {
                            return const SizedBox(
                              key: ValueKey("no entry"),
                              height: 150,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text("No entry yet."),
                                ),
                              ),
                            );
                          }

                          final content = provider.selectedContent[index];
                      
                          return CustomListEntryCell(
                            index: index + 1,
                            null, 
                            BaseContent(
                              content.contentID, 
                              "", 
                              content.imageURL ?? '', 
                              content.titleEn, 
                              content.titleOriginal, 
                              content.contentExternalID,
                              content.contentExternalIntID
                            ), 
                            true, 
                            () {
                              provider.removeContent(content.contentID);
                            }, 
                            null,
                            key: ValueKey(content.contentID),
                          );
                        }
                      ),
                    ),
                    const SizedBox(height: 32),
                    CupertinoButton.filled(
                      child: Text(customList != null ? "Update" : "Create", style: const TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold)), 
                      onPressed: () {
                        handleCustomListOperation(
                          context, 
                          provider, 
                          nameController.text, 
                          descriptionController.text,
                          customList != null,
                          isPrivateSwitch.isPrivate
                        );
                      }
                    )
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