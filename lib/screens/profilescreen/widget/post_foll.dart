// import 'package:flutter/material.dart';

// class Display {
//   Widget display(int num, String label, double width) {
//     return Column(
//       children: [
//         Text(
//           num.toString(),
//           style: TextStyle(fontSize: width * 0.05, color: Colors.white),
//         ),
//         Container(
//           margin: const EdgeInsets.only(top: 4),
//           child: Text(
//             label,
//             style: TextStyle(
//                 fontSize: width * 0.04,
//                 color: const Color.fromARGB(192, 255, 255, 255)),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';

class Display extends StatelessWidget {
  final int num;
  final String label;
  final double width;

  const Display(
      {super.key, required this.num, required this.label, required this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontSize: width * 0.05, color: Colors.black),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: width * 0.04,
              color: const Color.fromARGB(148, 10, 0, 0),
            ),
          ),
        ),
      ],
    );
  }
}
