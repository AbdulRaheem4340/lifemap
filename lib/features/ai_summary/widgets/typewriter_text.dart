import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration charDelay;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.charDelay = const Duration(milliseconds: 12),
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _visible = '';
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(covariant TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _visible = '';
      _index = 0;
      _start();
    }
  }

  Future<void> _start() async {
    final full = widget.text;
    while (mounted && _index < full.length) {
      await Future.delayed(widget.charDelay);
      if (!mounted) return;
      setState(() {
        _index++;
        _visible = full.substring(0, _index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _visible.isEmpty ? ' ' : _visible,
      style: widget.style,
    );
  }
}