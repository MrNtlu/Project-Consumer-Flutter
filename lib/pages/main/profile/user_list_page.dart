import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/providers/main/profile/user_list_content_selection_provider.dart';
import 'package:watchlistfy/widgets/main/profile/user_list_content_selection.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  /* TODO
  * - [ ] Increment/decrement button for tv series and anime.
  * - [ ] UserList provider to retrieve data and user list operations.
  * - [ ] UserList view, edit, delete like details page.
  * - [ ] Nav bar with selection like home page
  */

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserListContentSelectionProvider(),
      child: Consumer<UserListContentSelectionProvider>(
        builder: (context, provider, child) {

          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text("My List"),
              trailing: UserListContentSelection(provider),
            ),
            child: ListView.builder(itemBuilder: (context, index) {
          
            }),
          );
        }
      ),
    );
  }
}