import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class EmptyView extends StatelessWidget {
  final String asset;
  final String emptyText;
  const EmptyView(this.asset, this.emptyText, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                asset,
                height: 250,
                width: 250,
                frameRate: FrameRate(60)
              ),
              const SizedBox(height: 12),
              Text(emptyText, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}