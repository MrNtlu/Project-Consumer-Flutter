import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:watchlistfy/widgets/main/settings/offers_sheet.dart';

class ErrorView extends StatelessWidget {
  final String _text;
  final VoidCallback _onPressed;
  final bool isPremiumError;

  const ErrorView(this._text, this._onPressed, {this.isPremiumError = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!isPremiumError)
        Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.only(right: 8, top: 8),
          child: IconButton(
            onPressed: _onPressed,
            icon: const Icon(Icons.refresh_rounded, size: 36)
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 36),
          child: Lottie.asset(
            isPremiumError ? "assets/lottie/premium.json" : "assets/lottie/error.json",
            height: 125,
            width: 125,
            frameRate: const FrameRate(60)
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(8, 16, 8, 16),
          child: Text(
            _text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        if (isPremiumError)
        const SizedBox(height: 16),
        if (isPremiumError)
        CupertinoButton.filled(
          child: const Text(
            "Upgrade Account",
            style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.w500
            )
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(builder: (_) {
                return const OffersSheet();
              })
            );
          }
        )
      ],
    );
  }
}