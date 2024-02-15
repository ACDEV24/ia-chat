import 'package:iaq/chat/domain/entities/message.dart';
import 'package:oxidized/oxidized.dart';

abstract class ChatRepository {
  Stream<Message> sendMessage(
    String clientName,
    String message,
    List<Message> lastMessages,
  );
  Future<Result<List<Message>, Exception>> getMessages();
}
