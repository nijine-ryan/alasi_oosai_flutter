import 'dart:async';
import 'package:flutter/material.dart';
import 'package:alai_oosai/features/auth/data/auth_colors.dart';

class OtpResendRow extends StatefulWidget {
  final int countdownSeconds;
  final VoidCallback onResend;

  const OtpResendRow({
    super.key,
    this.countdownSeconds = 45,
    required this.onResend,
  });

  @override
  State<OtpResendRow> createState() => OtpResendRowState();
}

class OtpResendRowState extends State<OtpResendRow> {
  late int _secondsLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.countdownSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _onResendTap() {
    if (_secondsLeft > 0) return;
    setState(() => _secondsLeft = widget.countdownSeconds);
    _startTimer();
    widget.onResend();
  }

  String get _formattedTime {
    final mins = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final secs = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AuthColors.of(context);
    final canResend = _secondsLeft == 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive the code? ",
          style: TextStyle(
            fontSize: 13,
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: _onResendTap,
          child: Text(
            canResend ? 'Resend' : 'Resend in $_formattedTime',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: canResend ? AuthColors.primary : colors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
