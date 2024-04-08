import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/ai/ai_assistant_provider.dart';
import 'package:watchlistfy/static/colors.dart';

class AIAssistantPage extends StatefulWidget {
  final String title;
  final String contentType;

  const AIAssistantPage(this.title, this.contentType, {super.key});

  @override
  State<AIAssistantPage> createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends State<AIAssistantPage> {
  DetailState _state = DetailState.init;

  late final AIAssistantProvider _assistantProvider;
  late final AuthenticationProvider authProvider;

  List<String> commands = [];

  void _getOpinion() {
    setState(() {
      _state = DetailState.loading;
    });

    _assistantProvider.getOpinion(widget.title, widget.contentType).then((response) {

      if (_state != DetailState.disposed) {
        setState(() {
          _state = DetailState.view;
        });
      }
    });
  }

  void _getSummary() {
    setState(() {
      _state = DetailState.loading;
    });

    _assistantProvider.getSummarize(widget.title, widget.contentType).then((response) {
      if (_state != DetailState.disposed) {
        setState(() {
          _state = DetailState.view;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _assistantProvider = AIAssistantProvider();
  }

  @override
  void dispose() {
    _state = DetailState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == DetailState.init) {
      authProvider = Provider.of<AuthenticationProvider>(context);
    }
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _assistantProvider,
      child: Consumer<AIAssistantProvider>(
        builder: (context, provider, child) {
          final isOpinionAsked = provider.items.where((element) => element.message == "What is general opinion about it?").isNotEmpty;
          final isSummarized = provider.items.where((element) => element.message == "Summarize the content.").isNotEmpty;

          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(widget.title),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          maxRadius: 22,
                          backgroundColor: CupertinoTheme.of(context).onBgColor,
                          foregroundColor: CupertinoTheme.of(context).onBgColor,
                          child: const Text("🤖", style: TextStyle(fontSize: 22),),
                        ),
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              BubbleSpecialOne(
                                text: "Welcome to AI Assistant, you can click the buttons and get response.",
                                color: CupertinoTheme.of(context).bgTextColor,
                                tail: true,
                                isSender: false,
                                textStyle: TextStyle(color: CupertinoTheme.of(context).bgColor, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _state == DetailState.loading ? provider.items.length + 1 : provider.items.length,
                      itemBuilder: (context, index) {
                        if (_state == DetailState.loading && index == provider.items.length) {
                          return BubbleSpecialOne(
                            text: "Generating the response...",
                            color: AppColors().primaryColor,
                            tail: true,
                            isSender: false,
                            textStyle: const TextStyle(color: CupertinoColors.white, fontSize: 14),
                          );
                        }
                        final data = provider.items[index];

                        return BubbleSpecialOne(
                          text: data.message,
                          color: data.isAIResponse ? AppColors().primaryColor : CupertinoTheme.of(context).bgTextColor,
                          tail: true,
                          isSender: !data.isAIResponse,
                          textStyle: TextStyle(color: data.isAIResponse ? CupertinoColors.white : CupertinoTheme.of(context).bgColor, fontSize: 15),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CupertinoButton.filled(
                            minSize: 0,
                            padding: const EdgeInsets.all(12),
                            onPressed: isSummarized ? null : (){
                              _getSummary();
                            },
                            child: const Text("Summarize the content.", style: TextStyle(color: CupertinoColors.white)),
                          ),
                          const SizedBox(height: 6),
                          CupertinoButton.filled(
                            minSize: 0,
                            padding: const EdgeInsets.all(12),
                            onPressed: isOpinionAsked ? null : (){
                              _getOpinion();
                            },
                            child: const Text("What is general opinion about it?", style: TextStyle(color: CupertinoColors.white)),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
