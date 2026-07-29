import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_buddy/features/analytics/providers/analytics_provider.dart';
import 'package:loan_buddy/features/analytics/providers/smart_insights_provider.dart';
import 'package:loan_buddy/features/analytics/widgets/insight_cards.dart';
import 'package:loan_buddy/features/analytics/widgets/loan_health_chart.dart';
import 'package:loan_buddy/features/analytics/widgets/smart_insights_card.dart';
import 'package:loan_buddy/features/analytics/widgets/repayment_progress_card.dart';
import 'package:loan_buddy/features/analytics/providers/payment_analytics_provider.dart';
import 'package:loan_buddy/features/analytics/widgets/emi_trend_chart.dart';
import 'package:loan_buddy/features/analytics/services/loan_health_calculator.dart';
import 'package:loan_buddy/features/analytics/widgets/loan_health_card.dart';
import 'package:loan_buddy/features/analytics/services/debt_forecast_calculator.dart';
import 'package:loan_buddy/features/analytics/widgets/debt_forecast_card.dart';
import 'package:loan_buddy/features/analytics/widgets/extra_emi_simulator.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendAsync = ref.watch(monthlyEmiTrendProvider);
    final analytics = ref.watch(analyticsProvider);
    final insightsAsync = ref.watch(smartInsightsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      body: analytics.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (data) {
          final health = LoanHealthCalculator.calculate(data);
          final forecast = DebtForecastCalculator.calculate(data);
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              LoanHealthCard(health: health),

              const SizedBox(height: 20),

              DebtForecastCard(forecast: forecast),

              const SizedBox(height: 20),

              ExtraEmiSimulator(analytics: data),

              const SizedBox(height: 20),

              InsightCards(data: data),

              const SizedBox(height: 20),

              LoanHealthChart(data: data),

              const SizedBox(height: 20),

              RepaymentProgressCard(data: data),

              const SizedBox(height: 20),

              const SizedBox(height: 20),

              trendAsync.when(
                data: (trend) => EmiTrendChart(data: trend),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Unable to load EMI Trend'),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              insightsAsync.when(
                data: (insights) => SmartInsightsCard(insights: insights),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => const SizedBox(),
              ),
            ],
          );
        },
      ),
    );
  }
}
