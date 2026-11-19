import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/analytics/providers/analytics_provider.dart';
import 'package:loan_buddy/features/analytics/providers/payment_analytics_provider.dart';
import 'package:loan_buddy/features/analytics/providers/smart_insights_provider.dart';
import 'package:loan_buddy/features/analytics/services/debt_forecast_calculator.dart';
import 'package:loan_buddy/features/analytics/services/loan_health_calculator.dart';
import 'package:loan_buddy/features/analytics/widgets/debt_forecast_card.dart';
import 'package:loan_buddy/features/analytics/widgets/emi_trend_chart.dart';
import 'package:loan_buddy/features/analytics/widgets/extra_emi_simulator.dart';
import 'package:loan_buddy/features/analytics/widgets/loan_health_card.dart';
import 'package:loan_buddy/features/analytics/widgets/loan_health_chart.dart';
import 'package:loan_buddy/features/analytics/widgets/repayment_progress_card.dart';
import 'package:loan_buddy/features/analytics/widgets/repayment_strategy_selector.dart';
import 'package:loan_buddy/features/analytics/widgets/smart_insights_card.dart';
import 'package:loan_buddy/features/analytics/widgets/smart_repayment_advisor_card.dart';
import 'package:loan_buddy/features/payoff/providers/debt_payoff_provider.dart';
import 'package:loan_buddy/features/payoff/widgets/debt_payoff_card.dart';
import 'package:loan_buddy/shared/widgets/app_page.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);
    final trend = ref.watch(monthlyEmiTrendProvider);
    final insights = ref.watch(smartInsightsProvider);
    final payoff = ref.watch(debtPayoffProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: SafeArea(
        top: false,
        child: analytics.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => AppEmptyState(
            icon: Icons.insights_outlined,
            title: 'Insights are unavailable',
            message: 'Please try again after reopening this screen.',
          ),
          data: (dashboard) {
            final data = dashboard.analytics;
            if (data.activeLoans == 0) {
              return const AppPage(
                child: AppEmptyState(
                  icon: Icons.auto_graph_rounded,
                  title: 'Add a loan to unlock insights',
                  message:
                      'Loan health, payoff forecasts, and repayment recommendations will appear here.',
                ),
              );
            }

            final health = LoanHealthCalculator.calculate(data);
            final forecast = DebtForecastCalculator.calculate(data);
            final advice = dashboard.repaymentAdvice;

            return AppPage(
              child: ListView(
                children: [
                  Text(
                    'A clearer path out of debt',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Explore your progress, projections, and the next best action.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _EstimateNotice(),
                  const SizedBox(height: 26),
                  const AppSectionHeader(
                    title: 'Financial health',
                    subtitle: 'A snapshot of your current repayment position.',
                  ),
                  const SizedBox(height: 14),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 760;
                      if (!wide) {
                        return Column(
                          children: [
                            LoanHealthCard(health: health),
                            const SizedBox(height: 14),
                            DebtForecastCard(forecast: forecast),
                          ],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: LoanHealthCard(health: health)),
                          const SizedBox(width: 14),
                          Expanded(child: DebtForecastCard(forecast: forecast)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  const AppSectionHeader(
                    title: 'Payoff plan',
                    subtitle:
                        'Choose how to direct extra money toward your loans.',
                  ),
                  const SizedBox(height: 14),
                  const RepaymentStrategySelector(),
                  if (advice != null) ...[
                    const SizedBox(height: 14),
                    SmartRepaymentAdvisorCard(advice: advice),
                  ],
                  const SizedBox(height: 14),
                  payoff.when(
                    data: (result) => DebtPayoffCard(result: result),
                    loading: () => const Card(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    error: (error, _) =>
                        _InlineError(message: error.toString()),
                  ),
                  const SizedBox(height: 14),
                  ExtraEmiSimulator(analytics: data),
                  const SizedBox(height: 30),
                  const AppSectionHeader(
                    title: 'Trends',
                    subtitle:
                        'See how your debt and monthly payments are changing.',
                  ),
                  const SizedBox(height: 14),
                  LoanHealthChart(data: data),
                  const SizedBox(height: 14),
                  RepaymentProgressCard(data: data),
                  const SizedBox(height: 14),
                  trend.when(
                    data: (items) => EmiTrendChart(data: items),
                    loading: () => const Card(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    error: (error, _) =>
                        _InlineError(message: error.toString()),
                  ),
                  const SizedBox(height: 30),
                  const AppSectionHeader(
                    title: 'Highlights',
                    subtitle: 'Useful details from across your active loans.',
                  ),
                  const SizedBox(height: 14),
                  insights.when(
                    data: (value) => SmartInsightsCard(insights: value),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) =>
                        _InlineError(message: error.toString()),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('This calculation is temporarily unavailable.'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EstimateNotice extends StatelessWidget {
  const _EstimateNotice();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Important information about financial estimates',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.secondaryContainer,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline_rounded, color: colors.secondary),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Payoff dates and recommendations are estimates based on the '
                'details you entered. They are not financial advice.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
