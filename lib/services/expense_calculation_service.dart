import '../models/expense_model.dart';
import '../models/household_member_model.dart';
import '../models/settlement_model.dart';
import '../core/utils/currency_formatter.dart';

class SplitShare {
  final String userId;
  final int amountPaise;

  const SplitShare({
    required this.userId,
    required this.amountPaise,
  });

  double get amountRupees => CurrencyFormatter.fromPaise(amountPaise);
}

class PairwiseItem {
  final String id;
  final String title;
  final DateTime date;
  final int amountPaise;
  final bool youPaid; // true if current user paid, false if other member paid or settled
  final bool isSettlement;
  final String? category;
  final String description;

  const PairwiseItem({
    required this.id,
    required this.title,
    required this.date,
    required this.amountPaise,
    required this.youPaid,
    this.isSettlement = false,
    this.category,
    required this.description,
  });

  double get amountRupees => CurrencyFormatter.fromPaise(amountPaise);
}

class PairwiseBreakdown {
  final String currentUserId;
  final String otherUserId;
  final String otherUserName;
  final int netBalancePaise; // > 0 means other owes you; < 0 means you owe other
  final List<PairwiseItem> items;

  const PairwiseBreakdown({
    required this.currentUserId,
    required this.otherUserId,
    required this.otherUserName,
    required this.netBalancePaise,
    required this.items,
  });

  double get netBalanceRupees => CurrencyFormatter.fromPaise(netBalancePaise);
  bool get otherOwesYou => netBalancePaise > 0;
  bool get youOweOther => netBalancePaise < 0;
  bool get isSettled => netBalancePaise == 0;
}

class GroupSpendingInsights {
  final int totalSpentPaise;
  final List<CategorySpending> categoryBreakdown;
  final String? highestSpenderId;
  final String? highestSpenderName;
  final int highestSpenderAmountPaise;
  final ExpenseModel? largestExpense;
  final int averagePerMemberPaise;

  const GroupSpendingInsights({
    required this.totalSpentPaise,
    required this.categoryBreakdown,
    this.highestSpenderId,
    this.highestSpenderName,
    required this.highestSpenderAmountPaise,
    this.largestExpense,
    required this.averagePerMemberPaise,
  });

  double get totalSpentRupees => CurrencyFormatter.fromPaise(totalSpentPaise);
  double get highestSpenderAmountRupees => CurrencyFormatter.fromPaise(highestSpenderAmountPaise);
  double get averagePerMemberRupees => CurrencyFormatter.fromPaise(averagePerMemberPaise);
}

enum GroupActivityType {
  expenseAdded,
  settlementCompleted,
  memberJoined,
}

class GroupActivityItem {
  final String id;
  final GroupActivityType type;
  final String title;
  final String description;
  final DateTime timestamp;
  final int? amountPaise;
  final String? category;
  final String? actorName;

  const GroupActivityItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.amountPaise,
    this.category,
    this.actorName,
  });

  double? get amountRupees =>
      amountPaise != null ? CurrencyFormatter.fromPaise(amountPaise!) : null;
}

class MemberBalanceSummary {
  final String userId;
  final int amountPaidPaise;
  final int sharePaise;
  final int settlementPaidPaise;
  final int settlementReceivedPaise;
  final int netBalancePaise;

  const MemberBalanceSummary({
    required this.userId,
    required this.amountPaidPaise,
    required this.sharePaise,
    required this.settlementPaidPaise,
    required this.settlementReceivedPaise,
    required this.netBalancePaise,
  });

  double get netBalanceRupees => CurrencyFormatter.fromPaise(netBalancePaise);
  double get amountPaidRupees => CurrencyFormatter.fromPaise(amountPaidPaise);
  double get shareRupees => CurrencyFormatter.fromPaise(sharePaise);
  bool get isOwed => netBalancePaise > 0;
  bool get owes => netBalancePaise < 0;
  bool get isSettled => netBalancePaise == 0;
}

class HouseholdSummary {
  final int totalExpensesPaise;
  final int youPaidPaise;
  final int yourSharePaise;
  final int youOwePaise;
  final int youShouldReceivePaise;
  final int netBalancePaise;

  const HouseholdSummary({
    required this.totalExpensesPaise,
    required this.youPaidPaise,
    required this.yourSharePaise,
    required this.youOwePaise,
    required this.youShouldReceivePaise,
    required this.netBalancePaise,
  });

  double get totalExpensesRupees => CurrencyFormatter.fromPaise(totalExpensesPaise);
  double get youPaidRupees => CurrencyFormatter.fromPaise(youPaidPaise);
  double get yourShareRupees => CurrencyFormatter.fromPaise(yourSharePaise);
  double get youOweRupees => CurrencyFormatter.fromPaise(youOwePaise);
  double get youShouldReceiveRupees => CurrencyFormatter.fromPaise(youShouldReceivePaise);
  double get netBalanceRupees => CurrencyFormatter.fromPaise(netBalancePaise);

  factory HouseholdSummary.empty() {
    return const HouseholdSummary(
      totalExpensesPaise: 0,
      youPaidPaise: 0,
      yourSharePaise: 0,
      youOwePaise: 0,
      youShouldReceivePaise: 0,
      netBalancePaise: 0,
    );
  }
}

class SimplifiedDebt {
  final String fromUser;
  final String toUser;
  final int amountPaise;

  const SimplifiedDebt({
    required this.fromUser,
    required this.toUser,
    required this.amountPaise,
  });

  double get amountRupees => CurrencyFormatter.fromPaise(amountPaise);
}

class CategorySpending {
  final String category;
  final int totalPaise;
  final double percentage;
  final int expenseCount;

  const CategorySpending({
    required this.category,
    required this.totalPaise,
    required this.percentage,
    required this.expenseCount,
  });

  double get totalRupees => CurrencyFormatter.fromPaise(totalPaise);
}

class MonthlySpending {
  final DateTime monthYear;
  final int totalPaise;
  final List<ExpenseModel> expenses;

  const MonthlySpending({
    required this.monthYear,
    required this.totalPaise,
    required this.expenses,
  });

  double get totalRupees => CurrencyFormatter.fromPaise(totalPaise);
}

class ExpenseCalculationService {
  /// Calculates equal split among participants in integer paise with exact remainder distribution
  static List<SplitShare> calculateEqualSplit({
    required int amountPaise,
    required List<String> participantIds,
  }) {
    if (participantIds.isEmpty || amountPaise <= 0) {
      return [];
    }

    final int count = participantIds.length;
    final int baseShare = amountPaise ~/ count;
    final int remainder = amountPaise % count;

    final List<SplitShare> result = [];
    for (int i = 0; i < count; i++) {
      // Allocate the extra remainder paise one by one to ensure exact total sum
      final int share = baseShare + (i < remainder ? 1 : 0);
      result.add(SplitShare(userId: participantIds[i], amountPaise: share));
    }

    return result;
  }

  /// Calculates shares for a specific expense, supporting both equal and unequal/exact splits
  static List<SplitShare> calculateExpenseShares(ExpenseModel expense) {
    final amountPaise = expense.amountPaise;
    if (amountPaise <= 0 || expense.participants.isEmpty) return [];

    if (expense.splitAmounts != null && expense.splitAmounts!.isNotEmpty) {
      final List<SplitShare> shares = [];
      for (final p in expense.participants) {
        final val = expense.splitAmounts![p];
        final pPaise = val != null ? CurrencyFormatter.toPaise(val) : 0;
        shares.add(SplitShare(userId: p, amountPaise: pPaise));
      }
      // Ensure sum equals amountPaise if there's any minor paise rounding discrepancy
      final int totalSharesPaise =
          shares.fold(0, (sum, s) => sum + s.amountPaise);
      final int diff = amountPaise - totalSharesPaise;
      if (diff != 0 && shares.isNotEmpty) {
        shares[0] = SplitShare(
          userId: shares[0].userId,
          amountPaise: shares[0].amountPaise + diff,
        );
      }
      return shares;
    }

    return calculateEqualSplit(
      amountPaise: amountPaise,
      participantIds: expense.participants,
    );
  }

  /// Calculates net balance breakdown for all members given expenses and settlements
  static Map<String, MemberBalanceSummary> calculateMemberBalances({
    required List<ExpenseModel> expenses,
    required List<SettlementModel> settlements,
    required List<String> allMemberIds,
  }) {
    final Map<String, int> amountPaidMap = {for (var id in allMemberIds) id: 0};
    final Map<String, int> shareMap = {for (var id in allMemberIds) id: 0};
    final Map<String, int> settlementPaidMap = {for (var id in allMemberIds) id: 0};
    final Map<String, int> settlementReceivedMap = {for (var id in allMemberIds) id: 0};

    // 1. Process Expenses
    for (final expense in expenses) {
      final int amountPaise = expense.amountPaise;
      if (amountPaise <= 0 || expense.participants.isEmpty) continue;

      // Payer contributed
      amountPaidMap[expense.paidBy] = (amountPaidMap[expense.paidBy] ?? 0) + amountPaise;

      // Split shares (handles both equal and unequal/exact splits)
      final shares = calculateExpenseShares(expense);

      for (final share in shares) {
        shareMap[share.userId] = (shareMap[share.userId] ?? 0) + share.amountPaise;
      }
    }

    // 2. Process Settlements
    for (final settlement in settlements) {
      final int amountPaise = settlement.amountPaise;
      if (amountPaise <= 0) continue;

      // FromUser paid settlement
      settlementPaidMap[settlement.fromUser] =
          (settlementPaidMap[settlement.fromUser] ?? 0) + amountPaise;

      // ToUser received settlement
      settlementReceivedMap[settlement.toUser] =
          (settlementReceivedMap[settlement.toUser] ?? 0) + amountPaise;
    }

    // 3. Compute net balance for each member
    final Map<String, MemberBalanceSummary> resultMap = {};
    for (final id in allMemberIds) {
      final paid = amountPaidMap[id] ?? 0;
      final share = shareMap[id] ?? 0;
      final setPaid = settlementPaidMap[id] ?? 0;
      final setRecv = settlementReceivedMap[id] ?? 0;

      // Net balance = (paid + setPaid) - (share + setRecv)
      // Positive = others owe this user; Negative = this user owes others
      final net = (paid + setPaid) - (share + setRecv);

      resultMap[id] = MemberBalanceSummary(
        userId: id,
        amountPaidPaise: paid,
        sharePaise: share,
        settlementPaidPaise: setPaid,
        settlementReceivedPaise: setRecv,
        netBalancePaise: net,
      );
    }

    return resultMap;
  }

  /// Calculates summary metrics specifically for the logged-in user
  static HouseholdSummary calculateHouseholdSummary({
    required String currentUserId,
    required List<ExpenseModel> expenses,
    required List<SettlementModel> settlements,
    required List<String> allMemberIds,
  }) {
    int totalExpensesPaise = 0;
    for (final expense in expenses) {
      totalExpensesPaise += expense.amountPaise;
    }

    final balances = calculateMemberBalances(
      expenses: expenses,
      settlements: settlements,
      allMemberIds: allMemberIds.contains(currentUserId)
          ? allMemberIds
          : [...allMemberIds, currentUserId],
    );

    final userBalance = balances[currentUserId] ??
        MemberBalanceSummary(
          userId: currentUserId,
          amountPaidPaise: 0,
          sharePaise: 0,
          settlementPaidPaise: 0,
          settlementReceivedPaise: 0,
          netBalancePaise: 0,
        );

    final int netBalance = userBalance.netBalancePaise;
    final int youOwe = netBalance < 0 ? netBalance.abs() : 0;
    final int youShouldReceive = netBalance > 0 ? netBalance : 0;

    return HouseholdSummary(
      totalExpensesPaise: totalExpensesPaise,
      youPaidPaise: userBalance.amountPaidPaise,
      yourSharePaise: userBalance.sharePaise,
      youOwePaise: youOwe,
      youShouldReceivePaise: youShouldReceive,
      netBalancePaise: netBalance,
    );
  }

  /// Calculates the minimal practical settlement transactions among roommates
  /// Using an optimal greedy debt-settlement algorithm.
  static List<SimplifiedDebt> calculateSimplifiedSettlements({
    required Map<String, MemberBalanceSummary> memberBalances,
  }) {
    // List of debtors (users who owe money, net balance < 0)
    final List<MapEntry<String, int>> debtors = [];
    // List of creditors (users who should receive money, net balance > 0)
    final List<MapEntry<String, int>> creditors = [];

    for (final entry in memberBalances.entries) {
      if (entry.value.netBalancePaise < 0) {
        debtors.add(MapEntry(entry.key, entry.value.netBalancePaise.abs()));
      } else if (entry.value.netBalancePaise > 0) {
        creditors.add(MapEntry(entry.key, entry.value.netBalancePaise));
      }
    }

    // Sort descending by amount to minimize total transaction count
    debtors.sort((a, b) => b.value.compareTo(a.value));
    creditors.sort((a, b) => b.value.compareTo(a.value));

    final List<SimplifiedDebt> simplifiedDebts = [];
    int debtorIdx = 0;
    int creditorIdx = 0;

    while (debtorIdx < debtors.length && creditorIdx < creditors.length) {
      final debtor = debtors[debtorIdx];
      final creditor = creditors[creditorIdx];

      final int settleAmount = debtor.value < creditor.value ? debtor.value : creditor.value;

      if (settleAmount > 0) {
        simplifiedDebts.add(SimplifiedDebt(
          fromUser: debtor.key,
          toUser: creditor.key,
          amountPaise: settleAmount,
        ));
      }

      debtors[debtorIdx] = MapEntry(debtor.key, debtor.value - settleAmount);
      creditors[creditorIdx] = MapEntry(creditor.key, creditor.value - settleAmount);

      if (debtors[debtorIdx].value == 0) {
        debtorIdx++;
      }
      if (creditors[creditorIdx].value == 0) {
        creditorIdx++;
      }
    }

    return simplifiedDebts;
  }

  /// Calculates category spending breakdown and percentage of total spend
  static List<CategorySpending> calculateCategoryBreakdown({
    required List<ExpenseModel> expenses,
  }) {
    if (expenses.isEmpty) return [];

    final Map<String, int> catTotalMap = {};
    final Map<String, int> catCountMap = {};
    int grandTotalPaise = 0;

    for (final exp in expenses) {
      final amount = exp.amountPaise;
      grandTotalPaise += amount;
      catTotalMap[exp.category] = (catTotalMap[exp.category] ?? 0) + amount;
      catCountMap[exp.category] = (catCountMap[exp.category] ?? 0) + 1;
    }

    final List<CategorySpending> results = [];
    for (final entry in catTotalMap.entries) {
      final percentage = grandTotalPaise > 0 ? (entry.value / grandTotalPaise) * 100 : 0.0;
      results.add(CategorySpending(
        category: entry.key,
        totalPaise: entry.value,
        percentage: percentage,
        expenseCount: catCountMap[entry.key] ?? 0,
      ));
    }

    // Sort by highest spending first
    results.sort((a, b) => b.totalPaise.compareTo(a.totalPaise));
    return results;
  }

  /// Groups expenses by Month and calculates monthly totals
  static List<MonthlySpending> calculateMonthlyBreakdown({
    required List<ExpenseModel> expenses,
  }) {
    if (expenses.isEmpty) return [];

    final Map<String, List<ExpenseModel>> monthlyGroups = {};

    for (final exp in expenses) {
      final key = '${exp.date.year}-${exp.date.month.toString().padLeft(2, '0')}';
      monthlyGroups.putIfAbsent(key, () => []).add(exp);
    }

    final List<MonthlySpending> result = [];
    for (final entry in monthlyGroups.entries) {
      final parts = entry.key.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final monthDate = DateTime(year, month);

      int totalPaise = 0;
      for (final exp in entry.value) {
        totalPaise += exp.amountPaise;
      }

      // Sort expenses within the month newest first
      entry.value.sort((a, b) => b.date.compareTo(a.date));

      result.add(MonthlySpending(
        monthYear: monthDate,
        totalPaise: totalPaise,
        expenses: entry.value,
      ));
    }

    // Sort months newest first
    result.sort((a, b) => b.monthYear.compareTo(a.monthYear));
    return result;
  }

  /// Calculates itemized pairwise balance and transaction history between two members
  static PairwiseBreakdown calculatePairwiseBreakdown({
    required String currentUserId,
    required String otherUserId,
    required List<ExpenseModel> expenses,
    required List<SettlementModel> settlements,
    required List<HouseholdMemberModel> members,
  }) {
    final otherMember = members.firstWhere(
      (m) => m.id == otherUserId,
      orElse: () => HouseholdMemberModel(
        id: otherUserId,
        name: 'Roommate',
        joinedAt: DateTime.now(),
      ),
    );

    final List<PairwiseItem> items = [];
    int netBalancePaise = 0;

    // 1. Process Expenses involving both users
    for (final expense in expenses) {
      if (expense.amountPaise <= 0 || expense.participants.isEmpty) continue;

      final shares = calculateExpenseShares(expense);
      final otherShare = shares
          .firstWhere((s) => s.userId == otherUserId,
              orElse: () => const SplitShare(userId: '', amountPaise: 0))
          .amountPaise;
      final currentShare = shares
          .firstWhere((s) => s.userId == currentUserId,
              orElse: () => const SplitShare(userId: '', amountPaise: 0))
          .amountPaise;

      // Case A: Current user paid, and other user was a participant
      if (expense.paidBy == currentUserId &&
          expense.participants.contains(otherUserId) &&
          otherShare > 0) {
        items.add(PairwiseItem(
          id: 'exp_${expense.id}',
          title: expense.title,
          date: expense.date,
          amountPaise: otherShare,
          youPaid: true,
          isSettlement: false,
          category: expense.category,
          description: '${otherMember.name} owes you',
        ));
        netBalancePaise += otherShare;
      }
      // Case B: Other user paid, and current user was a participant
      else if (expense.paidBy == otherUserId &&
          expense.participants.contains(currentUserId) &&
          currentShare > 0) {
        items.add(PairwiseItem(
          id: 'exp_${expense.id}',
          title: expense.title,
          date: expense.date,
          amountPaise: currentShare,
          youPaid: false,
          isSettlement: false,
          category: expense.category,
          description: 'You owe ${otherMember.name}',
        ));
        netBalancePaise -= currentShare;
      }
    }

    // 2. Process direct settlements between both users
    for (final settlement in settlements) {
      if (settlement.amountPaise <= 0) continue;

      // Current user paid other user
      if (settlement.fromUser == currentUserId &&
          settlement.toUser == otherUserId) {
        items.add(PairwiseItem(
          id: 'set_${settlement.id}',
          title: 'Settlement Payment',
          date: settlement.createdAt,
          amountPaise: settlement.amountPaise,
          youPaid: true,
          isSettlement: true,
          description: 'You paid ${otherMember.name}',
        ));
        netBalancePaise += settlement.amountPaise;
      }
      // Other user paid current user
      else if (settlement.fromUser == otherUserId &&
          settlement.toUser == currentUserId) {
        items.add(PairwiseItem(
          id: 'set_${settlement.id}',
          title: 'Settlement Payment',
          date: settlement.createdAt,
          amountPaise: settlement.amountPaise,
          youPaid: false,
          isSettlement: true,
          description: '${otherMember.name} paid you',
        ));
        netBalancePaise -= settlement.amountPaise;
      }
    }

    // Sort items by date descending (newest first)
    items.sort((a, b) => b.date.compareTo(a.date));

    return PairwiseBreakdown(
      currentUserId: currentUserId,
      otherUserId: otherUserId,
      otherUserName: otherMember.name,
      netBalancePaise: netBalancePaise,
      items: items,
    );
  }

  /// Calculates spending analytics insights for a group
  static GroupSpendingInsights calculateSpendingInsights({
    required List<ExpenseModel> expenses,
    required List<HouseholdMemberModel> members,
  }) {
    if (expenses.isEmpty) {
      return const GroupSpendingInsights(
        totalSpentPaise: 0,
        categoryBreakdown: [],
        highestSpenderId: null,
        highestSpenderName: null,
        highestSpenderAmountPaise: 0,
        largestExpense: null,
        averagePerMemberPaise: 0,
      );
    }

    int totalSpentPaise = 0;
    ExpenseModel? largestExp;
    final Map<String, int> payerTotals = {};

    for (final exp in expenses) {
      totalSpentPaise += exp.amountPaise;
      if (largestExp == null || exp.amountPaise > largestExp.amountPaise) {
        largestExp = exp;
      }
      payerTotals[exp.paidBy] =
          (payerTotals[exp.paidBy] ?? 0) + exp.amountPaise;
    }

    // Identify highest spender
    String? highestId;
    String? highestName;
    int highestAmount = 0;

    for (final entry in payerTotals.entries) {
      if (entry.value > highestAmount) {
        highestAmount = entry.value;
        highestId = entry.key;
        final m = members.firstWhere(
          (mem) => mem.id == entry.key,
          orElse: () => HouseholdMemberModel(
            id: entry.key,
            name: 'Member',
            joinedAt: DateTime.now(),
          ),
        );
        highestName = m.name;
      }
    }

    final categoryBreakdown = calculateCategoryBreakdown(expenses: expenses);
    final int count = members.isNotEmpty ? members.length : 1;
    final int avgPaise = totalSpentPaise ~/ count;

    return GroupSpendingInsights(
      totalSpentPaise: totalSpentPaise,
      categoryBreakdown: categoryBreakdown,
      highestSpenderId: highestId,
      highestSpenderName: highestName,
      highestSpenderAmountPaise: highestAmount,
      largestExpense: largestExp,
      averagePerMemberPaise: avgPaise,
    );
  }

  /// Assembles recent group activity timeline (expenses, settlements, joins)
  static List<GroupActivityItem> calculateGroupActivity({
    required List<ExpenseModel> expenses,
    required List<SettlementModel> settlements,
    required List<HouseholdMemberModel> members,
  }) {
    final Map<String, String> memberNameMap = {
      for (var m in members) m.id: m.name
    };

    final List<GroupActivityItem> activities = [];

    for (final exp in expenses) {
      final payerName = memberNameMap[exp.paidBy] ?? 'Someone';
      final amountFormatted = CurrencyFormatter.formatPaise(exp.amountPaise);
      activities.add(GroupActivityItem(
        id: 'exp_${exp.id}',
        type: GroupActivityType.expenseAdded,
        title: '$payerName added ${exp.title}',
        description: amountFormatted,
        timestamp: exp.createdAt,
        amountPaise: exp.amountPaise,
        category: exp.category,
        actorName: payerName,
      ));
    }

    for (final set in settlements) {
      final fromName = memberNameMap[set.fromUser] ?? 'Someone';
      final toName = memberNameMap[set.toUser] ?? 'Someone';
      final amountFormatted = CurrencyFormatter.formatPaise(set.amountPaise);
      activities.add(GroupActivityItem(
        id: 'set_${set.id}',
        type: GroupActivityType.settlementCompleted,
        title: '$fromName settled with $toName',
        description: amountFormatted,
        timestamp: set.createdAt,
        amountPaise: set.amountPaise,
        actorName: fromName,
      ));
    }

    for (final mem in members) {
      activities.add(GroupActivityItem(
        id: 'mem_${mem.id}',
        type: GroupActivityType.memberJoined,
        title: '${mem.name} joined the group',
        description: 'Joined on ${mem.joinedAt.day}/${mem.joinedAt.month}/${mem.joinedAt.year}',
        timestamp: mem.joinedAt,
        actorName: mem.name,
      ));
    }

    activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return activities;
  }
}
