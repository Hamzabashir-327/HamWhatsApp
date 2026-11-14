import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/auth_service.dart';
import '../core/countries.dart';
import '../core/theme.dart';
import 'otp_screen.dart';

/// One screen for both sign up and login, like WhatsApp.
class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  static const String route = '/phone';

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _controller = TextEditingController();
  Country _country = kCountries.first;
  bool _busy = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Digits without a leading 0, so 0332... and 332... both work.
  String get _digits => _controller.text
      .replaceAll(RegExp(r'\D'), '')
      .replaceFirst(RegExp(r'^0+'), '');

  bool get _valid =>
      _digits.length >= _country.minDigits &&
      _digits.length <= _country.maxDigits;

  String get _fullNumber => '${_country.code}$_digits';

  String get _prettyNumber => '${_country.code} $_digits';

  Future<void> _pickCountry() async {
    final picked = await showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _CountrySheet(),
    );
    if (picked != null) setState(() => _country = picked);
  }

  Future<void> _next() async {
    if (!_valid || _busy) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Is this number correct?'),
        content: Text(
          _prettyNumber,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await authService.sendOtp(_fullNumber);
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
      return;
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not send the code. Try again.')),
      );
      return;
    }
    if (!mounted) return;
    setState(() => _busy = false);
    Navigator.of(context).pushNamed(OtpScreen.route, arguments: _fullNumber);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Your phone number')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            children: [
              Center(
                child: Image.asset('assets/branding/hamwhatsapp-icon.png',
                    height: 84),
              ),
              const SizedBox(height: 20),
              Text(
                'Enter your phone number',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'HamWhatsApp will send an SMS to verify your number.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 28),
              Card(
                elevation: 0,
                color: theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: _pickCountry,
                      leading: Text(_country.flag,
                          style: const TextStyle(fontSize: 24)),
                      title: Text(_country.name),
                      trailing: const Icon(Icons.arrow_drop_down),
                    ),
                    Divider(height: 1, color: theme.colorScheme.outlineVariant),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            _country.code,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              autofocus: true,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(
                                    _country.maxDigits + 1),
                              ],
                              onChanged: (_) => setState(() {}),
                              onSubmitted: (_) => _next(),
                              style: const TextStyle(
                                  fontSize: 18, letterSpacing: 1),
                              decoration: const InputDecoration(
                                hintText: 'Phone number',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Carrier SMS charges may apply.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppColors.textMuted),
              ),
              const Spacer(),
              SizedBox(
                width: 200,
                child: FilledButton(
                  onPressed: _valid && !_busy ? _next : null,
                  child: _busy
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5, color: Colors.white),
                        )
                      : const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountrySheet extends StatefulWidget {
  const _CountrySheet();

  @override
  State<_CountrySheet> createState() => _CountrySheetState();
}

class _CountrySheetState extends State<_CountrySheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase();
    final list = kCountries
        .where((c) => c.name.toLowerCase().contains(q) || c.code.contains(q))
        .toList();
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search country',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, i) {
                final c = list[i];
                return ListTile(
                  leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
                  title: Text(c.name),
                  trailing: Text(c.code),
                  onTap: () => Navigator.pop(context, c),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
