import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../core/auth_service.dart';
import '../core/phone_utils.dart';
import '../core/theme.dart';

class _Entry {
  _Entry(this.contactName, this.phone, this.hamName);
  final String contactName;
  final String phone;
  final String? hamName; // null when the number has no account
}

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  static const String route = '/contacts';

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  bool _loading = true;
  bool _denied = false;
  String? _error;
  List<_Entry> _onApp = [];
  List<_Entry> _others = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final granted = await FlutterContacts.requestPermission(readonly: true);
      if (!granted) {
        if (mounted) {
          setState(() {
            _denied = true;
            _loading = false;
          });
        }
        return;
      }
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      final me = authService.phone;
      final cc = countryCodeOf(me);
      final byPhone = <String, String>{};
      for (final c in contacts) {
        for (final p in c.phones) {
          final n = normalizePhone(p.number, cc);
          if (n != null && n != me) {
            byPhone.putIfAbsent(
                n, () => c.displayName.isEmpty ? n : c.displayName);
          }
        }
      }
      final registered = await authService.findRegistered(byPhone.keys);
      final onApp = <_Entry>[];
      final others = <_Entry>[];
      byPhone.forEach((phone, name) {
        if (registered.containsKey(phone)) {
          onApp.add(_Entry(name, phone, registered[phone]));
        } else {
          others.add(_Entry(name, phone, null));
        }
      });
      int byName(_Entry a, _Entry b) =>
          a.contactName.toLowerCase().compareTo(b.contactName.toLowerCase());
      onApp.sort(byName);
      others.sort(byName);
      if (!mounted) return;
      setState(() {
        _denied = false;
        _onApp = onApp;
        _others = others;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load contacts. Pull down to try again.';
        _loading = false;
      });
    }
  }

  Widget _tile(_Entry e) {
    final theme = Theme.of(context);
    final onApp = e.hamName != null;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: onApp
            ? AppColors.accent.withOpacity(0.2)
            : theme.colorScheme.surfaceContainerHighest,
        child: Text(
          e.contactName.isEmpty ? '?' : e.contactName[0].toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: onApp ? AppColors.primary : AppColors.textMuted,
          ),
        ),
      ),
      title: Text(e.contactName),
      subtitle: Text(e.phone),
      trailing: onApp
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified, color: AppColors.accent, size: 20),
                const SizedBox(width: 4),
                Text(
                  'On HamWhatsApp',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            )
          : null,
      onTap: onApp
          ? () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Messaging is coming in Milestone 3.')),
              )
          : null,
    );
  }

  Widget _header(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_denied) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.contacts_outlined, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Allow contacts access to see which of your contacts are on HamWhatsApp.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton(onPressed: _load, child: const Text('Allow access')),
            ],
          ),
        ),
      );
    } else if (_error != null) {
      body = RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          children: [
            const SizedBox(height: 120),
            Center(child: Text(_error!)),
          ],
        ),
      );
    } else {
      body = RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          children: [
            _header('ON HAMWHATSAPP (${_onApp.length})'),
            if (_onApp.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('None of your contacts have joined yet.'),
              ),
            ..._onApp.map(_tile),
            if (_others.isNotEmpty) _header('NOT ON HAMWHATSAPP'),
            ..._others.map(_tile),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: body,
    );
  }
}
