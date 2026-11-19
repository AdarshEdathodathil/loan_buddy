import 'package:flutter/material.dart';
import 'package:loan_buddy/features/analytics/presentation/analytics_screen.dart';

import 'package:loan_buddy/features/dashboard/presentation/dashboard_screen.dart';
import 'package:loan_buddy/features/settings/screens/settings_screen.dart';
import '../loans/loans_screen.dart';
import '../calendar/calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  void _selectTab(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(
        onShowLoans: () => _selectTab(1),
        onShowCalendar: () => _selectTab(2),
        onShowAnalytics: () => _selectTab(3),
      ),
      const LoansScreen(),
      const CalendarScreen(),
      const AnalyticsScreen(),
      const SettingsScreen(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= 840;
        final content = IndexedStack(index: currentIndex, children: pages);

        if (useRail) {
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 1180,
                    selectedIndex: currentIndex,
                    onDestinationSelected: _selectTab,
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: _BrandMark(
                        showLabel: constraints.maxWidth >= 1180,
                      ),
                    ),
                    destinations: _railDestinations,
                  ),
                ),
                VerticalDivider(
                  width: 1,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                Expanded(child: content),
              ],
            ),
          );
        }

        return Scaffold(
          body: content,
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: _selectTab,
            destinations: _barDestinations,
          ),
        );
      },
    );
  }
}

const _barDestinations = [
  NavigationDestination(
    icon: Icon(Icons.space_dashboard_outlined),
    selectedIcon: Icon(Icons.space_dashboard_rounded),
    label: 'Home',
  ),
  NavigationDestination(
    icon: Icon(Icons.account_balance_wallet_outlined),
    selectedIcon: Icon(Icons.account_balance_wallet_rounded),
    label: 'Loans',
  ),
  NavigationDestination(
    icon: Icon(Icons.calendar_month_outlined),
    selectedIcon: Icon(Icons.calendar_month_rounded),
    label: 'Calendar',
  ),
  NavigationDestination(
    icon: Icon(Icons.insights_outlined),
    selectedIcon: Icon(Icons.insights_rounded),
    label: 'Insights',
  ),
  NavigationDestination(
    icon: Icon(Icons.settings_outlined),
    selectedIcon: Icon(Icons.settings_rounded),
    label: 'Settings',
  ),
];

const _railDestinations = [
  NavigationRailDestination(
    icon: Icon(Icons.space_dashboard_outlined),
    selectedIcon: Icon(Icons.space_dashboard_rounded),
    label: Text('Home'),
  ),
  NavigationRailDestination(
    icon: Icon(Icons.account_balance_wallet_outlined),
    selectedIcon: Icon(Icons.account_balance_wallet_rounded),
    label: Text('Loans'),
  ),
  NavigationRailDestination(
    icon: Icon(Icons.calendar_month_outlined),
    selectedIcon: Icon(Icons.calendar_month_rounded),
    label: Text('Calendar'),
  ),
  NavigationRailDestination(
    icon: Icon(Icons.insights_outlined),
    selectedIcon: Icon(Icons.insights_rounded),
    label: Text('Insights'),
  ),
  NavigationRailDestination(
    icon: Icon(Icons.settings_outlined),
    selectedIcon: Icon(Icons.settings_rounded),
    label: Text('Settings'),
  ),
];

class _BrandMark extends StatelessWidget {
  const _BrandMark({required this.showLabel});

  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(Icons.handshake_rounded, color: scheme.primary),
        ),
        if (showLabel) ...[
          const SizedBox(width: 12),
          Text('Loan Buddy', style: Theme.of(context).textTheme.titleLarge),
        ],
      ],
    );
  }
}
