import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kharcha_paani/core/theme/app_theme.dart';
import 'package:kharcha_paani/features/home/presentation/widgets/empty_household_view.dart';
import 'package:kharcha_paani/features/household/presentation/widgets/group_header_summary_card.dart';
import 'package:kharcha_paani/features/household/presentation/widgets/who_owes_whom_section.dart';
import 'package:kharcha_paani/models/household_model.dart';
import 'package:kharcha_paani/services/expense_calculation_service.dart';

void main() {
  testWidgets('EmptyHouseholdView displays proper headings and CTA buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: EmptyHouseholdView(),
        ),
      ),
    );

    expect(find.text('No households yet'), findsOneWidget);
    expect(find.text('Create Household'), findsOneWidget);
    expect(find.text('Join Household'), findsOneWidget);
  });

  testWidgets('GroupHeaderSummaryCard displays net balance and CTA buttons',
      (WidgetTester tester) async {
    final household = HouseholdModel(
      id: 'h1',
      name: 'Flat 402 Roommates',
      inviteCode: 'AB12CD',
      createdBy: 'u1',
      createdAt: DateTime.now(),
      memberCount: 5,
    );

    const summary = HouseholdSummary(
      totalExpensesPaise: 1850000,
      youPaidPaise: 600000,
      yourSharePaise: 370000,
      youOwePaise: 0,
      youShouldReceivePaise: 230000,
      netBalancePaise: 230000,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: GroupHeaderSummaryCard(
            household: household,
            summary: summary,
            onSettleUp: () {},
            onAddExpense: () {},
          ),
        ),
      ),
    );

    expect(find.text('Flat 402 Roommates'), findsOneWidget);
    expect(find.text('5 members'), findsOneWidget);
    expect(find.text('• #AB12CD'), findsOneWidget);
    expect(find.text('YOU ARE OWED'), findsOneWidget);
    expect(find.text('₹2,300'), findsOneWidget);
    expect(find.text('Settle Up'), findsOneWidget);
    expect(find.text('Add Expense'), findsOneWidget);
  });

  testWidgets('WhoOwesWhomSection displays celebration when settled',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: WhoOwesWhomSection(
            debts: const [],
            members: const [],
            currentUserId: 'u1',
            onSettleTransfer: (from, to, amount) {},
          ),
        ),
      ),
    );

    expect(find.text('Who Owes Whom'), findsOneWidget);
    expect(find.text('Everyone is settled up! 🎉'), findsOneWidget);
  });
}
