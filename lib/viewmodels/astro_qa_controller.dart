import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/network/api_exceptions.dart';
import '../../data/models/qa_answer.dart';
import '../../data/repositories/astro_qa_repository.dart';

class ChatMessage {
  final bool fromUser;
  final String text;
  final List<QASource> sources;
  final bool failed;

  const ChatMessage({
    required this.fromUser,
    required this.text,
    this.sources = const [],
    this.failed = false,
  });
}

class AstroQaController extends GetxController {
  final _repository = Get.find<AstroQaRepository>();

  final RxList<ChatMessage> messages = RxList<ChatMessage>([]);
  final RxBool thinking = RxBool(false);
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  static const List<String> suggestions = [
    'Will I get married soon?',
    'What does my moon sign say about love?',
    'How compatible are we astrologically?',
    'Which partner is best for my sun sign?',
    'What should I look for in an ideal match?',
  ];

  @override
  void onClose() {
    inputController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void askSuggestion(String question) {
    inputController.text = question;
    send();
  }

  void askAbout(String partnerName) {
    askSuggestion('How compatible am I with $partnerName?');
  }

  Future<bool> send({String? question}) async {
    final text = (question ?? inputController.text).trim();
    if (text.isEmpty || thinking.value) return false;
    messages.add(ChatMessage(fromUser: true, text: text));
    inputController.clear();
    thinking.value = true;
    _scrollToBottom();
    try {
      final answer = await _repository.ask(text);
      messages.add(
        ChatMessage(
          fromUser: false,
          text: answer.answer,
          sources: answer.sources,
        ),
      );
    } on ApiException catch (e) {
      messages.add(ChatMessage(fromUser: false, text: e.message, failed: true));
    } catch (_) {
      messages.add(
        const ChatMessage(
          fromUser: false,
          text: 'I could not reach the astrologer right now. Please try again.',
          failed: true,
        ),
      );
    } finally {
      thinking.value = false;
      _scrollToBottom();
    }
    return true;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
