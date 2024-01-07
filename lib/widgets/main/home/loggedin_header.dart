import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/static/colors.dart';

class LoggedinHeader extends StatelessWidget {
  const LoggedinHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticationProvider = Provider.of<AuthenticationProvider>(context);
    final image = authenticationProvider.basicUserInfo?.image;
    final isUrlValid = image != null && Uri.tryParse(image) != null;

    return GestureDetector(
      onTap: () {
        //TODO Navigate to profile
        print("Profile clicked");
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: isUrlValid
            ? Image.network(
              authenticationProvider.basicUserInfo!.image!,
              height: 30,
              width: 30,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Padding(padding: const EdgeInsets.all(3), child: CircularProgressIndicator(color: AppColors().primaryColor));
              },
            )
            : const Icon(
              Icons.person,
              size: 30,
              color: CupertinoColors.activeBlue,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            authenticationProvider.basicUserInfo?.username ?? '',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
