import 'package:buzzzchat/features/auth/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Varificationbox {
  const Varificationbox({required this.verificationId});
  final String verificationId;

  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref.read(authControllerProvider).verifyOTP(
      context,
      verificationId,
      userOTP,
    );
  }

  void varify(BuildContext context, WidgetRef ref) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        return AlertDialog(
          scrollable: true,
          title: Center(
              child: Text("Varify", style: TextStyle(fontSize: width * 0.12))),
          content: Padding(
            padding: const EdgeInsets.all(13.0),
            child: TextField(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
              onChanged: (value) {
                if (value.trim().length == 6) {
                  verifyOTP(ref, context, value);
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                label: Center(
                    child: Text("- - - - - -", style: TextStyle(fontSize: 30))),
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: Navigator.of(context).pop,
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      "Resesnd OTP",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
