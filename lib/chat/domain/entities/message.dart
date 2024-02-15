class Message {
  final String id;
  final String text;
  final MessageType type;
  final DateTime time;

  const Message({
    required this.id,
    required this.text,
    required this.type,
    required this.time,
  });

  Message copyWith({
    String? id,
    String? text,
    MessageType? type,
    DateTime? time,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      type: type ?? this.type,
      time: time ?? this.time,
    );
  }
}

enum MessageType { user, tulia }
