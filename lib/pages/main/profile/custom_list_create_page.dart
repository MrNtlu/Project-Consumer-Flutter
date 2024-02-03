import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/models/main/custom-list/custom_list.dart';
import 'package:watchlistfy/pages/main/profile/custom_list_selection_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/profile/custom_list_create_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/main/profile/custom_list_entry_cell.dart';

class CustomListCreatePage extends StatelessWidget {
  final CustomList? customList;

  const CustomListCreatePage({this.customList, super.key});

  //TODO IsPrivate button

  @override
  Widget build(BuildContext context) {
    final CustomListCreateProvider customListCreateProvider = CustomListCreateProvider();
    final AuthenticationProvider authProvider = Provider.of<AuthenticationProvider>(context);

    final TextEditingController nameController = TextEditingController(text: customList?.name);
    final TextEditingController descriptionController = TextEditingController(text: customList?.description);

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
                      child: ListView.builder(
                        itemCount: provider.selectedContent.length,
                        itemBuilder: (context, index) {
                          final content = provider.selectedContent[index];
                      
                          return CustomListEntryCell(
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
                            null
                          );
                        }
                      ),
                    ),
                    const SizedBox(height: 32),
                    CupertinoButton.filled(
                      child: Text(customList != null ? "Update" : "Create", style: const TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold)), 
                      onPressed: () {
                        //TODO SAVE or UPDATE operation
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