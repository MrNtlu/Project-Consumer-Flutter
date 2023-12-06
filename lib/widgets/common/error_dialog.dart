import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorDialog extends StatelessWidget {
  final String _error;

  const ErrorDialog(this._error, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: const Color(0xFFC72C41),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: Lottie.asset(
                      "assets/lottie/error_dialog.json",
                      width: 125,
                      height: 125,
                      repeat: true,
                      fit: BoxFit.contain,
                      frameRate: FrameRate(60),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                    child: Text(
                      _error,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoButton(
                    child: const Text("OK!", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)), 
                    onPressed: (){
                      Navigator.pop(context);
                    }
                  ),
                  const SizedBox(height: 4)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}