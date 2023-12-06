import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorView extends StatelessWidget {
  final String _text;
  final VoidCallback _onPressed;
  
  const ErrorView(this._text, this._onPressed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            "assets/lottie/error.json",
            height: 125,
            width: 125,
            frameRate: FrameRate(60)
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
        )
      ],
    );
  }
}