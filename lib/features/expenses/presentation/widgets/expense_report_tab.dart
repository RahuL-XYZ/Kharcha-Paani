import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kharcha_paani/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../models/expense_model.dart';
import '../../../../models/household_member_model.dart';
import '../../../../services/expense_calculation_service.dart';

// Palette of distinct colors for chart segments
const _chartColors = [
  Color(0xFF56D7D8), // Vibrant Mint Cyan (Primary)
  Color(0xFFF5C431), // Vibrant Warm Yellow (Secondary)
  Color(0xFFF5B5C3), // Soft Rose Pink (Tertiary)
  Color(0xFF78E08F), // Tropical Green
  Color(0xFFA55EEA), // Playful Purple
  Color(0xFFFD9644), // Peachy Orange
  Color(0xFF45AAF2), // Bright Blue
  Color(0xFFD1D8E0), // Soft Grey
];

class ExpenseReportTab extends StatefulWidget {
  final ExpenseModel expense;
  final List<HouseholdMemberModel> members;
  final String currentUserId;

  const ExpenseReportTab({
    super.key,
    required this.expense,
    required this.members,
    required this.currentUserId,
  });

  @override
  State<ExpenseReportTab> createState() => _ExpenseReportTabState();
}

class _ExpenseReportTabState extends State<ExpenseReportTab> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shares = ExpenseCalculationService.calculateEqualSplit(
      amountPaise: widget.expense.amountPaise,
      participantIds: widget.expense.participants,
    );

    final totalPaise = widget.expense.amountPaise;

    // Build sections
    final sections = List.generate(shares.length, (i) {
      final share = shares[i];
      final isTouched = i == _touchedIndex;
      final percentage =
          totalPaise > 0 ? (share.amountPaise / totalPaise * 100) : 0.0;
      final color = _chartColors[i % _chartColors.length];

      return PieChartSectionData(
        color: color,
        value: share.amountPaise.toDouble(),
        title: isTouched ? '${percentage.toStringAsFixed(1)}%' : '',
        radius: isTouched ? 72 : 60,
        titleStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          shadows: [Shadow(blurRadius: 4, color: Colors.black26)],
        ),
        badgeWidget: null,
      );
    });

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        // ── Header ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Expense Report',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceVariantDark
                    : AppColors.surfaceVariantLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.donut_large_rounded,
                size: 20,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // ── Donut Chart ──
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceVariantDark
                : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, PieTouchResponse? res) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  res == null ||
                                  res.touchedSection == null) {
                                _touchedIndex = -1;
                              } else {
                                _touchedIndex =
                                    res.touchedSection!.touchedSectionIndex;
                              }
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 3,
                        centerSpaceRadius: 60,
                        sections: sections,
                      ),
                    ),
                    // Center label
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          CurrencyFormatter.formatRupees(widget.expense.amount),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          '${shares.length} ${AppLocalizations.of(context)!.expRoommate.toLowerCase()}s',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.textTertiaryDark
                                : AppColors.textTertiaryLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // ── All Expenses Label ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Share Breakdown',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              'Total ${CurrencyFormatter.formatRupees(widget.expense.amount)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ── Breakdown Rows ──
        ...List.generate(shares.length, (i) {
          final share = shares[i];
          final color = _chartColors[i % _chartColors.length];
          final participant = widget.members.firstWhere(
            (m) => m.id == share.userId,
            orElse: () => HouseholdMemberModel(
              id: share.userId,
              name: AppLocalizations.of(context)!.expRoommate,
              joinedAt: DateTime.now(),
            ),
          );
          final isMe = share.userId == widget.currentUserId;
          final percentage =
              totalPaise > 0 ? (share.amountPaise / totalPaise * 100) : 0.0;
          final isTouched = i == _touchedIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                _touchedIndex = isTouched ? -1 : i;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isTouched
                    ? color.withValues(alpha: 0.1)
                    : isDark
                        ? AppColors.surfaceVariantDark
                        : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isTouched
                      ? color.withValues(alpha: 0.4)
                      : isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                  width: isTouched ? 1.5 : 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Colored dot
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Name
                      Expanded(
                        child: Text(
                          isMe
                              ? '${participant.name} (You)'
                              : participant.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                      // Amount
                      Text(
                        CurrencyFormatter.formatPaise(share.amountPaise),
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Percentage badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: totalPaise > 0
                          ? share.amountPaise / totalPaise
                          : 0,
                      backgroundColor:
                          color.withValues(alpha: isDark ? 0.15 : 0.12),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 40),
      ],
    );
  }
}
