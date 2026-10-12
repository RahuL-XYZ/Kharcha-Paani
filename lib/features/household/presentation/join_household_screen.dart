import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/household_provider.dart';
import 'package:kharcha_paani/l10n/app_localizations.dart';
import '../../../core/widgets/common_app_bar.dart';

class JoinHouseholdScreen extends ConsumerStatefulWidget {
  const JoinHouseholdScreen({super.key});

  @override
  ConsumerState<JoinHouseholdScreen> createState() =>
      _JoinHouseholdScreenState();
}

class _JoinHouseholdScreenState extends ConsumerState<JoinHouseholdScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleJoin() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    final household = await ref
        .read(householdControllerProvider.notifier)
        .joinHousehold(inviteCode: _codeController.text.trim());

    if (household != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.hhJoinSuccess(household.name)),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.go('/household/${household.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(householdControllerProvider);

    return Scaffold(
      appBar: CommonAppBar(
        titleText: AppLocalizations.of(context)!.hhJoinTitle,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.vpn_key_outlined,
                          color: AppColors.secondary, size: 32),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.hhJoinDesc,
                          style: TextStyle(
                            color: AppColors.textPrimaryLight,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                if (state.errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.negativeLight,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      state.errorMessage!,
                      style: const TextStyle(
                        color: AppColors.negative,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                TextFormField(
                  controller: _codeController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.characters,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 6,
                    fontFamily: 'monospace',
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  ],
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.hhCodeLabel,
                    hintText: AppLocalizations.of(context)!.hhCodeHint,
                    contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return AppLocalizations.of(context)!.hhCodeEmpty;
                    }
                    if (val.trim().length != 6) {
                      return AppLocalizations.of(context)!.hhCodeLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                ElevatedButton(
                  onPressed: state.isLoading ? null : _handleJoin,
                  child: state.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(AppLocalizations.of(context)!.hhJoinTitle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

