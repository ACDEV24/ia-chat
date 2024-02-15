import 'package:iaq/chat/domain/entities/message.dart';

class ChatMessage extends Message {
  const ChatMessage({
    required super.id,
    required super.text,
    required super.type,
    required super.time,
  });

  @override
  Message copyWith({
    String? id,
    String? text,
    MessageType? type,
    DateTime? time,
  }) {
    return ChatMessage(
      id: id ?? super.id,
      text: text ?? super.text,
      type: type ?? super.type,
      time: time ?? super.time,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatMessage &&
        other.id == id &&
        other.text == text &&
        other.type == type &&
        other.time == time;
  }

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      text.hashCode ^
      type.hashCode ^
      time.hashCode;
}

class ChatCompletion {
  String id;
  String object;
  int created;
  String model;
  dynamic systemFingerprint;
  List<Choice> choices;

  ChatCompletion({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    this.systemFingerprint,
    required this.choices,
  });

  factory ChatCompletion.fromJson(Map<String, dynamic> json) {
    return ChatCompletion(
      id: json['id'],
      object: json['object'],
      created: json['created'],
      model: json['model'],
      systemFingerprint: json['system_fingerprint'],
      choices: List<Choice>.from(
        json['choices'].map((x) => Choice.fromJson(x)),
      ),
    );
  }

  String? get content {
    if (choices.isNotEmpty) {
      return choices.last.delta?.content;
    }
    return null;
  }

  ChatMessage get toChatMessage {
    return ChatMessage(
      id: id,
      text: content ?? '',
      type: MessageType.tulia,
      time: DateTime.fromMillisecondsSinceEpoch(created * 1000, isUtc: true),
    );
  }
}

class Choice {
  int index;
  Delta? delta;
  dynamic logprobs;
  dynamic finishReason;

  Choice({
    required this.index,
    this.delta,
    this.logprobs,
    this.finishReason,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      index: json['index'],
      delta: json['delta'] == null ? null : Delta.fromJson(json['delta']),
      logprobs: json['logprobs'],
      finishReason: json['finish_reason'],
    );
  }
}

class Delta {
  String content;

  Delta({required this.content});

  factory Delta.fromJson(Map<String, dynamic> json) {
    return Delta(
      content: json['content'] ?? '',
    );
  }
}
