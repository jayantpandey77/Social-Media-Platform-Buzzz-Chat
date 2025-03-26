import 'package:buzzzchat/features/chats/widget/display_text_image_gif.dart';
import 'package:buzzzchat/models/message.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.type,
    required this.onRightSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
  });

  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;

    return SwipeTo(
      onRightSwipe: (_) => onRightSwipe(),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
            minWidth: MediaQuery.of(context).size.width * 0.3,
          ),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.white, // Message box is now white
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Padding(
              padding: type == MessageEnum.text
                  ? const EdgeInsets.fromLTRB(12, 8, 40, 22)
                  : const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isReplying) ...[
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Dark text for contrast
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            Colors.grey[200], // Light grey for reply background
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DisplayTextImageGIF(
                        message: repliedText,
                        type: repliedMessageType,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Flexible(
                    child: DisplayTextImageGIF(
                      message: message,
                      type: type,
                    ),
                  ),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
