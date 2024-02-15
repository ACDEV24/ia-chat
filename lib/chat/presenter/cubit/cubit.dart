import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ia_chat/chat/domain/entities/message.dart';
import 'package:ia_chat/chat/domain/usecase/usecase.dart';
import 'package:ia_chat/chat/repository/models/message.dart';

part 'state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatUsecase usecase;
  ChatCubit({
    required this.usecase,
  }) : super(const ChatInitialState(Model()));

  void onOpen() async {
    final stream = usecase.onOpen();

    stream.listen((messages) {
      emit(
        MessageReceivedState(
          state.model.copyWith(
            messages: [...messages],
          ),
        ),
      );
    });
  }

  void sendMessage(String message) async {
    final chatMessage = ChatMessage(
      id: '',
      text: message,
      type: MessageType.user,
      time: DateTime.now(),
    );

    final stream = usecase.sendMessage(state.model.messages, chatMessage);

    stream.listen((messages) {
      emit(
        MessageReceivedState(
          state.model.copyWith(
            messages: [...messages],
          ),
        ),
      );
    });
  }

  void setMessageText(String message) {
    emit(
      SetMessageTextState(
        state.model.copyWith(
          message: message,
        ),
      ),
    );
  }
}
