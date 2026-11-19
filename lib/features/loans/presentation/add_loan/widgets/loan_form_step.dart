import 'package:flutter/material.dart';

class LoanFormStep extends StatelessWidget {
  const LoanFormStep({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    required this.footer,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                ...children,
              ],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 14),
              child: footer,
            ),
          ),
        ),
      ],
    );
  }
}

class LoanFormActions extends StatelessWidget {
  const LoanFormActions({
    super.key,
    this.onBack,
    required this.onContinue,
    this.continueLabel = 'Continue',
    this.loading = false,
  });

  final VoidCallback? onBack;
  final VoidCallback? onContinue;
  final String continueLabel;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onBack != null) ...[
          Expanded(
            child: OutlinedButton(
              onPressed: loading ? null : onBack,
              child: const Text('Back'),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          flex: onBack == null ? 1 : 2,
          child: FilledButton(
            onPressed: loading ? null : onContinue,
            child: loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(continueLabel),
          ),
        ),
      ],
    );
  }
}
