import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kharcha_paani/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../providers/household_provider.dart';

class CreateHouseholdScreen extends ConsumerStatefulWidget {
  const CreateHouseholdScreen({super.key});

  @override
  ConsumerState<CreateHouseholdScreen> createState() =>
      _CreateHouseholdScreenState();
}

class _CreateHouseholdScreenState extends ConsumerState<CreateHouseholdScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedCategory = 'home';

  List<Map<String, dynamic>> _getCategories(BuildContext context) => [
    {'id': 'home', 'label': AppLocalizations.of(context)!.hhCatHome, 'emoji': '🏠', 'icon': Icons.home_outlined},
    {'id': 'trip', 'label': AppLocalizations.of(context)!.hhCatTrip, 'emoji': '🏖️', 'icon': Icons.flight_takeoff_rounded},
    {'id': 'friends', 'label': AppLocalizations.of(context)!.hhCatFriends, 'emoji': '🍻', 'icon': Icons.celebration_rounded},
    {'id': 'office', 'label': AppLocalizations.of(context)!.hhCatOffice, 'emoji': '💼', 'icon': Icons.work_outline_rounded},
    {'id': 'other', 'label': AppLocalizations.of(context)!.hhCatOther, 'emoji': '🎯', 'icon': Icons.category_outlined},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    final household = await ref
        .read(householdControllerProvider.notifier)
        .createHousehold(
          name: _nameController.text.trim(),
          category: _selectedCategory,
        );

    if (household != null && mounted) {
      context.pushReplacement(
        '/invite-code',
        extra: {
          'householdId': household.id,
          'householdName': household.name,
          'inviteCode': household.inviteCode,
        },
      );
    }
  }

  String _getHintText(BuildContext context) {
    switch (_selectedCategory) {
      case 'trip':
        return AppLocalizations.of(context)!.hhHintTrip;
      case 'friends':
        return AppLocalizations.of(context)!.hhHintFriends;
      case 'office':
        return AppLocalizations.of(context)!.hhHintOffice;
      case 'other':
        return AppLocalizations.of(context)!.hhHintOther;
      case 'home':
      default:
        return AppLocalizations.of(context)!.hhHintHome;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(householdControllerProvider);

    return Scaffold(
      appBar: CommonAppBar(
        titleText: AppLocalizations.of(context)!.hhCreateTitle,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.group_add_outlined,
                          color: AppColors.primary, size: 32),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.hhCreateDesc,
                          style: TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

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

                // Category Selector
                Text(
                  AppLocalizations.of(context)!.hhGroupType,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _getCategories(context).map((cat) {
                    final isSelected = _selectedCategory == cat['id'];
                    return ChoiceChip(
                      avatar: Text(cat['emoji'] as String),
                      label: Text(cat['label'] as String),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = cat['id'] as String;
                          });
                        }
                      },
                      selectedColor: AppColors.primaryLight,
                      labelStyle: TextStyle(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.primaryDark : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleCreate(),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.hhNameLabel,
                    hintText: _getHintText(context),
                    prefixIcon: const Icon(Icons.drive_file_rename_outline),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return AppLocalizations.of(context)!.hhNameEmpty;
                    }
                    if (val.trim().length < 2) {
                      return AppLocalizations.of(context)!.hhNameShort;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: state.isLoading ? null : _handleCreate,
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
                      : Text(AppLocalizations.of(context)!.homeCreateGroup),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
