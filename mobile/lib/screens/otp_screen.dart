import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/auth_service.dart';
import '../core/theme.dart';
import 'profile_setup_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  static const String route = '/otp';

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const int _length = 6;
  static const int _resendSeconds = 45;

  final _controller = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  int _left = _resendSeconds;
  bool _verifying = false;
  bool _error = false;
  String _phone = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _phone = (ModalRoute.of(context)?.settings.arguments as String?) ?? '';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _left = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_left <= 1) {
        t.cancel();
      }
      if (mounted) setState(() => _left = _left > 0 ? _left - 1 : 0);
    });
  }

  Future<void> _onChanged(String value) async {
    setState(() => _error = false);
    if (value.length != _length || _verifying) return;
    setState(() => _verifying = true);
    final ok = await authService.verifyOtp(_phone, value);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pushReplacementNamed(ProfileSetupScreen.route);
    } else {
      setState(() {
        _verifying = false;
        _error = true;
      });
      _controller.clear();
    }
  }

  Future<void> _resend() async {
    await authService.sendOtp(_phone);
    if (mounted) _startTimer();
  }

  String get _timeText {
    final m = (_left ~/ 60).toString();
    final s = (_left % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final code = _controller.text;
    return Scaffold(
      appBar: AppBar(title: Text('Verify $_phone')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text.rich(
                TextSpan(
                  text: 'We sent an SMS with a 6-digit code to $_phone. ',
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text(
                          'Wrong number?',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () => _focus.requestFocus(),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_length, (i) {
                        final filled = i < code.length;
                        final active = i == code.length && !_verifying;
                        return Container(
                          width: 46,
                          height: 56,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _error
                                  ? theme.colorScheme.error
                                  : active
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.outlineVariant,
                              width: active || _error ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            filled ? code[i] : '',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w700),
                          ),
                        );
                      }),
                    ),
                    // Invisible field that receives typing and SMS autofill.
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0,
                        child: TextField(
                          controller: _controller,
                          focusNode: _focus,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          autofillHints: const [AutofillHints.oneTimeCode],
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(_length),
                          ],
                          onChanged: _onChanged,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_error)
                Text(
                  'Incorrect code. Please try again.',
                  style: TextStyle(color: theme.colorScheme.error),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _verifying
                          ? 'Verifying...'
                          : 'Waiting to detect the SMS automatically',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              const SizedBox(height: 28),
              TextButton.icon(
                onPressed: _left == 0 ? _resend : null,
                icon: const Icon(Icons.sms_outlined),
                label: Text(_left == 0 ? 'Resend SMS' : 'Resend SMS ($_timeText)'),
              ),
              const Spacer(),
              if (kDemoAuth)
                Text(
                  'Demo mode: no SMS is sent yet. Enter any 6 digits.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.textMuted),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
