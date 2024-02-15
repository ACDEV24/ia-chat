import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iaq/chat/domain/entities/message.dart';
import 'package:iaq/chat/domain/usecase/usecase.dart';
import 'package:iaq/chat/presenter/cubit/cubit.dart';
import 'package:iaq/chat/presenter/widgets/link_text.dart';
import 'package:iaq/chat/repository/repository.dart';
import 'package:iaq/chat/shared/constants/regex.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(
        usecase: ChatUsecase(
          repository: ChatRepositoryImpl(),
        ),
      )..onOpen(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Image.asset(
                  'assets/tulia.png',
                  height: 150.0,
                ),
              ),
              const _Messages(),
              const Align(
                alignment: Alignment.bottomCenter,
                child: _Input(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Messages extends StatelessWidget {
  const _Messages();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          final scrollController = ScrollController();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });

          return ListView.builder(
            controller: scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.only(bottom: 80.0),
            itemCount: state.model.messages.length,
            itemBuilder: (context, index) {
              final message = state.model.messages[index];

              return Align(
                alignment: message.type == MessageType.user
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _MessageItem(
                    message: message.text,
                    time: message.time,
                    type: message.type == MessageType.user
                        ? ChatMessageType.sent
                        : ChatMessageType.received,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _Input extends StatelessWidget {
  const _Input();

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  labelText: 'Type a message',
                ),
                maxLines: null,
                onSubmitted: (value) {
                  if (value.isEmpty) return;

                  context.read<ChatCubit>().sendMessage(value);

                  controller.clear();
                },
                onChanged: (value) {
                  context.read<ChatCubit>().setMessageText(value);
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                if (controller.text.isEmpty) return;

                context.read<ChatCubit>().sendMessage(controller.text);

                controller.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum ChatMessageType { sent, received }

class _MessageItem extends StatelessWidget {
  final String message;
  final DateTime time;
  final ChatMessageType type;

  const _MessageItem({
    Key? key,
    required this.message,
    required this.time,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSent = type == ChatMessageType.sent;

    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isSent ? const Color(0xff00533D) : const Color(0xffe5e5e5),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            MatchText(
              text: message,
              textStyle: TextStyle(
                color: isSent ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
              expressions: [
                Expression(
                  regExp: CustomRegex.link,
                  textStyle: const TextStyle(
                    color: Colors.blue,
                    fontSize: 16.0,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              '${time.hour}:${time.minute}',
              style: TextStyle(
                color: isSent ? Colors.white70 : Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
