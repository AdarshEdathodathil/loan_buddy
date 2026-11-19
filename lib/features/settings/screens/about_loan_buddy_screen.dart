import 'package:flutter/material.dart';
import 'package:loan_buddy/shared/widgets/app_page.dart';

class AboutLoanBuddyScreen extends StatelessWidget {
  const AboutLoanBuddyScreen({super.key});

  static const version = '1.0.0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Loan Buddy')),
      body: SafeArea(
        top: false,
        child: AppPage(
          maxWidth: 800,
          child: ListView(
            children: const [
              _AboutHero(),
              SizedBox(height: 28),
              _FeatureSection(
                title: 'Loan management',
                icon: Icons.account_balance_wallet_outlined,
                features: [
                  'Create and edit loans with a guided four-step form.',
                  'Track lender, loan type, amounts, interest, EMI, term, due date, and notes.',
                  'Search loans and filter them by active or closed status.',
                  'Review repayment progress, schedules, and complete loan details.',
                ],
              ),
              _FeatureSection(
                title: 'Payments and balances',
                icon: Icons.payments_outlined,
                features: [
                  'Record EMI payments, part payments, and foreclosure.',
                  'Update balances automatically and close fully paid loans.',
                  'Review payment history and reverse an incorrect payment.',
                  'Track partial EMIs without marking them fully paid too early.',
                ],
              ),
              _FeatureSection(
                title: 'Dashboard',
                icon: Icons.dashboard_outlined,
                features: [
                  'See total borrowed, outstanding, and repaid amounts.',
                  'Review active loans, closed loans, monthly EMI, and loan count.',
                  'See the next EMI and open recent loans quickly.',
                ],
              ),
              _FeatureSection(
                title: 'EMI calendar and reminders',
                icon: Icons.calendar_month_outlined,
                features: [
                  'Browse a monthly calendar with every EMI due date marked.',
                  'View the respective month’s EMI total and payment list.',
                  'Handle shorter month-end dates automatically.',
                  'Enable configurable local reminders for individual loans.',
                ],
              ),
              _FeatureSection(
                title: 'Insights and payoff planning',
                icon: Icons.insights_outlined,
                features: [
                  'Monitor repayment progress and overall loan health.',
                  'Explore payment trends and an estimated debt-free date.',
                  'Simulate extra monthly repayments.',
                  'Compare avalanche, snowball, lowest EMI, earliest finish, and smart approaches.',
                  'See highlights such as upcoming dues and high-impact loans.',
                ],
              ),
              _FeatureSection(
                title: 'Personalization and accessibility',
                icon: Icons.tune_outlined,
                features: [
                  'Choose light, dark, or system appearance.',
                  'Choose the ledger currency before creating loans.',
                  'Use responsive phone, tablet, and desktop layouts.',
                  'Use labelled controls and calendar dates with screen readers.',
                ],
              ),
              _NoticeCard(
                icon: Icons.shield_outlined,
                title: 'Private by design',
                message:
                    'Loan Buddy does not require an account. Loan and payment data is stored locally on your device. Device-level backups remain subject to your operating-system settings.',
              ),
              SizedBox(height: 16),
              _NoticeCard(
                icon: Icons.info_outline_rounded,
                title: 'Important information',
                message:
                    'Payoff dates, health indicators, and repayment suggestions are estimates based on the information you enter. They are not financial advice.',
              ),
              SizedBox(height: 28),
              _VersionFooter(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutHero extends StatelessWidget {
  const _AboutHero();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              size: 38,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 18),
          Text('Loan Buddy', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'A private, offline-first companion for understanding loans, '
            'tracking repayments, and planning a clearer path out of debt.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureSection extends StatelessWidget {
  const _FeatureSection({
    required this.title,
    required this.icon,
    required this.features,
  });

  final String title;
  final IconData icon;
  final List<String> features;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: theme.colorScheme.secondary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(title, style: theme.textTheme.titleLarge),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...features.map(
                (feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 18,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          feature,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.onSecondaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 5),
                Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionFooter extends StatelessWidget {
  const _VersionFooter();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text('Version ${AboutLoanBuddyScreen.version}'),
        const SizedBox(height: 5),
        Text(
          'Made to make debt easier to understand.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
