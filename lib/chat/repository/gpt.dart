import 'dart:async';
import 'dart:convert';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:ia_chat/chat/domain/entities/message.dart';
import 'package:ia_chat/chat/domain/repository/repository.dart';
import 'package:ia_chat/chat/repository/models/message.dart';
import 'package:oxidized/oxidized.dart';

class ChatRepositoryGPT extends ChatRepository {
  const ChatRepositoryGPT({
    required String apiKey,
    required String promt,
  }) : super(apiKey: apiKey, promt: promt);

  @override
  Future<Result<List<Message>, Exception>> getMessages() {
    throw UnimplementedError();
  }

  @override
  Stream<Message> sendMessage(
    String clientName,
    String message,
    List<Message> lastMessages,
  ) async* {
    final emptyMessage = ChatMessage(
      id: DateTime.now().toString(),
      text: '',
      time: DateTime.now(),
      type: MessageType.assistant,
    );

    yield* SSEClient.subscribeToSSE(
      method: SSERequestType.POST,
      url: 'https://api.openai.com/v1/chat/completions',
      body: {
        'model': 'gpt-3.5-turbo-1106',
        'stream': true,
        'temperature': 1.0,
        'messages': [
          {'role': 'system', 'content': promt},
          ...lastMessages.map((m) {
            return {
              'role': m.type == MessageType.assistant ? 'assistant' : 'user',
              'content': m.text,
            };
          }).toList(),
          {'role': 'user', 'content': message, 'name': clientName}
        ]
      },
      header: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
        'OpenAI-Organization': 'YOUR_ORGANIZATION_ID',
      },
    ).map(
      (event) {
        if (event.data == null) {
          return emptyMessage;
        }

        if (event.data!.contains('[DONE]') ||
            event.data!.contains('[ERROR]') ||
            event.data!.isEmpty) {
          return emptyMessage;
        }

        final data = json.decode(event.data ?? '');
        final message = ChatCompletion.fromJson(data).toChatMessage;

        return message;
      },
    );
  }
}
