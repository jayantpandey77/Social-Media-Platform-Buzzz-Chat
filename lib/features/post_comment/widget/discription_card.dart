import 'package:flutter/material.dart';

class DiscriptionCard extends StatefulWidget {
  final String text;
  const DiscriptionCard({Key? key, required this.text}) : super(key: key);

  @override
  State<DiscriptionCard> createState() => _DiscriptionCardState();
}

class _DiscriptionCardState extends State<DiscriptionCard> {
  bool show = false;

  void _toggleExpand() {
    setState(() {
      show = !show;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpand,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        child: Text(
          widget.text,
          maxLines: show ? null : 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
