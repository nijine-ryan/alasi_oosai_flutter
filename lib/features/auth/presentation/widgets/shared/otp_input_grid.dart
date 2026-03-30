import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';

class OtpInputGrid extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;

  const OtpInputGrid({super.key, this.length = 6, required this.onCompleted});

  @override
  State<OtpInputGrid> createState() => OtpInputGridState();
}

class OtpInputGridState extends State<OtpInputGrid> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        widget.onCompleted(_controllers.map((c) => c.text).join());
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(widget.length, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < widget.length - 1 ? 10 : 0),
            child: _OtpSingleInput(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              onChanged: (v) => _onChanged(v, index),
            ),
          ),
        );
      }),
    );
  }
}

class _OtpSingleInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpSingleInput({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  State<_OtpSingleInput> createState() => _OtpSingleInputState();
}

class _OtpSingleInputState extends State<_OtpSingleInput> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(
      () => setState(() => _isFocused = widget.focusNode.hasFocus),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: _isFocused ? colors.surface : colors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isFocused ? AuthColors.primary : colors.outlineVariant,
          width: _isFocused ? 1.5 : 1,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AuthColors.primary.withAlpha(40),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: colors.onSurface,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '',
              isCollapsed: true,
              hintText: '·',
            ),
            onChanged: widget.onChanged,
          ),
        ),
      ),
    );
  }
}
