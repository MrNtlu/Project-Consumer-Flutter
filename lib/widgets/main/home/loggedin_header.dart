import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/static/colors.dart';

class LoggedinHeader extends StatelessWidget {
  const LoggedinHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticationProvider = Provider.of<AuthenticationProvider>(context);

    return GestureDetector(
      onTap: () {
        print("Profile clicked");
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              authenticationProvider.basicUserInfo?.image ?? '',
              height: 30,
              width: 30,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Padding(padding: const EdgeInsets.all(3), child: CircularProgressIndicator(color: AppColors().primaryColor));
              },
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
