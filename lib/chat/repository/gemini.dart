import 'dart:async';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:ia_chat/chat/domain/entities/message.dart';
import 'package:ia_chat/chat/domain/repository/repository.dart';
import 'package:oxidized/oxidized.dart';

class ChatRepositoryGemini extends ChatRepository {
  final token = 'YOUR_OPENAI_API_KEY';
  final promt = '''YOUR_PROMPT''';

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
    final apiKey = Platform.environment['API_KEY'];
    if (apiKey == null) {
      exit(1);
    }

    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.5,
        topP: 1.0,
        topK: 40,
        stopSequences: ['\n'],
      ),
    );

    final content = [
      Content.text('''YOUR_PROMPT'''),
      ...lastMessages.map((e) => Content.text(e.text)),
    ];

    yield* model.generateContentStream(content).map((content) {
      return Message(
        text: content.text ?? '',
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        time: DateTime.now(),
        type: MessageType.assistant,
      );
    });
  }
}
