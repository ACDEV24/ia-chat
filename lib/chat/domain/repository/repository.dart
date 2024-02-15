import 'package:ia_chat/chat/domain/entities/message.dart';
import 'package:oxidized/oxidized.dart';

abstract class ChatRepository {
  final String apiKey;
  final String promt;

  const ChatRepository({
    required this.apiKey,
    required this.promt,
  });

  Stream<Message> sendMessage(
    String clientName,
    String message,
    List<Message> lastMessages,
  );
  Future<Result<List<Message>, Exception>> getMessages();
}
