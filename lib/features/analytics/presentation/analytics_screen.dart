import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/core/widgets/dashboard_section.dart';
import 'package:loan_buddy/features/analytics/providers/analytics_provider.dart';
import 'package:loan_buddy/features/analytics/providers/smart_insights_provider.dart';
import 'package:loan_buddy/features/analytics/widgets/loan_health_chart.dart';
import 'package:loan_buddy/features/analytics/widgets/repayment_strategy_selector.dart';
import 'package:loan_buddy/features/analytics/widgets/smart_insights_card.dart';
import 'package:loan_buddy/features/analytics/widgets/repayment_progress_card.dart';
import 'package:loan_buddy/features/analytics/providers/payment_analytics_provider.dart';
import 'package:loan_buddy/features/analytics/widgets/emi_trend_chart.dart';
import 'package:loan_buddy/features/analytics/services/loan_health_calculator.dart';
import 'package:loan_buddy/features/analytics/widgets/loan_health_card.dart';
import 'package:loan_buddy/features/analytics/services/debt_forecast_calculator.dart';
import 'package:loan_buddy/features/analytics/widgets/debt_forecast_card.dart';
import 'package:loan_buddy/features/analytics/widgets/extra_emi_simulator.dart';
import 'package:loan_buddy/features/analytics/widgets/smart_repayment_advisor_card.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendAsync = ref.watch(monthlyEmiTrendProvider);
    final analytics = ref.watch(analyticsProvider);
    final insightsAsync = ref.watch(smartInsightsProvider);
    // final advice = SmartRepaymentAdvisor.generate(loans);

    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      body: analytics.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (dashboard) {
          final data = dashboard.analytics;
          final advice = dashboard.repaymentAdvice;

          final health = LoanHealthCalculator.calculate(data);
          final forecast = DebtForecastCalculator.calculate(data);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (advice != null) ...[
                SmartRepaymentAdvisorCard(advice: advice),
                const SizedBox(height: 20),
              ],
              DashboardSection(
                title: 'Financial Health',
                child: Column(
                  children: [
                    LoanHealthCard(health: health),
                    const SizedBox(height: 20),
                    DebtForecastCard(forecast: forecast),
                  ],
                ),
              ),

              DashboardSection(
                title: 'Financial Advisor',
                child: Column(
                  children: [
                    const RepaymentStrategySelector(),

                    const SizedBox(height: 20),

                    if (advice != null)
                      SmartRepaymentAdvisorCard(advice: advice),

                    const SizedBox(height: 20),

                    ExtraEmiSimulator(analytics: data),
                  ],
                ),
              ),
              DashboardSection(
                title: 'Insights',
                child: insightsAsync.when(
                  data: (insights) => SmartInsightsCard(insights: insights),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, _) => const SizedBox(),
                ),
              ),
              DashboardSection(
                title: 'Analytics',
                child: Column(
                  children: [
                    LoanHealthChart(data: data),
                    const SizedBox(height: 20),
                    RepaymentProgressCard(data: data),
                    const SizedBox(height: 20),
                    trendAsync.when(
                      data: (trend) => EmiTrendChart(data: trend),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text('Unable to load EMI Trend'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
