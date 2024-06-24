import 'package:flutter/material.dart';

class TextComposerScreen extends StatefulWidget {
  const TextComposerScreen({
    super.key,
    this.initialText,
    required this.submitText,
    required this.toHelp,
  });

  final String? initialText;
  final Function submitText;
  final VoidCallback toHelp;

  @override
  State<TextComposerScreen> createState() => _TextComposerScreenState();
}

class _TextComposerScreenState extends State<TextComposerScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.initialText ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compose text'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: widget.toHelp,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'What is in your mind?',
              ),
              minLines: 5,
              maxLines: null,
            ),
            ElevatedButton(
              onPressed: () => widget.submitText(_controller.text),
              child: const Text('Publish'),
            ),
            const Hero(
              tag: 'HERO',
              child: FlutterLogo(
                size: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
