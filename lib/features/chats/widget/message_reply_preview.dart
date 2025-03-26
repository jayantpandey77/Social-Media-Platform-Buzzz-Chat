import 'package:buzzzchat/features/chats/message_reply.dart';
import 'package:buzzzchat/features/chats/widget/display_text_image_gif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);

    return Container(
      width: 350,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  messageReply!.isMe ? 'Me' : 'Opposite',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                child: const Icon(
                  Icons.close,
                  size: 16,
                ),
                onTap: () => cancelReply(ref),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DisplayTextImageGIF(
            message: messageReply.message,
            type: messageReply.messageEnum,
          ),
        ],
      ),
    );
  }
}
// import 'package:buzzzchat/features/chats/message_reply.dart';
// import 'package:buzzzchat/features/chats/widget/display_text_image_gif.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class MessageReplyPreview extends ConsumerWidget {
//   const MessageReplyPreview({super.key});

//   void cancelReply(WidgetRef ref) {
//     ref.read(messageReplyProvider.notifier).update((state) => null);
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final messageReply = ref.watch(messageReplyProvider);

//     if (messageReply == null) return const SizedBox(); // Prevents crashes

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade200, // Subtle background color
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(12),
//           topRight: Radius.circular(12),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 5,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   messageReply.isMe ? 'Me' : 'Opposite',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () => cancelReply(ref),
//                 borderRadius: BorderRadius.circular(20),
//                 child: const Padding(
//                   padding: EdgeInsets.all(4),
//                   child: Icon(Icons.close, size: 18, color: Colors.black54),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           DisplayTextImageGIF(
//             message: messageReply.message,
//             type: messageReply.messageEnum,
//           ),
//         ],
//       ),
//     );
//   }
// }
