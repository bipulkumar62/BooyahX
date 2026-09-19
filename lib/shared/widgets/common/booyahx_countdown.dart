import 'dart:async';
import 'package:flutter/material.dart';
import 'package:booyahx/core/theme/app_colors.dart';
import 'package:booyahx/core/theme/app_text_styles.dart';

class BooyahXCountdown extends StatefulWidget {
  final Duration duration;
  final String? label;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool showLabel;
  final VoidCallback? onFinished;

  const BooyahXCountdown({
    super.key,
    required this.duration,
    this.label,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
    this.showLabel = true,
    this.onFinished,
  });

  @override
  State<BooyahXCountdown> createState() => _BooyahXCountdownState();
}

class _BooyahXCountdownState extends State<BooyahXCountdown> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds > 0) {
        setState(() {
          _remaining = _remaining - const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
        widget.onFinished?.call();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _formatted {
    final h = _remaining.inHours;
    final m = _remaining.inMinutes % 60;
    final s = _remaining.inSeconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}h : ${m.toString().padLeft(2, '0')}m : ${s.toString().padLeft(2, '0')}s';
    }
    return '${m.toString().padLeft(2, '0')}m : ${s.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.showLabel && widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.caption.copyWith(
              color: widget.textColor ?? AppColors.textMuted,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.borderColor ?? AppColors.border,
            ),
          ),
          child: Text(
            _formatted,
            style: AppTextStyles.labelNumeric.copyWith(
              color: widget.textColor ?? AppColors.primary,
              letterSpacing: 0.04,
            ),
          ),
        ),
      ],
    );
  }
}
