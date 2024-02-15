part of 'cubit.dart';

abstract class ChatState extends Equatable {
  final Model model;
  const ChatState(this.model);

  @override
  List<Object> get props => [model];
}

final class ChatInitialState extends ChatState {
  const ChatInitialState(super.model);
}

final class SetMessageTextState extends ChatState {
  const SetMessageTextState(super.model);
}

final class MessageReceivedState extends ChatState {
  const MessageReceivedState(super.model);
}

class Model extends Equatable {
  final String message;
  final List<Message> messages;

  const Model({
    this.message = '',
    this.messages = const [],
  });

  Model copyWith({
    String? message,
    List<Message>? messages,
  }) {
    return Model(
      message: message ?? this.message,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object> get props {
    return [
      message,
      messages,
    ];
  }
}
