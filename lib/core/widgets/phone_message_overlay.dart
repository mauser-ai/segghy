import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'typewriter_text.dart';

/// Mostra un messaggio anonimo come una notifica telefonica animata che
/// scivola dall'alto (con un lieve "rimbalzo"), invece che come semplice
/// prosa: rinforza l'atmosfera thriller in stile Duskwood nei momenti
/// chiave della storia. Si chiude con un tap, dopo aver letto il testo.
Future<void> showAnonymousMessage(BuildContext context, String message) {
  return showGeneralDialog(
    context: context,
    barrierLabel: 'Messaggio anonimo',
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    transitionDuration: const Duration(milliseconds: 550),
    pageBuilder: (context, animation, secondaryAnimation) {
      return _PhoneMessageCard(message: message);
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1.2),
          end: Offset.zero,
        ).animate(curved),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}

class _PhoneMessageCard extends StatefulWidget {
  final String message;
  const _PhoneMessageCard({required this.message});

  @override
  State<_PhoneMessageCard> createState() => _PhoneMessageCardState();
}

class _PhoneMessageCardState extends State<_PhoneMessageCard> {
  final _typewriter = TypewriterController();

  @override
  void initState() {
    super.initState();
    _typewriter.start(widget.message, charDelay: const Duration(milliseconds: 32));
  }

  @override
  void dispose() {
    _typewriter.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!_typewriter.isDone) {
      _typewriter.skipToEnd();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleTap,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHigh,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.accentGold, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentGold.withValues(alpha: 0.25),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.background,
                          ),
                          child: const Icon(Icons.sms_failed_rounded,
                              color: AppColors.accentGold, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Numero sconosciuto',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontSize: 14)),
                              Text('ora',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: AppColors.textMuted,
                                          fontSize: 11)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TypewriterText(
                      controller: _typewriter,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic, height: 1.4),
                    ),
                    const SizedBox(height: 10),
                    ListenableBuilder(
                      listenable: _typewriter,
                      builder: (context, _) => AnimatedOpacity(
                        opacity: _typewriter.isDone ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          'Tocca per chiudere',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.accentGold, fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
