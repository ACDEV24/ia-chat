import 'dart:async';

import 'package:ia_chat/chat/domain/entities/message.dart';
import 'package:ia_chat/chat/domain/repository/repository.dart';
import 'package:oxidized/oxidized.dart';

class ChatUsecase {
  final ChatRepository repository;
  ChatUsecase({
    required this.repository,
  });

  Future<Result<List<Message>, Exception>> getMessages() async {
    try {
      final messages = await repository.getMessages();

      return Result.ok(messages.unwrap());
    } catch (e) {
      return Result.err(Exception(e.toString()));
    }
  }

  Stream<List<Message>> sendMessage(
    List<Message> messages,
    Message message,
  ) async* {
    final messagesCopy = [...messages];
    messagesCopy.add(message);

    yield messagesCopy;

    final messageStream = repository.sendMessage(
      'Andres',
      message.text,
      messages,
    );

    yield* messageStream.map((message) {
      if (message.text.isEmpty) {
        return messagesCopy;
      }

      final messageIndex = messagesCopy.indexWhere(
        (element) => element.id == message.id,
      );

      Message currentMessage;

      if (messageIndex == -1) {
        currentMessage = Message(
          id: message.id,
          text: message.text,
          time: message.time,
          type: MessageType.assistant,
        );

        messagesCopy.add(currentMessage);
      } else {
        currentMessage = messagesCopy[messageIndex];
        currentMessage = currentMessage.copyWith(
          text: messagesCopy[messageIndex].text + message.text,
        );

        messagesCopy[messageIndex] = currentMessage;
      }

      return messagesCopy;
    });
  }

  Stream<List<Message>> onOpen() async* {
    const helloMessage = 'Hi, I am your assistant. How can I help you today?';

    String message = '';

    for (var text in helloMessage.split(' ')) {
      message += '$text ';

      yield [
        Message(
          id: 'first-message',
          text: message,
          time: DateTime.now(),
          type: MessageType.assistant,
        ),
      ];

      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
}
