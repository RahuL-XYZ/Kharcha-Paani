import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Kharcha Paani'**
  String get appName;

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authWelcomeBack;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to manage your household expenses'**
  String get authLoginSubtitle;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get authEmailLabel;

  /// No description provided for @authEmailHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. rahul@example.com'**
  String get authEmailHint;

  /// No description provided for @authEmailEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get authEmailEmptyError;

  /// No description provided for @authEmailInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get authEmailInvalidError;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get authPasswordHint;

  /// No description provided for @authPasswordEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get authPasswordEmptyError;

  /// No description provided for @authPasswordLengthError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get authPasswordLengthError;

  /// No description provided for @authForgotPasswordText.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPasswordText;

  /// No description provided for @authLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get authLoginButton;

  /// No description provided for @authNoAccountText.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authNoAccountText;

  /// No description provided for @authSignUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSignUpButton;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile & Settings'**
  String get profileTitle;

  /// No description provided for @profileEditName.
  ///
  /// In en, this message translates to:
  /// **'Edit Name'**
  String get profileEditName;

  /// No description provided for @profileFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get profileFullName;

  /// No description provided for @profileNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get profileNameHint;

  /// No description provided for @profileNameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get profileNameEmptyError;

  /// No description provided for @profileCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileCancel;

  /// No description provided for @profileSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileSave;

  /// No description provided for @profileUpdatedMsg.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedMsg;

  /// No description provided for @profileLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileLogoutTitle;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of Kharcha Paani?'**
  String get profileLogoutConfirm;

  /// No description provided for @profileAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileAppearance;

  /// No description provided for @profileThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get profileThemeMode;

  /// No description provided for @profileThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get profileThemeSystem;

  /// No description provided for @profileThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get profileThemeLight;

  /// No description provided for @profileThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get profileThemeDark;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileLanguageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get profileLanguageEn;

  /// No description provided for @profileLanguageHi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी (Hindi)'**
  String get profileLanguageHi;

  /// No description provided for @profileAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get profileAbout;

  /// No description provided for @profileAboutApp.
  ///
  /// In en, this message translates to:
  /// **'About Kharcha Paani'**
  String get profileAboutApp;

  /// No description provided for @profileAboutSub.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0 • Roommate Expense Sharing'**
  String get profileAboutSub;

  /// No description provided for @profileSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security & Calculations'**
  String get profileSecurity;

  /// No description provided for @profileSecuritySub.
  ///
  /// In en, this message translates to:
  /// **'Integer paise precision • Zero float errors'**
  String get profileSecuritySub;

  /// No description provided for @authRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authRegisterTitle;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get started with {appName}'**
  String authRegisterSubtitle(String appName);

  /// No description provided for @authRegisterDesc.
  ///
  /// In en, this message translates to:
  /// **'Share flat expenses fairly and transparently with roommates.'**
  String get authRegisterDesc;

  /// No description provided for @authNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authNameLabel;

  /// No description provided for @authNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Rahul Sharma'**
  String get authNameHint;

  /// No description provided for @authNameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get authNameEmptyError;

  /// No description provided for @authNameLengthError.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get authNameLengthError;

  /// No description provided for @authPasswordHint2.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get authPasswordHint2;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get authConfirmPasswordHint;

  /// No description provided for @authConfirmPasswordEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get authConfirmPasswordEmptyError;

  /// No description provided for @authConfirmPasswordMatchError.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authConfirmPasswordMatchError;

  /// No description provided for @authHasAccountText.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authHasAccountText;

  /// No description provided for @authResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetTitle;

  /// No description provided for @authCheckEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get authCheckEmailTitle;

  /// No description provided for @authCheckEmailDesc.
  ///
  /// In en, this message translates to:
  /// **'We sent password reset instructions to\n{email}'**
  String authCheckEmailDesc(String email);

  /// No description provided for @authBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Log In'**
  String get authBackToLogin;

  /// No description provided for @authForgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get authForgotTitle;

  /// No description provided for @authForgotDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email and we will send you instructions to reset your password.'**
  String get authForgotDesc;

  /// No description provided for @authSendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get authSendResetLink;

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGreetingMorning;

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get homeGreetingAfternoon;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get homeGreetingEvening;

  /// No description provided for @homeFriend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get homeFriend;

  /// No description provided for @homeTrackSplitExpenses.
  ///
  /// In en, this message translates to:
  /// **'Track and split expenses across all your groups'**
  String get homeTrackSplitExpenses;

  /// No description provided for @homeTotalNetStanding.
  ///
  /// In en, this message translates to:
  /// **'TOTAL NET STANDING'**
  String get homeTotalNetStanding;

  /// No description provided for @homeGroupCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 group} other{{count} groups}}'**
  String homeGroupCount(int count);

  /// No description provided for @homeYouAreOwed.
  ///
  /// In en, this message translates to:
  /// **'You are owed {amount}'**
  String homeYouAreOwed(String amount);

  /// No description provided for @homeYouOwe.
  ///
  /// In en, this message translates to:
  /// **'You owe {amount}'**
  String homeYouOwe(String amount);

  /// No description provided for @homeSettledUp.
  ///
  /// In en, this message translates to:
  /// **'You are all settled up!'**
  String get homeSettledUp;

  /// No description provided for @homeTotalToReceive.
  ///
  /// In en, this message translates to:
  /// **'Total to receive'**
  String get homeTotalToReceive;

  /// No description provided for @homeTotalYouOwe.
  ///
  /// In en, this message translates to:
  /// **'Total you owe'**
  String get homeTotalYouOwe;

  /// No description provided for @homeCreateGroup.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get homeCreateGroup;

  /// No description provided for @homeJoinRoom.
  ///
  /// In en, this message translates to:
  /// **'Join Room'**
  String get homeJoinRoom;

  /// No description provided for @homeMyGroups.
  ///
  /// In en, this message translates to:
  /// **'My Groups & Households'**
  String get homeMyGroups;

  /// No description provided for @homeTotalCount.
  ///
  /// In en, this message translates to:
  /// **'{count} total'**
  String homeTotalCount(int count);

  /// No description provided for @homeFailedLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load households'**
  String get homeFailedLoad;

  /// No description provided for @homeTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get homeTryAgain;

  /// No description provided for @homeNoHouseholdsTitle.
  ///
  /// In en, this message translates to:
  /// **'No households yet'**
  String get homeNoHouseholdsTitle;

  /// No description provided for @homeNoHouseholdsDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a household or join one\nto start tracking shared expenses with roommates.'**
  String get homeNoHouseholdsDesc;

  /// No description provided for @homeCreateHouseholdBtn.
  ///
  /// In en, this message translates to:
  /// **'Create Household'**
  String get homeCreateHouseholdBtn;

  /// No description provided for @homeJoinHouseholdBtn.
  ///
  /// In en, this message translates to:
  /// **'Join Household'**
  String get homeJoinHouseholdBtn;

  /// No description provided for @homeMemberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 member} other{{count} members}}'**
  String homeMemberCount(int count);

  /// No description provided for @homeTotalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total expenses'**
  String get homeTotalExpenses;

  /// No description provided for @homeYouReceive.
  ///
  /// In en, this message translates to:
  /// **'You receive {amount}'**
  String homeYouReceive(String amount);

  /// No description provided for @homeSettledUpBadge.
  ///
  /// In en, this message translates to:
  /// **'Settled up'**
  String get homeSettledUpBadge;

  /// No description provided for @homeTapDetails.
  ///
  /// In en, this message translates to:
  /// **'Tap to view details'**
  String get homeTapDetails;

  /// No description provided for @hhCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Group / Household'**
  String get hhCreateTitle;

  /// No description provided for @hhCreateDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a shared space for your roommates, travel buddies, or friend groups to split bills effortlessly.'**
  String get hhCreateDesc;

  /// No description provided for @hhCatHome.
  ///
  /// In en, this message translates to:
  /// **'Flat / Home'**
  String get hhCatHome;

  /// No description provided for @hhCatTrip.
  ///
  /// In en, this message translates to:
  /// **'Trip / Vacation'**
  String get hhCatTrip;

  /// No description provided for @hhCatFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends / Hangout'**
  String get hhCatFriends;

  /// No description provided for @hhCatOffice.
  ///
  /// In en, this message translates to:
  /// **'Office / Project'**
  String get hhCatOffice;

  /// No description provided for @hhCatOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get hhCatOther;

  /// No description provided for @hhHintTrip.
  ///
  /// In en, this message translates to:
  /// **'e.g. Goa Trip 2026, Ladakh Roadtrip'**
  String get hhHintTrip;

  /// No description provided for @hhHintFriends.
  ///
  /// In en, this message translates to:
  /// **'e.g. Weekend Dinners, College Gang'**
  String get hhHintFriends;

  /// No description provided for @hhHintOffice.
  ///
  /// In en, this message translates to:
  /// **'e.g. Lunch Crew, Hackathon Team'**
  String get hhHintOffice;

  /// No description provided for @hhHintOther.
  ///
  /// In en, this message translates to:
  /// **'e.g. Book Club, Gym Buddies'**
  String get hhHintOther;

  /// No description provided for @hhHintHome.
  ///
  /// In en, this message translates to:
  /// **'e.g. Flat 302, Green Villa, Room 104'**
  String get hhHintHome;

  /// No description provided for @hhGroupType.
  ///
  /// In en, this message translates to:
  /// **'Group Type'**
  String get hhGroupType;

  /// No description provided for @hhNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Group / Household Name'**
  String get hhNameLabel;

  /// No description provided for @hhNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get hhNameEmpty;

  /// No description provided for @hhNameShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get hhNameShort;

  /// No description provided for @hhJoinSuccess.
  ///
  /// In en, this message translates to:
  /// **'Joined {name} successfully! 🎉'**
  String hhJoinSuccess(String name);

  /// No description provided for @hhJoinTitle.
  ///
  /// In en, this message translates to:
  /// **'Join Household'**
  String get hhJoinTitle;

  /// No description provided for @hhJoinDesc.
  ///
  /// In en, this message translates to:
  /// **'Ask your roommate for the 6-character room code to join and split expenses.'**
  String get hhJoinDesc;

  /// No description provided for @hhCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'6-Character Invite Code'**
  String get hhCodeLabel;

  /// No description provided for @hhCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. X7K92P'**
  String get hhCodeHint;

  /// No description provided for @hhCodeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter the invite code'**
  String get hhCodeEmpty;

  /// No description provided for @hhCodeLength.
  ///
  /// In en, this message translates to:
  /// **'Invite code must be exactly 6 characters'**
  String get hhCodeLength;

  /// No description provided for @hhReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your household is ready 🎉'**
  String get hhReadyTitle;

  /// No description provided for @hhInviteCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'INVITE CODE'**
  String get hhInviteCodeLabel;

  /// No description provided for @hhShareCodeDesc.
  ///
  /// In en, this message translates to:
  /// **'Share this 6-character code with your roommates so they can join your room.'**
  String get hhShareCodeDesc;

  /// No description provided for @hhCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Invite code copied to clipboard!'**
  String get hhCodeCopied;

  /// No description provided for @hhCopyBtn.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get hhCopyBtn;

  /// No description provided for @hhShareBtn.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get hhShareBtn;

  /// No description provided for @hhShareText.
  ///
  /// In en, this message translates to:
  /// **'Hey! I created a room for us on Kharcha Paani: \"{name}\".\n\nJoin using my invite code: *{code}*\n\nDownload the app to split our expenses easily!'**
  String hhShareText(String name, String code);

  /// No description provided for @hhGoToHouseholdBtn.
  ///
  /// In en, this message translates to:
  /// **'Go to Household'**
  String get hhGoToHouseholdBtn;

  /// No description provided for @hhMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'Roommates & Members'**
  String get hhMembersTitle;

  /// No description provided for @hhCopyInviteCodeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy Invite Code'**
  String get hhCopyInviteCodeTooltip;

  /// No description provided for @hhInviteCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Invite code #{code} copied!'**
  String hhInviteCodeCopied(String code);

  /// No description provided for @hhHouseholdInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Household Invite Code'**
  String get hhHouseholdInviteCode;

  /// No description provided for @hhInviteCodeCopiedShort.
  ///
  /// In en, this message translates to:
  /// **'Invite code copied!'**
  String get hhInviteCodeCopiedShort;

  /// No description provided for @hhMembersCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Members ({count})'**
  String hhMembersCountLabel(int count);

  /// No description provided for @hhYouBadge.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get hhYouBadge;

  /// No description provided for @hhJoinedDate.
  ///
  /// In en, this message translates to:
  /// **'Joined {date}'**
  String hhJoinedDate(String date);

  /// No description provided for @hhOwnerRole.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get hhOwnerRole;

  /// No description provided for @hhMemberRole.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get hhMemberRole;

  /// No description provided for @hhError.
  ///
  /// In en, this message translates to:
  /// **'Error: {err}'**
  String hhError(String err);

  /// No description provided for @hhDashboardHouseholdTitle.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get hhDashboardHouseholdTitle;

  /// No description provided for @hhDashboardHouseholdNotFound.
  ///
  /// In en, this message translates to:
  /// **'Household not found.'**
  String get hhDashboardHouseholdNotFound;

  /// No description provided for @hhDashboardTab.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get hhDashboardTab;

  /// No description provided for @hhDashboardExpensesTab.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get hhDashboardExpensesTab;

  /// No description provided for @hhDashboardBalancesTab.
  ///
  /// In en, this message translates to:
  /// **'Balances'**
  String get hhDashboardBalancesTab;

  /// No description provided for @hhDashboardAnalyticsTab.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get hhDashboardAnalyticsTab;

  /// No description provided for @hhDashboardAllGroups.
  ///
  /// In en, this message translates to:
  /// **'All Groups'**
  String get hhDashboardAllGroups;

  /// No description provided for @hhDashboardViewMembers.
  ///
  /// In en, this message translates to:
  /// **'View Members'**
  String get hhDashboardViewMembers;

  /// No description provided for @hhDashboardGroupOptions.
  ///
  /// In en, this message translates to:
  /// **'Group Options'**
  String get hhDashboardGroupOptions;

  /// No description provided for @hhDashboardSwitchGroup.
  ///
  /// In en, this message translates to:
  /// **'Switch Group'**
  String get hhDashboardSwitchGroup;

  /// No description provided for @hhDashboardInviteFriends.
  ///
  /// In en, this message translates to:
  /// **'Invite Friends'**
  String get hhDashboardInviteFriends;

  /// No description provided for @hhDashboardLeaveGroup.
  ///
  /// In en, this message translates to:
  /// **'Leave Group'**
  String get hhDashboardLeaveGroup;

  /// No description provided for @hhDashboardDeleteGroup.
  ///
  /// In en, this message translates to:
  /// **'Delete Group'**
  String get hhDashboardDeleteGroup;

  /// No description provided for @hhLeaveGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave Group?'**
  String get hhLeaveGroupTitle;

  /// No description provided for @hhLeaveGroupDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave \"{name}\"? You will no longer have access to this group\'s expenses and balances.'**
  String hhLeaveGroupDesc(String name);

  /// No description provided for @hhCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get hhCancel;

  /// No description provided for @hhLeaveBtn.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get hhLeaveBtn;

  /// No description provided for @hhDeleteGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Group?'**
  String get hhDeleteGroupTitle;

  /// No description provided for @hhDeleteGroupDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This group will be archived and hidden for all members.'**
  String hhDeleteGroupDesc(String name);

  /// No description provided for @hhDeleteBtn.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get hhDeleteBtn;

  /// No description provided for @hhAddExpenseBtn.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get hhAddExpenseBtn;

  /// No description provided for @expAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get expAddTitle;

  /// No description provided for @expEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Expense'**
  String get expEditTitle;

  /// No description provided for @expNoParticipantsError.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one roommate to split with.'**
  String get expNoParticipantsError;

  /// No description provided for @expAllocMismatchExact.
  ///
  /// In en, this message translates to:
  /// **'Allocated amount must exactly match total amount.'**
  String get expAllocMismatchExact;

  /// No description provided for @expAllocMismatchPercent.
  ///
  /// In en, this message translates to:
  /// **'Allocated percentage must equal 100%.'**
  String get expAllocMismatchPercent;

  /// No description provided for @expAllocMismatchShares.
  ///
  /// In en, this message translates to:
  /// **'At least one share must be allocated.'**
  String get expAllocMismatchShares;

  /// No description provided for @expUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Expense updated successfully!'**
  String get expUpdatedSuccess;

  /// No description provided for @expAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Expense added successfully! 🎉'**
  String get expAddedSuccess;

  /// No description provided for @expAmountEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get expAmountEmpty;

  /// No description provided for @expAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Amount must be > 0'**
  String get expAmountInvalid;

  /// No description provided for @expTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Expense Title'**
  String get expTitleLabel;

  /// No description provided for @expTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Grocery, Electricity, Wi-Fi'**
  String get expTitleHint;

  /// No description provided for @expTitleEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get expTitleEmpty;

  /// No description provided for @expCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get expCategoryLabel;

  /// No description provided for @expPaidByLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid by'**
  String get expPaidByLabel;

  /// No description provided for @expDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get expDateLabel;

  /// No description provided for @expNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get expNotesLabel;

  /// No description provided for @expNotesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Bought from Supermarket, Bill #48'**
  String get expNotesHint;

  /// No description provided for @expSaveBtn.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get expSaveBtn;

  /// No description provided for @expYouSuffix.
  ///
  /// In en, this message translates to:
  /// **'(You)'**
  String get expYouSuffix;

  /// No description provided for @expSplitEqual.
  ///
  /// In en, this message translates to:
  /// **'Equal Split'**
  String get expSplitEqual;

  /// No description provided for @expSplitExact.
  ///
  /// In en, this message translates to:
  /// **'Exact Amount'**
  String get expSplitExact;

  /// No description provided for @expSplitShares.
  ///
  /// In en, this message translates to:
  /// **'Shares'**
  String get expSplitShares;

  /// No description provided for @expSplitBetween.
  ///
  /// In en, this message translates to:
  /// **'Split between ({selected}/{total})'**
  String expSplitBetween(int selected, int total);

  /// No description provided for @expSelectOnlyMe.
  ///
  /// In en, this message translates to:
  /// **'Select only me'**
  String get expSelectOnlyMe;

  /// No description provided for @expSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get expSelectAll;

  /// No description provided for @expAllocFully.
  ///
  /// In en, this message translates to:
  /// **'Fully allocated! (Total: ₹{amount})'**
  String expAllocFully(String amount);

  /// No description provided for @expAllocRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining: ₹{amount}'**
  String expAllocRemaining(String amount);

  /// No description provided for @expAllocOver.
  ///
  /// In en, this message translates to:
  /// **'Over-allocated by ₹{amount}'**
  String expAllocOver(String amount);

  /// No description provided for @expAllocShares.
  ///
  /// In en, this message translates to:
  /// **'Total Shares: {amount}'**
  String expAllocShares(int amount);

  /// No description provided for @expDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Expense?'**
  String get expDeleteTitle;

  /// No description provided for @expDeleteDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\" of {amount}? This will recalculate all balances.'**
  String expDeleteDesc(String title, String amount);

  /// No description provided for @expDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Expense deleted successfully'**
  String get expDeletedSuccess;

  /// No description provided for @expDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Expense Details'**
  String get expDetailTitle;

  /// No description provided for @expNotFound.
  ///
  /// In en, this message translates to:
  /// **'Expense not found'**
  String get expNotFound;

  /// No description provided for @expRoommate.
  ///
  /// In en, this message translates to:
  /// **'Roommate'**
  String get expRoommate;

  /// No description provided for @expEditTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get expEditTooltip;

  /// No description provided for @expDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get expDeleteTooltip;

  /// No description provided for @expYouWithName.
  ///
  /// In en, this message translates to:
  /// **'You ({name})'**
  String expYouWithName(String name);

  /// No description provided for @expNotesHeader.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get expNotesHeader;

  /// No description provided for @expSplitBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Split Breakdown'**
  String get expSplitBreakdown;

  /// No description provided for @expSplitSuffix.
  ///
  /// In en, this message translates to:
  /// **'SPLIT'**
  String get expSplitSuffix;

  /// No description provided for @expSharesSuffix.
  ///
  /// In en, this message translates to:
  /// **'shares'**
  String get expSharesSuffix;

  /// No description provided for @expExactSuffix.
  ///
  /// In en, this message translates to:
  /// **'Exact'**
  String get expExactSuffix;

  /// No description provided for @expHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Expense History'**
  String get expHistoryTitle;

  /// No description provided for @expSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by title or notes...'**
  String get expSearchHint;

  /// No description provided for @expCatFilter.
  ///
  /// In en, this message translates to:
  /// **'Cat: {category}'**
  String expCatFilter(String category);

  /// No description provided for @expMemberFilter.
  ///
  /// In en, this message translates to:
  /// **'Member: {name}'**
  String expMemberFilter(String name);

  /// No description provided for @expSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get expSelected;

  /// No description provided for @expDateFiltered.
  ///
  /// In en, this message translates to:
  /// **'Date filtered'**
  String get expDateFiltered;

  /// No description provided for @expNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No matching expenses found'**
  String get expNoMatch;

  /// No description provided for @expAdjustFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get expAdjustFilters;

  /// No description provided for @expNoExpensesYet.
  ///
  /// In en, this message translates to:
  /// **'No expenses recorded yet'**
  String get expNoExpensesYet;

  /// No description provided for @expTapToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first shared expense'**
  String get expTapToAdd;

  /// No description provided for @expTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total {amount}'**
  String expTotalAmount(String amount);

  /// No description provided for @hhYouAreOwed.
  ///
  /// In en, this message translates to:
  /// **'You are owed'**
  String get hhYouAreOwed;

  /// No description provided for @hhYouOwe.
  ///
  /// In en, this message translates to:
  /// **'You owe'**
  String get hhYouOwe;

  /// No description provided for @hhYouAreSettledUp.
  ///
  /// In en, this message translates to:
  /// **'You are settled up'**
  String get hhYouAreSettledUp;

  /// No description provided for @hhTotalGroupSpend.
  ///
  /// In en, this message translates to:
  /// **'Total group spend'**
  String get hhTotalGroupSpend;

  /// No description provided for @hhAllSettledUp.
  ///
  /// In en, this message translates to:
  /// **'All settled up! 🎉'**
  String get hhAllSettledUp;

  /// No description provided for @hhYouPaid.
  ///
  /// In en, this message translates to:
  /// **'You paid'**
  String get hhYouPaid;

  /// No description provided for @hhYourShare.
  ///
  /// In en, this message translates to:
  /// **'Your share'**
  String get hhYourShare;

  /// No description provided for @hhSettleUp.
  ///
  /// In en, this message translates to:
  /// **'Settle Up'**
  String get hhSettleUp;

  /// No description provided for @hhGroupExpenses.
  ///
  /// In en, this message translates to:
  /// **'Group Expenses'**
  String get hhGroupExpenses;

  /// No description provided for @hhViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get hhViewAll;

  /// No description provided for @hhStartSplitting.
  ///
  /// In en, this message translates to:
  /// **'Start splitting group expenses with your roommates.'**
  String get hhStartSplitting;

  /// No description provided for @hhAddFirstExpense.
  ///
  /// In en, this message translates to:
  /// **'Add First Expense'**
  String get hhAddFirstExpense;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
