import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingView extends StatelessWidget {
  final String _text;
  final Color textColor;

  const LoadingView(this._text, {this.textColor = Colors.black, super.key});

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait || Platform.isMacOS || Platform.isWindows;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: isPortrait
        ? _body(context)
        : SizedBox(
          height: MediaQuery.of(context).size.height,
          child: _body(context)
        ),
    );
  }

  Widget _body(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      Align(
        alignment: Alignment.center,
        child: Lottie.asset(
          "assets/lottie/loading.json",
          frameRate: const FrameRate(60),
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: Text(
          _text,
          style: TextStyle(color: textColor == Colors.black ? CupertinoTheme.of(context).bgTextColor : textColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      )
    ]
  );
}