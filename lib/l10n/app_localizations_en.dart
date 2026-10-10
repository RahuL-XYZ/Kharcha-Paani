// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Kharcha Paani';

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get authWelcomeBack => 'Welcome back';

  @override
  String get authLoginSubtitle => 'Log in to manage your household expenses';

  @override
  String get authEmailLabel => 'Email Address';

  @override
  String get authEmailHint => 'e.g. rahul@example.com';

  @override
  String get authEmailEmptyError => 'Please enter your email';

  @override
  String get authEmailInvalidError => 'Please enter a valid email address';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordHint => '••••••••';

  @override
  String get authPasswordEmptyError => 'Please enter your password';

  @override
  String get authPasswordLengthError =>
      'Password must be at least 6 characters';

  @override
  String get authForgotPasswordText => 'Forgot password?';

  @override
  String get authLoginButton => 'Log In';

  @override
  String get authNoAccountText => 'Don\'t have an account?';

  @override
  String get authSignUpButton => 'Sign Up';

  @override
  String get profileTitle => 'Profile & Settings';

  @override
  String get profileEditName => 'Edit Name';

  @override
  String get profileFullName => 'Full Name';

  @override
  String get profileNameHint => 'Enter your name';

  @override
  String get profileNameEmptyError => 'Name cannot be empty';

  @override
  String get profileCancel => 'Cancel';

  @override
  String get profileSave => 'Save';

  @override
  String get profileUpdatedMsg => 'Profile updated successfully!';

  @override
  String get profileLogoutTitle => 'Log Out';

  @override
  String get profileLogoutConfirm =>
      'Are you sure you want to log out of Kharcha Paani?';

  @override
  String get profileAppearance => 'Appearance';

  @override
  String get profileThemeMode => 'Theme Mode';

  @override
  String get profileThemeSystem => 'System';

  @override
  String get profileThemeLight => 'Light';

  @override
  String get profileThemeDark => 'Dark';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileLanguageEn => 'English';

  @override
  String get profileLanguageHi => 'हिन्दी (Hindi)';

  @override
  String get profileAbout => 'About';

  @override
  String get profileAboutApp => 'About Kharcha Paani';

  @override
  String get profileAboutSub => 'Version 1.0.0 • Roommate Expense Sharing';

  @override
  String get profileSecurity => 'Security & Calculations';

  @override
  String get profileSecuritySub =>
      'Integer paise precision • Zero float errors';

  @override
  String get authRegisterTitle => 'Create Account';

  @override
  String authRegisterSubtitle(String appName) {
    return 'Get started with $appName';
  }

  @override
  String get authRegisterDesc =>
      'Share flat expenses fairly and transparently with roommates.';

  @override
  String get authNameLabel => 'Full Name';

  @override
  String get authNameHint => 'e.g. Rahul Sharma';

  @override
  String get authNameEmptyError => 'Please enter your name';

  @override
  String get authNameLengthError => 'Name must be at least 2 characters';

  @override
  String get authPasswordHint2 => 'At least 6 characters';

  @override
  String get authConfirmPasswordLabel => 'Confirm Password';

  @override
  String get authConfirmPasswordHint => 'Repeat password';

  @override
  String get authConfirmPasswordEmptyError => 'Please confirm your password';

  @override
  String get authConfirmPasswordMatchError => 'Passwords do not match';

  @override
  String get authHasAccountText => 'Already have an account?';

  @override
  String get authResetTitle => 'Reset Password';

  @override
  String get authCheckEmailTitle => 'Check your email';

  @override
  String authCheckEmailDesc(String email) {
    return 'We sent password reset instructions to\n$email';
  }

  @override
  String get authBackToLogin => 'Back to Log In';

  @override
  String get authForgotTitle => 'Forgot your password?';

  @override
  String get authForgotDesc =>
      'Enter your registered email and we will send you instructions to reset your password.';

  @override
  String get authSendResetLink => 'Send Reset Link';

  @override
  String get homeGreetingMorning => 'Good morning';

  @override
  String get homeGreetingAfternoon => 'Good afternoon';

  @override
  String get homeGreetingEvening => 'Good evening';

  @override
  String get homeFriend => 'Friend';

  @override
  String get homeTrackSplitExpenses =>
      'Track and split expenses across all your groups';

  @override
  String get homeTotalNetStanding => 'TOTAL NET STANDING';

  @override
  String homeGroupCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count groups',
      one: '1 group',
    );
    return '$_temp0';
  }

  @override
  String homeYouAreOwed(String amount) {
    return 'You are owed $amount';
  }

  @override
  String homeYouOwe(String amount) {
    return 'You owe $amount';
  }

  @override
  String get homeSettledUp => 'You are all settled up!';

  @override
  String get homeTotalToReceive => 'Total to receive';

  @override
  String get homeTotalYouOwe => 'Total you owe';

  @override
  String get homeCreateGroup => 'Create Group';

  @override
  String get homeJoinRoom => 'Join Room';

  @override
  String get homeMyGroups => 'My Groups & Households';

  @override
  String homeTotalCount(int count) {
    return '$count total';
  }

  @override
  String get homeFailedLoad => 'Failed to load households';

  @override
  String get homeTryAgain => 'Try Again';

  @override
  String get homeNoHouseholdsTitle => 'No households yet';

  @override
  String get homeNoHouseholdsDesc =>
      'Create a household or join one\nto start tracking shared expenses with roommates.';

  @override
  String get homeCreateHouseholdBtn => 'Create Household';

  @override
  String get homeJoinHouseholdBtn => 'Join Household';

  @override
  String homeMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String get homeTotalExpenses => 'Total expenses';

  @override
  String homeYouReceive(String amount) {
    return 'You receive $amount';
  }

  @override
  String get homeSettledUpBadge => 'Settled up';

  @override
  String get homeTapDetails => 'Tap to view details';

  @override
  String get hhCreateTitle => 'Create Group / Household';

  @override
  String get hhCreateDesc =>
      'Create a shared space for your roommates, travel buddies, or friend groups to split bills effortlessly.';

  @override
  String get hhCatHome => 'Flat / Home';

  @override
  String get hhCatTrip => 'Trip / Vacation';

  @override
  String get hhCatFriends => 'Friends / Hangout';

  @override
  String get hhCatOffice => 'Office / Project';

  @override
  String get hhCatOther => 'Other';

  @override
  String get hhHintTrip => 'e.g. Goa Trip 2026, Ladakh Roadtrip';

  @override
  String get hhHintFriends => 'e.g. Weekend Dinners, College Gang';

  @override
  String get hhHintOffice => 'e.g. Lunch Crew, Hackathon Team';

  @override
  String get hhHintOther => 'e.g. Book Club, Gym Buddies';

  @override
  String get hhHintHome => 'e.g. Flat 302, Green Villa, Room 104';

  @override
  String get hhGroupType => 'Group Type';

  @override
  String get hhNameLabel => 'Group / Household Name';

  @override
  String get hhNameEmpty => 'Please enter a name';

  @override
  String get hhNameShort => 'Name must be at least 2 characters';

  @override
  String hhJoinSuccess(String name) {
    return 'Joined $name successfully! 🎉';
  }

  @override
  String get hhJoinTitle => 'Join Household';

  @override
  String get hhJoinDesc =>
      'Ask your roommate for the 6-character room code to join and split expenses.';

  @override
  String get hhCodeLabel => '6-Character Invite Code';

  @override
  String get hhCodeHint => 'e.g. X7K92P';

  @override
  String get hhCodeEmpty => 'Please enter the invite code';

  @override
  String get hhCodeLength => 'Invite code must be exactly 6 characters';

  @override
  String get hhReadyTitle => 'Your household is ready 🎉';

  @override
  String get hhInviteCodeLabel => 'INVITE CODE';

  @override
  String get hhShareCodeDesc =>
      'Share this 6-character code with your roommates so they can join your room.';

  @override
  String get hhCodeCopied => 'Invite code copied to clipboard!';

  @override
  String get hhCopyBtn => 'Copy';

  @override
  String get hhShareBtn => 'Share';

  @override
  String hhShareText(String name, String code) {
    return 'Hey! I created a room for us on Kharcha Paani: \"$name\".\n\nJoin using my invite code: *$code*\n\nDownload the app to split our expenses easily!';
  }

  @override
  String get hhGoToHouseholdBtn => 'Go to Household';

  @override
  String get hhMembersTitle => 'Roommates & Members';

  @override
  String get hhCopyInviteCodeTooltip => 'Copy Invite Code';

  @override
  String hhInviteCodeCopied(String code) {
    return 'Invite code #$code copied!';
  }

  @override
  String get hhHouseholdInviteCode => 'Household Invite Code';

  @override
  String get hhInviteCodeCopiedShort => 'Invite code copied!';

  @override
  String hhMembersCountLabel(int count) {
    return 'Members ($count)';
  }

  @override
  String get hhYouBadge => 'You';

  @override
  String hhJoinedDate(String date) {
    return 'Joined $date';
  }

  @override
  String get hhOwnerRole => 'Owner';

  @override
  String get hhMemberRole => 'Member';

  @override
  String hhError(String err) {
    return 'Error: $err';
  }

  @override
  String get hhDashboardHouseholdTitle => 'Household';

  @override
  String get hhDashboardHouseholdNotFound => 'Household not found.';

  @override
  String get hhDashboardTab => 'Dashboard';

  @override
  String get hhDashboardExpensesTab => 'Expenses';

  @override
  String get hhDashboardBalancesTab => 'Balances';

  @override
  String get hhDashboardAnalyticsTab => 'Analytics';

  @override
  String get hhDashboardAllGroups => 'All Groups';

  @override
  String get hhDashboardViewMembers => 'View Members';

  @override
  String get hhDashboardGroupOptions => 'Group Options';

  @override
  String get hhDashboardSwitchGroup => 'Switch Group';

  @override
  String get hhDashboardInviteFriends => 'Invite Friends';

  @override
  String get hhDashboardLeaveGroup => 'Leave Group';

  @override
  String get hhDashboardDeleteGroup => 'Delete Group';

  @override
  String get hhLeaveGroupTitle => 'Leave Group?';

  @override
  String hhLeaveGroupDesc(String name) {
    return 'Are you sure you want to leave \"$name\"? You will no longer have access to this group\'s expenses and balances.';
  }

  @override
  String get hhCancel => 'Cancel';

  @override
  String get hhLeaveBtn => 'Leave';

  @override
  String get hhDeleteGroupTitle => 'Delete Group?';

  @override
  String hhDeleteGroupDesc(String name) {
    return 'Are you sure you want to delete \"$name\"? This group will be archived and hidden for all members.';
  }

  @override
  String get hhDeleteBtn => 'Delete';

  @override
  String get hhAddExpenseBtn => 'Add Expense';

  @override
  String get expAddTitle => 'Add Expense';

  @override
  String get expEditTitle => 'Edit Expense';

  @override
  String get expNoParticipantsError =>
      'Please select at least one roommate to split with.';

  @override
  String get expAllocMismatchExact =>
      'Allocated amount must exactly match total amount.';

  @override
  String get expAllocMismatchPercent => 'Allocated percentage must equal 100%.';

  @override
  String get expAllocMismatchShares => 'At least one share must be allocated.';

  @override
  String get expUpdatedSuccess => 'Expense updated successfully!';

  @override
  String get expAddedSuccess => 'Expense added successfully! 🎉';

  @override
  String get expAmountEmpty => 'Enter amount';

  @override
  String get expAmountInvalid => 'Amount must be > 0';

  @override
  String get expTitleLabel => 'Expense Title';

  @override
  String get expTitleHint => 'e.g. Grocery, Electricity, Wi-Fi';

  @override
  String get expTitleEmpty => 'Please enter a title';

  @override
  String get expCategoryLabel => 'Category';

  @override
  String get expPaidByLabel => 'Paid by';

  @override
  String get expDateLabel => 'Date';

  @override
  String get expNotesLabel => 'Notes (Optional)';

  @override
  String get expNotesHint => 'e.g. Bought from Supermarket, Bill #48';

  @override
  String get expSaveBtn => 'Save Changes';

  @override
  String get expYouSuffix => '(You)';

  @override
  String get expSplitEqual => 'Equal Split';

  @override
  String get expSplitExact => 'Exact Amount';

  @override
  String get expSplitShares => 'Shares';

  @override
  String expSplitBetween(int selected, int total) {
    return 'Split between ($selected/$total)';
  }

  @override
  String get expSelectOnlyMe => 'Select only me';

  @override
  String get expSelectAll => 'Select all';

  @override
  String expAllocFully(String amount) {
    return 'Fully allocated! (Total: ₹$amount)';
  }

  @override
  String expAllocRemaining(String amount) {
    return 'Remaining: ₹$amount';
  }

  @override
  String expAllocOver(String amount) {
    return 'Over-allocated by ₹$amount';
  }

  @override
  String expAllocShares(int amount) {
    return 'Total Shares: $amount';
  }

  @override
  String get expDeleteTitle => 'Delete Expense?';

  @override
  String expDeleteDesc(String title, String amount) {
    return 'Are you sure you want to delete \"$title\" of $amount? This will recalculate all balances.';
  }

  @override
  String get expDeletedSuccess => 'Expense deleted successfully';

  @override
  String get expDetailTitle => 'Expense Details';

  @override
  String get expNotFound => 'Expense not found';

  @override
  String get expRoommate => 'Roommate';

  @override
  String get expEditTooltip => 'Edit';

  @override
  String get expDeleteTooltip => 'Delete';

  @override
  String expYouWithName(String name) {
    return 'You ($name)';
  }

  @override
  String get expNotesHeader => 'Notes';

  @override
  String get expSplitBreakdown => 'Split Breakdown';

  @override
  String get expSplitSuffix => 'SPLIT';

  @override
  String get expSharesSuffix => 'shares';

  @override
  String get expExactSuffix => 'Exact';

  @override
  String get expHistoryTitle => 'Expense History';

  @override
  String get expSearchHint => 'Search by title or notes...';

  @override
  String expCatFilter(String category) {
    return 'Cat: $category';
  }

  @override
  String expMemberFilter(String name) {
    return 'Member: $name';
  }

  @override
  String get expSelected => 'Selected';

  @override
  String get expDateFiltered => 'Date filtered';

  @override
  String get expNoMatch => 'No matching expenses found';

  @override
  String get expAdjustFilters => 'Try adjusting your filters';

  @override
  String get expNoExpensesYet => 'No expenses recorded yet';

  @override
  String get expTapToAdd => 'Tap + to add your first shared expense';

  @override
  String expTotalAmount(String amount) {
    return 'Total $amount';
  }

  @override
  String get hhYouAreOwed => 'You are owed';

  @override
  String get hhYouOwe => 'You owe';

  @override
  String get hhYouAreSettledUp => 'You are settled up';

  @override
  String get hhTotalGroupSpend => 'Total group spend';

  @override
  String get hhAllSettledUp => 'All settled up! 🎉';

  @override
  String get hhYouPaid => 'You paid';

  @override
  String get hhYourShare => 'Your share';

  @override
  String get hhSettleUp => 'Settle Up';

  @override
  String get hhGroupExpenses => 'Group Expenses';

  @override
  String get hhViewAll => 'View All';

  @override
  String get hhStartSplitting =>
      'Start splitting group expenses with your roommates.';

  @override
  String get hhAddFirstExpense => 'Add First Expense';
}
