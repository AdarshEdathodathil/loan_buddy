# Loan Buddy

Loan Buddy is an offline-first Flutter application for tracking loans,
recording repayments, planning debt payoff, and understanding overall debt
health. Loan data is stored locally on the device, so the core experience does
not require an account or internet connection.

## Features

### Loan management

- Add and edit loans through a guided, multi-step form.
- Record the lender, loan type, principal, outstanding balance, interest rate,
  EMI, due date, term, and notes.
- View active and closed loans from a consolidated dashboard.
- Open a detailed loan view with repayment progress, payment history, and an
  EMI timeline.
- Delete a loan together with its associated payment history.

### Payments and repayment tracking

- Record regular EMI payments and part payments.
- Foreclose a loan by paying its remaining outstanding balance.
- Automatically update the outstanding balance after each payment.
- Mark a loan as closed when its balance reaches zero.
- Associate payments with their corresponding EMI month.

### Dashboard

- See total borrowed, total outstanding, and total repaid amounts.
- Review active loans, closed loans, total loans, and combined monthly EMI.
- Quickly access loans and common loan actions.

### EMI calendar

- View upcoming EMI due dates for all active loans.
- Review a rolling three-month payment schedule.
- Handle month-end due dates correctly for shorter months.

### Analytics and payoff planning

- Monitor repayment progress and overall loan health.
- View monthly EMI payment trends and a projected debt-free date.
- Estimate the impact of adding an extra amount to monthly repayments.
- Compare repayment approaches such as avalanche, snowball, lowest EMI,
  earliest finish, and smart recommendations.
- Receive insights about the largest loan, highest EMI, and upcoming dues.

### EMI reminders

- Schedule monthly local notifications before an EMI due date.
- Configure reminder timing for individual loans.
- Automatically cancel reminders when a loan is closed or deleted.
- Restore scheduled reminders when the application starts.

### Personalization

- Choose light, dark, or system theme mode.
- Select a preferred display currency.
- Persist appearance and currency preferences locally.

### Offline storage

- Store loans and payments locally using Drift and SQLite.
- Keep financial data on the device without requiring user registration.

## Technology

- Flutter and Dart
- Riverpod for state management
- Drift and SQLite for local persistence
- `flutter_local_notifications` for EMI reminders
- `fl_chart` for analytics charts

## Development status

Loan tracking, payments, dashboards, the EMI calendar, analytics, reminders,
themes, and currency preferences are available. Backup and restore and
document-based loan import are under development.

## Getting started

```sh
flutter pub get
flutter run
```

Run the checks with:

```sh
flutter analyze
flutter test
```

## Release checklist

Before publishing, replace the placeholder Android application ID
`com.example.loan_buddy` with a permanent reverse-domain identifier and update
the matching Kotlin package. Never change that identifier after the first store
release.

Android release builds read signing credentials from `android/key.properties`:

```properties
storeFile=../upload-keystore.jks
storePassword=YOUR_STORE_PASSWORD
keyAlias=upload
keyPassword=YOUR_KEY_PASSWORD
```

The key file and properties file are ignored by Git. A release build without
this file is deliberately left unsigned instead of using the debug key.

Loan and payoff projections are estimates based on user-entered information
and are not financial advice.
