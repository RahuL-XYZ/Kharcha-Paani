import 'package:flutter_test/flutter_test.dart';
import 'package:kharcha_paani/models/expense_model.dart';
import 'package:kharcha_paani/models/household_member_model.dart';
import 'package:kharcha_paani/models/settlement_model.dart';
import 'package:kharcha_paani/services/expense_calculation_service.dart';

void main() {
  group('ExpenseCalculationService - Equal Split Tests', () {
    test('Equal split among 2 users without remainder', () {
      final shares = ExpenseCalculationService.calculateEqualSplit(
        amountPaise: 200000, // ₹2000
        participantIds: ['u1', 'u2'],
      );

      expect(shares.length, 2);
      expect(shares[0].amountPaise, 100000); // ₹1000
      expect(shares[1].amountPaise, 100000); // ₹1000
      expect(shares.map((s) => s.amountPaise).reduce((a, b) => a + b), 200000);
    });

    test('Equal split among 3 users with uneven paise remainder (₹100 among 3)', () {
      final shares = ExpenseCalculationService.calculateEqualSplit(
        amountPaise: 10000, // ₹100.00 = 10000 paise
        participantIds: ['u1', 'u2', 'u3'],
      );

      expect(shares.length, 3);
      // 10000 / 3 = 3333 with remainder 1. First user gets 3334, others get 3333
      expect(shares[0].amountPaise, 3334);
      expect(shares[1].amountPaise, 3333);
      expect(shares[2].amountPaise, 3333);

      final totalSplitPaise = shares.map((s) => s.amountPaise).reduce((a, b) => a + b);
      expect(totalSplitPaise, 10000); // Exact sum guaranteed!
    });

    test('Equal split among 4 users (₹2000 example from specs)', () {
      final shares = ExpenseCalculationService.calculateEqualSplit(
        amountPaise: 200000, // ₹2000
        participantIds: ['rahul', 'amit', 'rohit', 'neha'],
      );

      expect(shares.length, 4);
      for (final s in shares) {
        expect(s.amountPaise, 50000); // ₹500 each
      }
      expect(shares.map((s) => s.amountPaise).reduce((a, b) => a + b), 200000);
    });

    test('Zero and negative amounts return empty shares', () {
      expect(
        ExpenseCalculationService.calculateEqualSplit(amountPaise: 0, participantIds: ['u1', 'u2']),
        isEmpty,
      );
      expect(
        ExpenseCalculationService.calculateEqualSplit(amountPaise: -100, participantIds: ['u1']),
        isEmpty,
      );
      expect(
        ExpenseCalculationService.calculateEqualSplit(amountPaise: 5000, participantIds: []),
        isEmpty,
      );
    });
  });

  group('ExpenseCalculationService - Balances and Settlements', () {
    test('Rahul pays ₹2000 split equally among Rahul, Amit, Rohit, Neha', () {
      final expense = ExpenseModel(
        id: 'e1',
        title: 'Grocery',
        amount: 2000.0,
        category: 'Grocery',
        paidBy: 'rahul',
        participants: ['rahul', 'amit', 'rohit', 'neha'],
        date: DateTime.now(),
        createdBy: 'rahul',
        createdAt: DateTime.now(),
      );

      final balances = ExpenseCalculationService.calculateMemberBalances(
        expenses: [expense],
        settlements: [],
        allMemberIds: ['rahul', 'amit', 'rohit', 'neha'],
      );

      // Rahul paid 2000, share is 500 -> net balance = +1500 (150000 paise)
      expect(balances['rahul']?.amountPaidPaise, 200000);
      expect(balances['rahul']?.sharePaise, 50000);
      expect(balances['rahul']?.netBalancePaise, 150000);
      expect(balances['rahul']?.isOwed, true);

      // Amit paid 0, share is 500 -> net balance = -500 (-50000 paise)
      expect(balances['amit']?.amountPaidPaise, 0);
      expect(balances['amit']?.sharePaise, 50000);
      expect(balances['amit']?.netBalancePaise, -50000);
      expect(balances['amit']?.owes, true);

      // Rohit net balance = -500
      expect(balances['rohit']?.netBalancePaise, -50000);
      // Neha net balance = -500
      expect(balances['neha']?.netBalancePaise, -50000);
    });

    test('Same person paying multiple expenses', () {
      final e1 = ExpenseModel(
        id: 'e1',
        title: 'Grocery',
        amount: 1000.0,
        category: 'Grocery',
        paidBy: 'rahul',
        participants: ['rahul', 'amit'],
        date: DateTime.now(),
        createdBy: 'rahul',
        createdAt: DateTime.now(),
      );

      final e2 = ExpenseModel(
        id: 'e2',
        title: 'Electricity',
        amount: 600.0,
        category: 'Electricity',
        paidBy: 'rahul',
        participants: ['rahul', 'amit'],
        date: DateTime.now(),
        createdBy: 'rahul',
        createdAt: DateTime.now(),
      );

      final balances = ExpenseCalculationService.calculateMemberBalances(
        expenses: [e1, e2],
        settlements: [],
        allMemberIds: ['rahul', 'amit'],
      );

      // Rahul paid 1600, share is 500 + 300 = 800 -> net +800
      expect(balances['rahul']?.amountPaidPaise, 160000);
      expect(balances['rahul']?.sharePaise, 80000);
      expect(balances['rahul']?.netBalancePaise, 80000);

      // Amit paid 0, share is 800 -> net -800
      expect(balances['amit']?.netBalancePaise, -80000);
    });

    test('Multiple expenses by different users', () {
      // Rahul pays ₹1000 for Grocery (split with Amit) -> Rahul +500, Amit -500
      final e1 = ExpenseModel(
        id: 'e1',
        title: 'Grocery',
        amount: 1000.0,
        category: 'Grocery',
        paidBy: 'rahul',
        participants: ['rahul', 'amit'],
        date: DateTime.now(),
        createdBy: 'rahul',
        createdAt: DateTime.now(),
      );

      // Amit pays ₹400 for Internet (split with Rahul) -> Amit +200, Rahul -200
      final e2 = ExpenseModel(
        id: 'e2',
        title: 'Internet',
        amount: 400.0,
        category: 'Internet',
        paidBy: 'amit',
        participants: ['rahul', 'amit'],
        date: DateTime.now(),
        createdBy: 'amit',
        createdAt: DateTime.now(),
      );

      final balances = ExpenseCalculationService.calculateMemberBalances(
        expenses: [e1, e2],
        settlements: [],
        allMemberIds: ['rahul', 'amit'],
      );

      // Rahul net: +500 - 200 = +300
      expect(balances['rahul']?.netBalancePaise, 30000);
      // Amit net: -500 + 200 = -300
      expect(balances['amit']?.netBalancePaise, -30000);
    });

    test('Settlement records reduce outstanding balances without deleting expenses', () {
      final e1 = ExpenseModel(
        id: 'e1',
        title: 'Dinner',
        amount: 1000.0,
        category: 'Food',
        paidBy: 'rahul',
        participants: ['rahul', 'amit'],
        date: DateTime.now(),
        createdBy: 'rahul',
        createdAt: DateTime.now(),
      );

      // Amit pays Rahul ₹500 via settlement
      final s1 = SettlementModel(
        id: 's1',
        fromUser: 'amit',
        toUser: 'rahul',
        amount: 500.0,
        createdBy: 'amit',
        createdAt: DateTime.now(),
      );

      final balances = ExpenseCalculationService.calculateMemberBalances(
        expenses: [e1],
        settlements: [s1],
        allMemberIds: ['rahul', 'amit'],
      );

      // Both should now be settled (net 0)
      expect(balances['rahul']?.netBalancePaise, 0);
      expect(balances['rahul']?.isSettled, true);
      expect(balances['amit']?.netBalancePaise, 0);
      expect(balances['amit']?.isSettled, true);
    });

    test('Expense deletion / editing dynamic calculation verification', () {
      final e1 = ExpenseModel(
        id: 'e1',
        title: 'Trip',
        amount: 1000.0,
        category: 'Other',
        paidBy: 'rahul',
        participants: ['rahul', 'amit'],
        date: DateTime.now(),
        createdBy: 'rahul',
        createdAt: DateTime.now(),
      );

      // Before edit: Rahul is +500
      var balances = ExpenseCalculationService.calculateMemberBalances(
        expenses: [e1],
        settlements: [],
        allMemberIds: ['rahul', 'amit'],
      );
      expect(balances['rahul']?.netBalancePaise, 50000);

      // Edited e1: amount changed to 2000.0
      final e1Edited = e1.copyWith(amount: 2000.0);
      balances = ExpenseCalculationService.calculateMemberBalances(
        expenses: [e1Edited],
        settlements: [],
        allMemberIds: ['rahul', 'amit'],
      );
      expect(balances['rahul']?.netBalancePaise, 100000); // Now +1000

      // Deletion: empty expense list
      balances = ExpenseCalculationService.calculateMemberBalances(
        expenses: [],
        settlements: [],
        allMemberIds: ['rahul', 'amit'],
      );
      expect(balances['rahul']?.netBalancePaise, 0);
      expect(balances['amit']?.netBalancePaise, 0);
    });
  });

  group('ExpenseCalculationService - Debt Simplification Algorithm', () {
    test('Simplifies 3-person circular debts into minimum transfers', () {
      // Suppose:
      // Amit owes 500 (-500)
      // Rohit owes 400 (-400)
      // Neha owes 200 (-200)
      // Rahul is owed 1100 (+1100)
      final balances = {
        'amit': const MemberBalanceSummary(
          userId: 'amit',
          amountPaidPaise: 0,
          sharePaise: 50000,
          settlementPaidPaise: 0,
          settlementReceivedPaise: 0,
          netBalancePaise: -50000,
        ),
        'rohit': const MemberBalanceSummary(
          userId: 'rohit',
          amountPaidPaise: 0,
          sharePaise: 40000,
          settlementPaidPaise: 0,
          settlementReceivedPaise: 0,
          netBalancePaise: -40000,
        ),
        'neha': const MemberBalanceSummary(
          userId: 'neha',
          amountPaidPaise: 0,
          sharePaise: 20000,
          settlementPaidPaise: 0,
          settlementReceivedPaise: 0,
          netBalancePaise: -20000,
        ),
        'rahul': const MemberBalanceSummary(
          userId: 'rahul',
          amountPaidPaise: 110000,
          sharePaise: 0,
          settlementPaidPaise: 0,
          settlementReceivedPaise: 0,
          netBalancePaise: 110000,
        ),
      };

      final simplified = ExpenseCalculationService.calculateSimplifiedSettlements(
        memberBalances: balances,
      );

      // Should produce exactly 3 transactions: Amit->Rahul ₹500, Rohit->Rahul ₹400, Neha->Rahul ₹200
      expect(simplified.length, 3);
      expect(simplified.any((d) => d.fromUser == 'amit' && d.toUser == 'rahul' && d.amountPaise == 50000), true);
      expect(simplified.any((d) => d.fromUser == 'rohit' && d.toUser == 'rahul' && d.amountPaise == 40000), true);
      expect(simplified.any((d) => d.fromUser == 'neha' && d.toUser == 'rahul' && d.amountPaise == 20000), true);
    });

    test('Household summary calculates correct metrics for logged-in user', () {
      final expense = ExpenseModel(
        id: 'e1',
        title: 'Groceries',
        amount: 3000.0,
        category: 'Grocery',
        paidBy: 'rahul',
        participants: ['rahul', 'amit', 'rohit'],
        date: DateTime.now(),
        createdBy: 'rahul',
        createdAt: DateTime.now(),
      );

      final summaryRahul = ExpenseCalculationService.calculateHouseholdSummary(
        currentUserId: 'rahul',
        expenses: [expense],
        settlements: [],
        allMemberIds: ['rahul', 'amit', 'rohit'],
      );

      expect(summaryRahul.totalExpensesPaise, 300000);
      expect(summaryRahul.youPaidPaise, 300000); // Rahul paid ₹3000
      expect(summaryRahul.yourSharePaise, 100000); // Rahul's share is ₹1000
      expect(summaryRahul.youShouldReceivePaise, 200000); // Rahul should receive ₹2000
      expect(summaryRahul.youOwePaise, 0);

      final summaryAmit = ExpenseCalculationService.calculateHouseholdSummary(
        currentUserId: 'amit',
        expenses: [expense],
        settlements: [],
        allMemberIds: ['rahul', 'amit', 'rohit'],
      );

      expect(summaryAmit.totalExpensesPaise, 300000);
      expect(summaryAmit.youPaidPaise, 0);
      expect(summaryAmit.yourSharePaise, 100000);
      expect(summaryAmit.youOwePaise, 100000); // Amit owes ₹1000
      expect(summaryAmit.youShouldReceivePaise, 0);
    });
  });

  group('ExpenseCalculationService - 5-Member Group Scenario from Specification', () {
    test('Rahul (6k), Amit (2.5k), Neha (4k), Priya (3k), Rohan (3k) optimal settlement', () {
      final members = ['rahul', 'amit', 'neha', 'priya', 'rohan'];

      // Expenses paid by each member
      final e1 = ExpenseModel(
        id: 'e1',
        title: 'Rahul Expense',
        amount: 6000.0,
        category: 'Food',
        paidBy: 'rahul',
        participants: members,
        date: DateTime.now(),
        createdBy: 'rahul',
        createdAt: DateTime.now(),
      );

      final e2 = ExpenseModel(
        id: 'e2',
        title: 'Amit Expense',
        amount: 2500.0,
        category: 'Grocery',
        paidBy: 'amit',
        participants: members,
        date: DateTime.now(),
        createdBy: 'amit',
        createdAt: DateTime.now(),
      );

      final e3 = ExpenseModel(
        id: 'e3',
        title: 'Neha Expense',
        amount: 4000.0,
        category: 'Electricity',
        paidBy: 'neha',
        participants: members,
        date: DateTime.now(),
        createdBy: 'neha',
        createdAt: DateTime.now(),
      );

      final e4 = ExpenseModel(
        id: 'e4',
        title: 'Priya Expense',
        amount: 3000.0,
        category: 'Internet',
        paidBy: 'priya',
        participants: members,
        date: DateTime.now(),
        createdBy: 'priya',
        createdAt: DateTime.now(),
      );

      final e5 = ExpenseModel(
        id: 'e5',
        title: 'Rohan Expense',
        amount: 3000.0,
        category: 'Water',
        paidBy: 'rohan',
        participants: members,
        date: DateTime.now(),
        createdBy: 'rohan',
        createdAt: DateTime.now(),
      );

      final expenses = [e1, e2, e3, e4, e5];

      // 1. Calculate Balances
      final balances = ExpenseCalculationService.calculateMemberBalances(
        expenses: expenses,
        settlements: [],
        allMemberIds: members,
      );

      // Total spent = 6000 + 2500 + 4000 + 3000 + 3000 = 18,500
      // Each member's equal share = 18,500 / 5 = ₹3,700 (370,000 paise)
      expect(balances['rahul']?.amountPaidPaise, 600000);
      expect(balances['rahul']?.sharePaise, 370000);
      expect(balances['rahul']?.netBalancePaise, 230000); // +₹2,300

      expect(balances['neha']?.amountPaidPaise, 400000);
      expect(balances['neha']?.sharePaise, 370000);
      expect(balances['neha']?.netBalancePaise, 30000); // +₹300

      expect(balances['amit']?.amountPaidPaise, 250000);
      expect(balances['amit']?.sharePaise, 370000);
      expect(balances['amit']?.netBalancePaise, -120000); // -₹1,200

      expect(balances['priya']?.amountPaidPaise, 300000);
      expect(balances['priya']?.sharePaise, 370000);
      expect(balances['priya']?.netBalancePaise, -70000); // -₹700

      expect(balances['rohan']?.amountPaidPaise, 300000);
      expect(balances['rohan']?.sharePaise, 370000);
      expect(balances['rohan']?.netBalancePaise, -70000); // -₹700

      // 2. Calculate simplified minimal transactions
      final simplified = ExpenseCalculationService.calculateSimplifiedSettlements(
        memberBalances: balances,
      );

      // Verify transaction integrity
      int totalPaidByDebtors = 0;
      int totalReceivedByCreditors = 0;

      for (final debt in simplified) {
        totalPaidByDebtors += debt.amountPaise;
        totalReceivedByCreditors += debt.amountPaise;
      }

      // Total debt should equal total credit (2300 + 300 = 2600 = 260,000 paise)
      expect(totalPaidByDebtors, 260000);
      expect(totalReceivedByCreditors, 260000);

      // Verify specific optimal transfers:
      // Amit owes ₹1,200 to Rahul
      expect(
        simplified.any((d) =>
            d.fromUser == 'amit' && d.toUser == 'rahul' && d.amountPaise == 120000),
        true,
      );

      // Priya owes ₹700 to Rahul
      expect(
        simplified.any((d) =>
            d.fromUser == 'priya' && d.toUser == 'rahul' && d.amountPaise == 70000),
        true,
      );

      // Rohan pays ₹300 to Neha
      expect(
        simplified.any((d) =>
            d.fromUser == 'rohan' && d.toUser == 'neha' && d.amountPaise == 30000),
        true,
      );

      // Rohan pays ₹400 to Rahul (settling remaining Rahul credit: 2300 - 1200 - 700 = 400)
      expect(
        simplified.any((d) =>
            d.fromUser == 'rohan' && d.toUser == 'rahul' && d.amountPaise == 40000),
        true,
      );
    });
  });

  group('ExpenseCalculationService - Unequal & Custom Splits', () {
    test('Calculates exact custom split amounts correctly', () {
      final expense = ExpenseModel(
        id: 'e_custom',
        title: 'Custom Grocery',
        amount: 1000.0,
        category: 'Grocery',
        paidBy: 'rahul',
        participants: ['rahul', 'amit', 'neha'],
        splitType: 'exact',
        splitAmounts: {
          'rahul': 200.0,
          'amit': 500.0,
          'neha': 300.0,
        },
        date: DateTime.now(),
        createdBy: 'rahul',
        createdAt: DateTime.now(),
      );

      final shares = ExpenseCalculationService.calculateExpenseShares(expense);

      expect(shares.length, 3);
      expect(shares.firstWhere((s) => s.userId == 'rahul').amountPaise, 20000);
      expect(shares.firstWhere((s) => s.userId == 'amit').amountPaise, 50000);
      expect(shares.firstWhere((s) => s.userId == 'neha').amountPaise, 30000);

      final balances = ExpenseCalculationService.calculateMemberBalances(
        expenses: [expense],
        settlements: [],
        allMemberIds: ['rahul', 'amit', 'neha'],
      );

      // Rahul paid 1000, share 200 -> net +800
      expect(balances['rahul']?.netBalancePaise, 80000);
      // Amit paid 0, share 500 -> net -500
      expect(balances['amit']?.netBalancePaise, -50000);
      // Neha paid 0, share 300 -> net -300
      expect(balances['neha']?.netBalancePaise, -30000);
    });
  });

  group('ExpenseCalculationService - Pairwise Breakdown', () {
    test('Calculates itemized mutual shared expenses between Rahul and Amit', () {
      final memberRahul = HouseholdMemberModel(
        id: 'rahul',
        name: 'Rahul',
        joinedAt: DateTime(2025, 1, 1),
      );
      final memberAmit = HouseholdMemberModel(
        id: 'amit',
        name: 'Amit',
        joinedAt: DateTime(2025, 1, 1),
      );

      // Dinner ₹2,500 paid by Rahul, split between Rahul and Amit (₹1,250 each)
      final e1 = ExpenseModel(
        id: 'e1',
        title: 'Dinner',
        amount: 2500.0,
        category: 'Food',
        paidBy: 'rahul',
        participants: ['rahul', 'amit'],
        date: DateTime(2025, 6, 1),
        createdBy: 'rahul',
        createdAt: DateTime(2025, 6, 1),
      );

      // Hotel ₹8,000 paid by Amit, split between Rahul and Amit (₹4,000 each)
      final e2 = ExpenseModel(
        id: 'e2',
        title: 'Hotel',
        amount: 8000.0,
        category: 'Other',
        paidBy: 'amit',
        participants: ['rahul', 'amit'],
        date: DateTime(2025, 6, 2),
        createdBy: 'amit',
        createdAt: DateTime(2025, 6, 2),
      );

      final breakdown = ExpenseCalculationService.calculatePairwiseBreakdown(
        currentUserId: 'rahul',
        otherUserId: 'amit',
        expenses: [e1, e2],
        settlements: [],
        members: [memberRahul, memberAmit],
      );

      // Rahul paid e1: Amit owes Rahul ₹1,250 (+125,000)
      // Amit paid e2: Rahul owes Amit ₹4,000 (-400,000)
      // Net: 125,000 - 400,000 = -275,000 (Rahul owes Amit ₹2,750)
      expect(breakdown.netBalancePaise, -275000);
      expect(breakdown.youOweOther, true);
      expect(breakdown.otherOwesYou, false);
      expect(breakdown.items.length, 2);

      // Verify settlement payment resolves the debt
      final s1 = SettlementModel(
        id: 's1',
        fromUser: 'rahul',
        toUser: 'amit',
        amount: 2750.0,
        createdBy: 'rahul',
        createdAt: DateTime(2025, 6, 3),
      );

      final settledBreakdown = ExpenseCalculationService.calculatePairwiseBreakdown(
        currentUserId: 'rahul',
        otherUserId: 'amit',
        expenses: [e1, e2],
        settlements: [s1],
        members: [memberRahul, memberAmit],
      );

      expect(settledBreakdown.netBalancePaise, 0);
      expect(settledBreakdown.isSettled, true);
      expect(settledBreakdown.items.length, 3);
    });
  });

  group('ExpenseCalculationService - Spending Insights & Group Activity', () {
    test('Calculates spending insights correctly', () {
      final m1 = HouseholdMemberModel(id: 'u1', name: 'Rahul', joinedAt: DateTime.now());
      final m2 = HouseholdMemberModel(id: 'u2', name: 'Amit', joinedAt: DateTime.now());

      final e1 = ExpenseModel(
        id: 'e1',
        title: 'Grocery Bill',
        amount: 3000.0,
        category: 'Grocery',
        paidBy: 'u1',
        participants: ['u1', 'u2'],
        date: DateTime.now(),
        createdBy: 'u1',
        createdAt: DateTime.now(),
      );

      final e2 = ExpenseModel(
        id: 'e2',
        title: 'Internet',
        amount: 1000.0,
        category: 'Internet',
        paidBy: 'u2',
        participants: ['u1', 'u2'],
        date: DateTime.now(),
        createdBy: 'u2',
        createdAt: DateTime.now(),
      );

      final insights = ExpenseCalculationService.calculateSpendingInsights(
        expenses: [e1, e2],
        members: [m1, m2],
      );

      expect(insights.totalSpentPaise, 400000); // ₹4,000
      expect(insights.highestSpenderId, 'u1');
      expect(insights.highestSpenderName, 'Rahul');
      expect(insights.highestSpenderAmountPaise, 300000); // ₹3,000
      expect(insights.largestExpense?.title, 'Grocery Bill');
      expect(insights.averagePerMemberPaise, 200000); // ₹2,000 per person
      expect(insights.categoryBreakdown.length, 2);
    });

    test('Generates reverse-chronological group activity feed', () {
      final m1 = HouseholdMemberModel(id: 'u1', name: 'Rahul', joinedAt: DateTime(2025, 1, 1));
      final m2 = HouseholdMemberModel(id: 'u2', name: 'Amit', joinedAt: DateTime(2025, 1, 2));

      final e1 = ExpenseModel(
        id: 'e1',
        title: 'Dinner',
        amount: 2500.0,
        category: 'Food',
        paidBy: 'u1',
        participants: ['u1', 'u2'],
        date: DateTime(2025, 1, 3),
        createdBy: 'u1',
        createdAt: DateTime(2025, 1, 3),
      );

      final s1 = SettlementModel(
        id: 's1',
        fromUser: 'u2',
        toUser: 'u1',
        amount: 1250.0,
        createdBy: 'u2',
        createdAt: DateTime(2025, 1, 4),
      );

      final activities = ExpenseCalculationService.calculateGroupActivity(
        expenses: [e1],
        settlements: [s1],
        members: [m1, m2],
      );

      // Most recent should be s1 (Jan 4), then e1 (Jan 3), then m2 (Jan 2), then m1 (Jan 1)
      expect(activities.length, 4);
      expect(activities[0].type, GroupActivityType.settlementCompleted);
      expect(activities[1].type, GroupActivityType.expenseAdded);
      expect(activities[2].type, GroupActivityType.memberJoined);
      expect(activities[3].type, GroupActivityType.memberJoined);
    });
  });
}
