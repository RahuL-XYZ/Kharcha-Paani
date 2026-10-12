import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kharcha_paani/l10n/app_localizations.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../balances/providers/overall_balance_provider.dart';

class HomeHeaderWidget extends StatelessWidget {
  final AsyncValue<OverallUserBalance> overallBalanceAsync;
  final String displayName;
  final String greeting;

  const HomeHeaderWidget({
    super.key,
    required this.overallBalanceAsync,
    required this.displayName,
    required this.greeting,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D6E6F), // Deep Teal (dark Mint Cyan)
              Color(0xFF1A9696), // Mid Deep Cyan
              Color(0xFFB0456A), // Deep Rose Pink
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top Row: Logo + App Name + Profile ──
                Row(
                  children: [
                    AppLogo(
                      size: 34,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      AppConstants.appName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => context.push(RouteNames.profile),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.person_outline_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Greeting ──
                Text(
                  '$greeting, $displayName 👋',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),

                // ── Balance Section ──
                overallBalanceAsync.maybeWhen(
                  data: (balance) => _BalanceContent(balance: balance),
                  orElse: () => const _BalanceLoadingPlaceholder(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BalanceContent extends StatelessWidget {
  final OverallUserBalance balance;
  const _BalanceContent({required this.balance});

  @override
  Widget build(BuildContext context) {
    final net = balance.netBalancePaise;
    final isOwed = net > 0;
    final owes = net < 0;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Net Standing Label + Groups badge ──
        Row(
          children: [
            Text(
              l10n.homeTotalNetStanding,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(width: 8),
            if (balance.totalHouseholds > 0)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l10n.homeGroupCount(balance.totalHouseholds),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // ── Big Net Amount ──
        Text(
          net == 0
              ? l10n.homeSettledUp
              : CurrencyFormatter.formatPaise(net.abs()),
          style: TextStyle(
            color: isOwed
                ? const Color(0xFF4ADE80)
                : owes
                    ? const Color(0xFFFB7185)
                    : Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.0,
            height: 1.1,
          ),
        ),
        if (net != 0)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              isOwed
                  ? 'Overall you are owed'
                  : 'Overall you owe',
              style: TextStyle(
                color: isOwed
                    ? const Color(0xFF4ADE80).withValues(alpha: 0.85)
                    : const Color(0xFFFB7185).withValues(alpha: 0.85),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        const SizedBox(height: 20),

        // ── Stat Pills Row ──
        Row(
          children: [
            _StatPill(
              label: l10n.homeTotalToReceive,
              value: CurrencyFormatter.formatPaise(
                  balance.totalYouShouldReceivePaise),
              valueColor: const Color(0xFF4ADE80),
              icon: Icons.arrow_circle_down_rounded,
            ),
            const SizedBox(width: 12),
            _StatPill(
              label: l10n.homeTotalYouOwe,
              value:
                  CurrencyFormatter.formatPaise(balance.totalYouOwePaise),
              valueColor: const Color(0xFFFB7185),
              icon: Icons.arrow_circle_up_rounded,
            ),
          ],
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final IconData icon;

  const _StatPill({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: valueColor, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      color: valueColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceLoadingPlaceholder extends StatelessWidget {
  const _BalanceLoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 36,
          width: 180,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
