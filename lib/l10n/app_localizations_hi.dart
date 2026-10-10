// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'खर्चा पानी';

  @override
  String get helloWorld => 'नमस्ते दुनिया!';

  @override
  String get authWelcomeBack => 'वापसी पर स्वागत है';

  @override
  String get authLoginSubtitle =>
      'अपने घरेलू खर्चों का प्रबंधन करने के लिए लॉग इन करें';

  @override
  String get authEmailLabel => 'ईमेल पता';

  @override
  String get authEmailHint => 'उदा. rahul@example.com';

  @override
  String get authEmailEmptyError => 'कृपया अपना ईमेल दर्ज करें';

  @override
  String get authEmailInvalidError => 'कृपया एक मान्य ईमेल पता दर्ज करें';

  @override
  String get authPasswordLabel => 'पासवर्ड';

  @override
  String get authPasswordHint => '••••••••';

  @override
  String get authPasswordEmptyError => 'कृपया अपना पासवर्ड दर्ज करें';

  @override
  String get authPasswordLengthError =>
      'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए';

  @override
  String get authForgotPasswordText => 'पासवर्ड भूल गए?';

  @override
  String get authLoginButton => 'लॉग इन';

  @override
  String get authNoAccountText => 'खाता नहीं है?';

  @override
  String get authSignUpButton => 'साइन अप करें';

  @override
  String get profileTitle => 'प्रोफ़ाइल और सेटिंग्स';

  @override
  String get profileEditName => 'नाम संपादित करें';

  @override
  String get profileFullName => 'पूरा नाम';

  @override
  String get profileNameHint => 'अपना नाम दर्ज करें';

  @override
  String get profileNameEmptyError => 'नाम खाली नहीं हो सकता';

  @override
  String get profileCancel => 'रद्द करें';

  @override
  String get profileSave => 'सहेजें';

  @override
  String get profileUpdatedMsg => 'प्रोफ़ाइल सफलतापूर्वक अपडेट हो गई!';

  @override
  String get profileLogoutTitle => 'लॉग आउट करें';

  @override
  String get profileLogoutConfirm =>
      'क्या आप वाकई खर्चा पानी से लॉग आउट करना चाहते हैं?';

  @override
  String get profileAppearance => 'दिखावट';

  @override
  String get profileThemeMode => 'थीम मोड';

  @override
  String get profileThemeSystem => 'सिस्टम';

  @override
  String get profileThemeLight => 'हल्का';

  @override
  String get profileThemeDark => 'गहरा';

  @override
  String get profileLanguage => 'भाषा';

  @override
  String get profileLanguageEn => 'English';

  @override
  String get profileLanguageHi => 'हिन्दी (Hindi)';

  @override
  String get profileAbout => 'के बारे में';

  @override
  String get profileAboutApp => 'खर्चा पानी के बारे में';

  @override
  String get profileAboutSub => 'संस्करण 1.0.0 • रूममेट व्यय साझाकरण';

  @override
  String get profileSecurity => 'सुरक्षा और गणना';

  @override
  String get profileSecuritySub =>
      'पूर्णांक पैसे की सटीकता • शून्य फ़्लोट त्रुटियाँ';

  @override
  String get authRegisterTitle => 'खाता बनाएं';

  @override
  String authRegisterSubtitle(String appName) {
    return '$appName के साथ शुरुआत करें';
  }

  @override
  String get authRegisterDesc =>
      'रूममेट्स के साथ फ्लैट के खर्चों को निष्पक्ष और पारदर्शी रूप से साझा करें।';

  @override
  String get authNameLabel => 'पूरा नाम';

  @override
  String get authNameHint => 'उदा. राहुल शर्मा';

  @override
  String get authNameEmptyError => 'कृपया अपना नाम दर्ज करें';

  @override
  String get authNameLengthError => 'नाम कम से कम 2 अक्षरों का होना चाहिए';

  @override
  String get authPasswordHint2 => 'कम से कम 6 अक्षर';

  @override
  String get authConfirmPasswordLabel => 'पासवर्ड की पुष्टि करें';

  @override
  String get authConfirmPasswordHint => 'पासवर्ड दोहराएं';

  @override
  String get authConfirmPasswordEmptyError =>
      'कृपया अपने पासवर्ड की पुष्टि करें';

  @override
  String get authConfirmPasswordMatchError => 'पासवर्ड मेल नहीं खाते';

  @override
  String get authHasAccountText => 'क्या आपके पास पहले से एक खाता है?';

  @override
  String get authResetTitle => 'पासवर्ड रीसेट करें';

  @override
  String get authCheckEmailTitle => 'अपना ईमेल जांचें';

  @override
  String authCheckEmailDesc(String email) {
    return 'हमने \n$email पर पासवर्ड रीसेट निर्देश भेजे हैं';
  }

  @override
  String get authBackToLogin => 'लॉग इन पर वापस जाएं';

  @override
  String get authForgotTitle => 'क्या आप अपना पासवर्ड भूल गए हैं?';

  @override
  String get authForgotDesc =>
      'अपना पंजीकृत ईमेल दर्ज करें और हम आपको अपना पासवर्ड रीसेट करने के निर्देश भेजेंगे।';

  @override
  String get authSendResetLink => 'रीसेट लिंक भेजें';

  @override
  String get homeGreetingMorning => 'सुप्रभात';

  @override
  String get homeGreetingAfternoon => 'शुभ दोपहर';

  @override
  String get homeGreetingEvening => 'शुभ संध्या';

  @override
  String get homeFriend => 'दोस्त';

  @override
  String get homeTrackSplitExpenses =>
      'अपने सभी समूहों में खर्चों को ट्रैक और साझा करें';

  @override
  String get homeTotalNetStanding => 'कुल शुद्ध शेष';

  @override
  String homeGroupCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count समूह',
      one: '1 समूह',
    );
    return '$_temp0';
  }

  @override
  String homeYouAreOwed(String amount) {
    return 'आपको $amount मिलने हैं';
  }

  @override
  String homeYouOwe(String amount) {
    return 'आपको $amount देने हैं';
  }

  @override
  String get homeSettledUp => 'आपका सारा हिसाब चुकता है!';

  @override
  String get homeTotalToReceive => 'प्राप्त करने योग्य कुल';

  @override
  String get homeTotalYouOwe => 'देय कुल';

  @override
  String get homeCreateGroup => 'समूह बनाएं';

  @override
  String get homeJoinRoom => 'रूम से जुड़ें';

  @override
  String get homeMyGroups => 'मेरे समूह और परिवार';

  @override
  String homeTotalCount(int count) {
    return '$count कुल';
  }

  @override
  String get homeFailedLoad => 'परिवार लोड करने में विफल';

  @override
  String get homeTryAgain => 'पुनः प्रयास करें';

  @override
  String get homeNoHouseholdsTitle => 'अभी कोई परिवार नहीं है';

  @override
  String get homeNoHouseholdsDesc =>
      'परिवार बनाएं या उसमें शामिल हों\nताकि रूममेट्स के साथ साझा खर्चों को ट्रैक करना शुरू किया जा सके।';

  @override
  String get homeCreateHouseholdBtn => 'परिवार बनाएं';

  @override
  String get homeJoinHouseholdBtn => 'परिवार से जुड़ें';

  @override
  String homeMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सदस्य',
      one: '1 सदस्य',
    );
    return '$_temp0';
  }

  @override
  String get homeTotalExpenses => 'कुल खर्च';

  @override
  String homeYouReceive(String amount) {
    return 'आपको मिलेंगे $amount';
  }

  @override
  String get homeSettledUpBadge => 'हिसाब चुकता';

  @override
  String get homeTapDetails => 'विवरण देखने के लिए टैप करें';

  @override
  String get hhCreateTitle => 'समूह / परिवार बनाएं';

  @override
  String get hhCreateDesc =>
      'अपने रूममेट्स, यात्रा साथियों या दोस्तों के लिए आसानी से बिल साझा करने हेतु एक साझा स्थान बनाएं।';

  @override
  String get hhCatHome => 'फ्लैट / घर';

  @override
  String get hhCatTrip => 'यात्रा / छुट्टियां';

  @override
  String get hhCatFriends => 'दोस्त / हैंगआउट';

  @override
  String get hhCatOffice => 'कार्यालय / प्रोजेक्ट';

  @override
  String get hhCatOther => 'अन्य';

  @override
  String get hhHintTrip => 'उदा. गोवा ट्रिप 2026, लद्दाख रोडट्रिप';

  @override
  String get hhHintFriends => 'उदा. वीकेंड डिनर, कॉलेज गैंग';

  @override
  String get hhHintOffice => 'उदा. लंच क्रू, हैकाथॉन टीम';

  @override
  String get hhHintOther => 'उदा. बुक क्लब, जिम बडीज़';

  @override
  String get hhHintHome => 'उदा. फ्लैट 302, ग्रीन विला, रूम 104';

  @override
  String get hhGroupType => 'समूह प्रकार';

  @override
  String get hhNameLabel => 'समूह / परिवार का नाम';

  @override
  String get hhNameEmpty => 'कृपया एक नाम दर्ज करें';

  @override
  String get hhNameShort => 'नाम कम से कम 2 अक्षरों का होना चाहिए';

  @override
  String hhJoinSuccess(String name) {
    return '$name में सफलतापूर्वक शामिल हुए! 🎉';
  }

  @override
  String get hhJoinTitle => 'परिवार से जुड़ें';

  @override
  String get hhJoinDesc =>
      'खर्चों में शामिल होने और साझा करने के लिए अपने रूममेट से 6-अक्षरों का रूम कोड मांगें।';

  @override
  String get hhCodeLabel => '6-अक्षरों का आमंत्रण कोड';

  @override
  String get hhCodeHint => 'उदा. X7K92P';

  @override
  String get hhCodeEmpty => 'कृपया आमंत्रण कोड दर्ज करें';

  @override
  String get hhCodeLength => 'आमंत्रण कोड ठीक 6 अक्षरों का होना चाहिए';

  @override
  String get hhReadyTitle => 'आपका परिवार तैयार है 🎉';

  @override
  String get hhInviteCodeLabel => 'आमंत्रण कोड';

  @override
  String get hhShareCodeDesc =>
      'अपने रूममेट्स के साथ यह 6-अक्षरों का कोड साझा करें ताकि वे आपके रूम से जुड़ सकें।';

  @override
  String get hhCodeCopied => 'आमंत्रण कोड क्लिपबोर्ड पर कॉपी किया गया!';

  @override
  String get hhCopyBtn => 'कॉपी करें';

  @override
  String get hhShareBtn => 'साझा करें';

  @override
  String hhShareText(String name, String code) {
    return 'नमस्ते! मैंने खर्चा पानी पर हमारे लिए एक रूम बनाया है: \"$name\"।\n\nमेरे आमंत्रण कोड का उपयोग करके जुड़ें: *$code*\n\nहमारे खर्चों को आसानी से साझा करने के लिए ऐप डाउनलोड करें!';
  }

  @override
  String get hhGoToHouseholdBtn => 'परिवार पर जाएं';

  @override
  String get hhMembersTitle => 'रूममेट्स और सदस्य';

  @override
  String get hhCopyInviteCodeTooltip => 'आमंत्रण कोड कॉपी करें';

  @override
  String hhInviteCodeCopied(String code) {
    return 'आमंत्रण कोड #$code कॉपी किया गया!';
  }

  @override
  String get hhHouseholdInviteCode => 'परिवार आमंत्रण कोड';

  @override
  String get hhInviteCodeCopiedShort => 'आमंत्रण कोड कॉपी किया गया!';

  @override
  String hhMembersCountLabel(int count) {
    return 'सदस्य ($count)';
  }

  @override
  String get hhYouBadge => 'आप';

  @override
  String hhJoinedDate(String date) {
    return '$date को जुड़े';
  }

  @override
  String get hhOwnerRole => 'मालिक';

  @override
  String get hhMemberRole => 'सदस्य';

  @override
  String hhError(String err) {
    return 'त्रुटि: $err';
  }

  @override
  String get hhDashboardHouseholdTitle => 'परिवार';

  @override
  String get hhDashboardHouseholdNotFound => 'परिवार नहीं मिला।';

  @override
  String get hhDashboardTab => 'डैशबोर्ड';

  @override
  String get hhDashboardExpensesTab => 'खर्च';

  @override
  String get hhDashboardBalancesTab => 'शेष';

  @override
  String get hhDashboardAnalyticsTab => 'एनालिटिक्स';

  @override
  String get hhDashboardAllGroups => 'सभी समूह';

  @override
  String get hhDashboardViewMembers => 'सदस्य देखें';

  @override
  String get hhDashboardGroupOptions => 'समूह विकल्प';

  @override
  String get hhDashboardSwitchGroup => 'समूह बदलें';

  @override
  String get hhDashboardInviteFriends => 'दोस्तों को आमंत्रित करें';

  @override
  String get hhDashboardLeaveGroup => 'समूह छोड़ें';

  @override
  String get hhDashboardDeleteGroup => 'समूह हटाएं';

  @override
  String get hhLeaveGroupTitle => 'समूह छोड़ें?';

  @override
  String hhLeaveGroupDesc(String name) {
    return 'क्या आप वाकई \"$name\" छोड़ना चाहते हैं? इसके बाद आपके पास इस समूह के खर्चों और शेष राशि तक पहुंच नहीं होगी।';
  }

  @override
  String get hhCancel => 'रद्द करें';

  @override
  String get hhLeaveBtn => 'छोड़ें';

  @override
  String get hhDeleteGroupTitle => 'समूह हटाएं?';

  @override
  String hhDeleteGroupDesc(String name) {
    return 'क्या आप वाकई \"$name\" हटाना चाहते हैं? यह समूह संग्रहीत किया जाएगा और सभी सदस्यों के लिए छिपा दिया जाएगा।';
  }

  @override
  String get hhDeleteBtn => 'हटाएं';

  @override
  String get hhAddExpenseBtn => 'खर्च जोड़ें';

  @override
  String get expAddTitle => 'खर्च जोड़ें';

  @override
  String get expEditTitle => 'खर्च संपादित करें';

  @override
  String get expNoParticipantsError =>
      'कृपया साझा करने के लिए कम से कम एक रूममेट चुनें।';

  @override
  String get expAllocMismatchExact => 'आवंटित राशि कुल राशि से मेल खानी चाहिए।';

  @override
  String get expAllocMismatchPercent =>
      'आवंटित प्रतिशत 100% के बराबर होना चाहिए।';

  @override
  String get expAllocMismatchShares =>
      'कम से कम एक शेयर आवंटित किया जाना चाहिए।';

  @override
  String get expUpdatedSuccess => 'खर्च सफलतापूर्वक अपडेट किया गया!';

  @override
  String get expAddedSuccess => 'खर्च सफलतापूर्वक जोड़ा गया! 🎉';

  @override
  String get expAmountEmpty => 'राशि दर्ज करें';

  @override
  String get expAmountInvalid => 'राशि > 0 होनी चाहिए';

  @override
  String get expTitleLabel => 'खर्च का शीर्षक';

  @override
  String get expTitleHint => 'उदा. किराना, बिजली, वाई-फाई';

  @override
  String get expTitleEmpty => 'कृपया शीर्षक दर्ज करें';

  @override
  String get expCategoryLabel => 'श्रेणी';

  @override
  String get expPaidByLabel => 'द्वारा भुगतान';

  @override
  String get expDateLabel => 'तारीख';

  @override
  String get expNotesLabel => 'नोट्स (वैकल्पिक)';

  @override
  String get expNotesHint => 'उदा. सुपरमार्केट से खरीदा, बिल #48';

  @override
  String get expSaveBtn => 'परिवर्तन सहेजें';

  @override
  String get expYouSuffix => '(आप)';

  @override
  String get expSplitEqual => 'बराबर बांटें';

  @override
  String get expSplitExact => 'सटीक राशि';

  @override
  String get expSplitShares => 'हिस्से';

  @override
  String expSplitBetween(int selected, int total) {
    return 'इनके बीच बांटें ($selected/$total)';
  }

  @override
  String get expSelectOnlyMe => 'केवल मुझे चुनें';

  @override
  String get expSelectAll => 'सभी चुनें';

  @override
  String expAllocFully(String amount) {
    return 'पूरी तरह आवंटित! (कुल: ₹$amount)';
  }

  @override
  String expAllocRemaining(String amount) {
    return 'बचे हुए: ₹$amount';
  }

  @override
  String expAllocOver(String amount) {
    return '₹$amount से अधिक आवंटित';
  }

  @override
  String expAllocShares(int amount) {
    return 'कुल हिस्से: $amount';
  }

  @override
  String get expDeleteTitle => 'खर्च हटाएं?';

  @override
  String expDeleteDesc(String title, String amount) {
    return 'क्या आप वाकई $amount का \"$title\" हटाना चाहते हैं? यह सभी शेष राशि की पुनर्गणना करेगा।';
  }

  @override
  String get expDeletedSuccess => 'खर्च सफलतापूर्वक हटा दिया गया';

  @override
  String get expDetailTitle => 'खर्च का विवरण';

  @override
  String get expNotFound => 'खर्च नहीं मिला';

  @override
  String get expRoommate => 'रूममेट';

  @override
  String get expEditTooltip => 'संपादित करें';

  @override
  String get expDeleteTooltip => 'हटाएं';

  @override
  String expYouWithName(String name) {
    return 'आप ($name)';
  }

  @override
  String get expNotesHeader => 'नोट्स';

  @override
  String get expSplitBreakdown => 'विभाजन विवरण';

  @override
  String get expSplitSuffix => 'विभाजन';

  @override
  String get expSharesSuffix => 'हिस्से';

  @override
  String get expExactSuffix => 'सटीक';

  @override
  String get expHistoryTitle => 'खर्च का इतिहास';

  @override
  String get expSearchHint => 'शीर्षक या नोट्स से खोजें...';

  @override
  String expCatFilter(String category) {
    return 'श्रेणी: $category';
  }

  @override
  String expMemberFilter(String name) {
    return 'सदस्य: $name';
  }

  @override
  String get expSelected => 'चयनित';

  @override
  String get expDateFiltered => 'तारीख फ़िल्टर की गई';

  @override
  String get expNoMatch => 'कोई मिलान वाला खर्च नहीं मिला';

  @override
  String get expAdjustFilters => 'अपने फ़िल्टर समायोजित करने का प्रयास करें';

  @override
  String get expNoExpensesYet => 'अभी तक कोई खर्च दर्ज नहीं है';

  @override
  String get expTapToAdd => 'अपना पहला साझा खर्च जोड़ने के लिए + पर टैप करें';

  @override
  String expTotalAmount(String amount) {
    return 'कुल $amount';
  }

  @override
  String get hhYouAreOwed => 'आपको पैसे मिलने हैं';

  @override
  String get hhYouOwe => 'आपको पैसे देने हैं';

  @override
  String get hhYouAreSettledUp => 'आपका हिसाब चुकता है';

  @override
  String get hhTotalGroupSpend => 'कुल समूह खर्च';

  @override
  String get hhAllSettledUp => 'सब चुकता हो गया! 🎉';

  @override
  String get hhYouPaid => 'आपने भुगतान किया';

  @override
  String get hhYourShare => 'आपका हिस्सा';

  @override
  String get hhSettleUp => 'हिसाब करें';

  @override
  String get hhGroupExpenses => 'समूह खर्च';

  @override
  String get hhViewAll => 'सभी देखें';

  @override
  String get hhStartSplitting =>
      'अपने रूममेट्स के साथ समूह खर्च बांटना शुरू करें।';

  @override
  String get hhAddFirstExpense => 'पहला खर्च जोड़ें';
}
