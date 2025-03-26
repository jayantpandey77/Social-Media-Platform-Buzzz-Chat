import 'dart:io';
import 'package:buzzzchat/utils.dart';
import 'package:buzzzchat/features/chats/widget/message_reply_preview.dart';
import 'package:buzzzchat/models/message.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:buzzzchat/features/chats/message_reply.dart';
import 'package:buzzzchat/features/chats/controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;

  const BottomChatField({
    super.key,
    required this.recieverUserId,
    required this.isGroupChat,
  });

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isShowEmojiContainer = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  Future<void> openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder?.openRecorder();
    isRecorderInit = true;
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.recieverUserId,
            widget.isGroupChat,
          );
      setState(() {
        _messageController.clear();
        isShowSendButton = false;
      });
    } else {
      if (!isRecorderInit) return;

      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';

      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        await Future.delayed(
            const Duration(milliseconds: 500)); // Ensure file is saved
        File audioFile = File(path);
        if (await audioFile.exists()) {
          sendFileMessage(audioFile, MessageEnum.audio);
        }
      } else {
        await _soundRecorder!.startRecorder(toFile: path);
      }

      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.recieverUserId,
          messageEnum,
          widget.isGroupChat,
        );
  }

  Future<void> selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) sendFileMessage(image, MessageEnum.image);
  }

  Future<void> selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) sendFileMessage(video, MessageEnum.video);
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    hideKeyboard();
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      showEmojiContainer();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _soundRecorder?.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;

    return Column(
      children: [
        if (isShowMessageReply) const MessageReplyPreview(),
        Padding(
          padding: const EdgeInsets.all(7.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: const TextStyle(color: Colors.black),
                  focusNode: focusNode,
                  controller: _messageController,
                  onChanged: (val) {
                    setState(() {
                      isShowSendButton = val.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(144, 158, 158, 158),
                    prefixIcon: IconButton(
                      onPressed: toggleEmojiKeyboardContainer,
                      icon: const Icon(Icons.emoji_emotions_outlined,
                          color: Colors.black),
                    ),
                    suffixIcon: IntrinsicWidth(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: selectImage,
                            icon: const Icon(Icons.camera_alt,
                                color: Colors.black),
                          ),
                          IconButton(
                            onPressed: selectVideo,
                            icon: const Icon(Icons.attach_file,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    hintText: 'Type a message!',
                    hintStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(5),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: CircleAvatar(
                  backgroundColor: const Color.fromRGBO(254, 177, 11, 1),
                  radius: 20,
                  child: GestureDetector(
                    onTap: sendTextMessage,
                    child: Icon(
                      isShowSendButton
                          ? Icons.send
                          : isRecording
                              ? Icons.close
                              : Icons.mic,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isShowEmojiContainer)
          SizedBox(
            height: 310,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                setState(() {
                  _messageController.text += emoji.emoji;
                  isShowSendButton = true;
                });
              },
            ),
          ),
      ],
    );
  }
}
