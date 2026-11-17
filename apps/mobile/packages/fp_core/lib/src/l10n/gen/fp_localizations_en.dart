// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'fp_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class FpL10nEn extends FpL10n {
  FpL10nEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'FlexiPay';

  @override
  String get appNamePro => 'FlexiPay Pro';

  @override
  String get brandFlexi => 'Flexi';

  @override
  String get brandPay => 'Pay';

  @override
  String get brandPro => 'Pro';

  @override
  String get currency => 'TND';

  @override
  String get back => 'Back';

  @override
  String get continueAction => 'Continue';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Copied';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get seeAll => 'See all';

  @override
  String get loading => 'Loading';

  @override
  String get pinEntered => 'PIN entered';

  @override
  String get pinKeyBiometric => 'Use my fingerprint';

  @override
  String get pinKeyDelete => 'Delete';

  @override
  String get biometricReason => 'Confirm your identity to open FlexiPay';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get creditTypeFood => 'Meals';

  @override
  String get creditTypeClothing => 'Clothing';

  @override
  String get creditTypeFuel => 'Fuel';

  @override
  String get creditTypeGifts => 'Gifts';

  @override
  String get navHome => 'Home';

  @override
  String get navDiscover => 'Discover';

  @override
  String get navPay => 'Pay';

  @override
  String get navHistory => 'History';

  @override
  String get navProfile => 'Profile';

  @override
  String get proNavToday => 'Today';

  @override
  String get proNavBalance => 'Balance';

  @override
  String get proNavCollect => 'Collect';

  @override
  String get proNavPayouts => 'Payouts';

  @override
  String get proNavTeam => 'Team';

  @override
  String get mainNavigation => 'Main navigation';

  @override
  String get stampApproved => 'APPROVED';

  @override
  String get stampRefused => 'DECLINED';

  @override
  String get splashTagline => 'Your benefits, in a single ticket.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboarding1Title => 'All your benefits in one place';

  @override
  String get onboarding1Text =>
      'Meals, Clothing, Fuel, Gifts: one balance for each type, offered by your company.';

  @override
  String get onboarding2Title => 'Pay by showing a ticket';

  @override
  String get onboarding2Text =>
      'The cashier scans your QR or types your code. You confirm with your PIN.';

  @override
  String get onboarding3Title => 'Share with your family';

  @override
  String get onboarding3Text =>
      'Create up to 5 family accounts, with a daily limit and an end date.';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingLogin => 'Log in';

  @override
  String get loginTicketLabel => 'Access ticket';

  @override
  String loginTicketNumber(Object number) {
    return 'No. $number';
  }

  @override
  String get loginTitle => 'Log in';

  @override
  String get loginSubtitle =>
      'Use the email and password you received from your company.';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get loginSubmit => 'Validate my ticket';

  @override
  String get loginWithPin => 'Log in with PIN';

  @override
  String get loginHelp => 'Trouble logging in? Contact your HR.';

  @override
  String get loginError => 'Incorrect email or password.';

  @override
  String get newPasswordTitle => 'New password';

  @override
  String get newPasswordInfo =>
      '**First login.** Choose your own password: the one from your HR will no longer work.';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get ruleLength => 'At least 8 characters';

  @override
  String get ruleUpper => 'One uppercase letter';

  @override
  String get ruleDigit => 'One digit';

  @override
  String get ruleMatch => 'Both passwords match';

  @override
  String get newPasswordSubmit => 'Save and continue';

  @override
  String get createPinStep => 'Step 2 of 2';

  @override
  String get createPinTitle => 'Create your PIN';

  @override
  String get createPinSubtitle => '4 digits to confirm each payment';

  @override
  String get enableBiometric => 'Also enable fingerprint login';

  @override
  String welcomeBack(Object name) {
    return 'Welcome back, $name';
  }

  @override
  String get quickLoginSubtitle => 'Enter your PIN or touch the fingerprint';

  @override
  String get enter => 'Enter';

  @override
  String get useEmail => 'Use email';

  @override
  String get forgotPin => 'Forgot PIN?';

  @override
  String pinWrong(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wrong PIN. $count attempts left.',
      one: 'Wrong PIN. 1 attempt left.',
    );
    return '$_temp0';
  }

  @override
  String get forgotTitle => 'Forgot password';

  @override
  String get forgotHeadline => 'Don\'t panic';

  @override
  String get forgotText =>
      'For your security, only your HR or FlexiPay support can give you a new password.';

  @override
  String get hrBadge => 'HR';

  @override
  String yourHrAt(Object company) {
    return 'Your HR · $company';
  }

  @override
  String get supportTitle => 'FlexiPay support';

  @override
  String get backToLogin => 'Back to login';

  @override
  String get lockedTitle => 'Account locked for a while';

  @override
  String get lockedText => '3 wrong PINs. You can try again in:';

  @override
  String get lockedNext => 'What happens next';

  @override
  String get lockLevel1 => '1st lock: 15 minutes';

  @override
  String get lockLevel2 => '2nd lock: 30 minutes';

  @override
  String get lockLevel3 => '3rd lock: 60 minutes';

  @override
  String get lockLevel4 => 'Then: log in again with email';

  @override
  String get loginWithEmail => 'Log in with email';

  @override
  String get contactSupport => 'Contact support';

  @override
  String get hello => 'Hello,';

  @override
  String notificationsUnread(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Notifications, $count unread',
      one: 'Notifications, 1 unread',
      zero: 'Notifications',
    );
    return '$_temp0';
  }

  @override
  String get availableBalance => 'Available balance';

  @override
  String offeredBy(Object company) {
    return 'Offered by $company';
  }

  @override
  String get familyAction => 'Family';

  @override
  String get myCredits => 'My credits';

  @override
  String outOf(Object amount) {
    return 'of $amount';
  }

  @override
  String get noCreditYet => 'No credit yet';

  @override
  String get thisWeek => 'This week';

  @override
  String statPayments(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'payments',
      one: 'payment',
    );
    return '$_temp0';
  }

  @override
  String statMerchants(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'merchants',
      one: 'merchant',
    );
    return '$_temp0';
  }

  @override
  String statFamilyMembers(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'family members',
      one: 'family member',
    );
    return '$_temp0';
  }

  @override
  String get weekChartLabel => 'Spending per day';

  @override
  String get activity => 'Activity';

  @override
  String creditReceivedFrom(Object company) {
    return 'Credit received · $company';
  }

  @override
  String creditBalanceOf(Object type) {
    return '$type balance';
  }

  @override
  String usedAmount(Object amount) {
    return 'Used: $amount';
  }

  @override
  String receivedAmount(Object amount) {
    return 'Received: $amount';
  }

  @override
  String get statShared => 'shared';

  @override
  String get expiresOn => 'expires on';

  @override
  String get whereToUse => 'Where to use it';

  @override
  String get movements => 'Movements';

  @override
  String sharedWith(Object name) {
    return 'Shared with $name';
  }

  @override
  String payWith(Object type) {
    return 'Pay with $type';
  }

  @override
  String get discoverTitle => 'Discover';

  @override
  String get discoverSubtitle => 'Where to use your credits near you';

  @override
  String get searchMerchant => 'Search for a merchant';

  @override
  String get viewOnMap => 'View on map';

  @override
  String get filterByType => 'Filter by type';

  @override
  String get filterAll => 'All';

  @override
  String merchantCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count merchants',
      one: '1 merchant',
      zero: 'No merchants',
    );
    return '$_temp0';
  }

  @override
  String get sortByDistance => 'Sort: distance';

  @override
  String get openNow => 'Open';

  @override
  String get kindSupermarket => 'Supermarket';

  @override
  String get kindFuelStation => 'Fuel station';

  @override
  String get kindRestaurant => 'Restaurant';

  @override
  String get kindShop => 'Shop';

  @override
  String get payTitle => 'Pay';

  @override
  String get creditTypeLabel => 'Credit type';

  @override
  String get confirmTitle => 'Confirm';

  @override
  String get amountLabel => 'Amount';

  @override
  String get enterPinToPay => 'Enter your PIN to pay';

  @override
  String payAmount(Object amount) {
    return 'Pay $amount';
  }

  @override
  String get seeRefusalExample => 'See a declined example';

  @override
  String get paidAmount => 'Amount paid';

  @override
  String cashierAt(Object name, Object date) {
    return 'Cashier: $name · $date';
  }

  @override
  String get typeLabel => 'Type';

  @override
  String get remaining => 'Remaining';

  @override
  String get reference => 'Reference';

  @override
  String get paidBy => 'Paid by';

  @override
  String get approvedTitle => 'Ticket approved';

  @override
  String approvedText(Object name) {
    return 'Enjoy your meal, $name! The receipt is in your history.';
  }

  @override
  String get done => 'Done';

  @override
  String get shareReceipt => 'Share the receipt';

  @override
  String get receiptLabel => 'Receipt';

  @override
  String get refusedTypeTitle => 'Type not accepted';

  @override
  String refusedTypeMessage(Object merchant, Object type) {
    return '$merchant does not accept $type credit.';
  }

  @override
  String refusedTypeTip(Object types) {
    return 'Here you can pay with $types.';
  }

  @override
  String get refusedFundsTitle => 'Insufficient balance';

  @override
  String refusedFundsMessage(Object amount, Object type) {
    return 'You are missing $amount on your $type credit.';
  }

  @override
  String refusedFundsTip(Object amount) {
    return 'Ask the cashier to collect $amount and pay the rest another way.';
  }

  @override
  String get refusedMerchantTitle => 'Merchant not active yet';

  @override
  String refusedMerchantMessage(Object merchant) {
    return '$merchant has not been validated by FlexiPay yet.';
  }

  @override
  String refusedMerchantTip(Object type) {
    return 'Nothing was charged. Find another merchant that accepts $type.';
  }

  @override
  String get refusedMerchantAction => 'See accepted merchants';

  @override
  String get refusedExpiredTitle => 'Request expired';

  @override
  String get refusedExpiredMessage => 'The till\'s request is no longer valid.';

  @override
  String get refusedExpiredTip =>
      'A request stays valid for 2 minutes. Ask the cashier to send it again.';

  @override
  String get merchantLabel => 'Merchant';

  @override
  String get requestedAmount => 'Amount requested';

  @override
  String get yourBalance => 'Your balance';

  @override
  String get backHome => 'Back to home';

  @override
  String get detail => 'Details';

  @override
  String listOr(Object first, Object last) {
    return '$first or $last';
  }

  @override
  String get historyTitle => 'History';

  @override
  String get monthFilter => 'Month';

  @override
  String spentIn(Object month) {
    return 'Spent in $month';
  }

  @override
  String get monthSummary => 'Month summary';

  @override
  String get statReceivedTnd => 'TND received';

  @override
  String get statSharedTnd => 'TND shared';

  @override
  String get receiptTitle => 'Receipt';

  @override
  String get share => 'Share';

  @override
  String get receiptDetailed => 'Detailed receipt';

  @override
  String get dateLabel => 'Date';

  @override
  String get cashierLabel => 'Cashier';

  @override
  String get balanceBefore => 'Balance before';

  @override
  String get balanceAfter => 'Balance after';

  @override
  String get reportProblem => 'Report a problem with this payment';

  @override
  String get familyTitle => 'My family';

  @override
  String get familyAccounts => 'Family accounts';

  @override
  String familyUsage(Object used, Object max) {
    return '$used of $max';
  }

  @override
  String get addMember => 'Add a member';

  @override
  String familyUntil(Object type, Object date) {
    return '$type · until $date';
  }

  @override
  String get familyInfo =>
      'Shared credit comes out of your balance. You can take it back at any time.';

  @override
  String get firstNameLabel => 'First name';

  @override
  String get phoneOrEmail => 'Phone or email';

  @override
  String get creditTypeToShare => 'Credit type to share';

  @override
  String get amountToShare => 'Amount to share (TND)';

  @override
  String availableAmount(Object amount) {
    return 'Available: $amount';
  }

  @override
  String get dailyCap => 'Daily limit';

  @override
  String get decrease => 'Decrease';

  @override
  String get increase => 'Increase';

  @override
  String get endDate => 'End date';

  @override
  String memberSummary(
    Object name,
    Object cap,
    Object type,
    Object date,
    Object limit,
  ) {
    return '$name will be able to spend **$cap per day** on $type, until **$date**, up to **$limit**.';
  }

  @override
  String createMemberAccount(String elide, Object name) {
    String _temp0 = intl.Intl.selectLogic(elide, {
      'other': 'Create $name\'s account',
    });
    return '$_temp0';
  }

  @override
  String memberCreatedTitle(String elide, Object name) {
    String _temp0 = intl.Intl.selectLogic(elide, {
      'other': '$name\'s account created',
    });
    return '$_temp0';
  }

  @override
  String memberCreatedText(Object name) {
    return 'Give them this password. It will **never be shown again**: $name must change it at first login.';
  }

  @override
  String get passwordNoted => 'I\'ve noted the password';

  @override
  String memberBalance(String elide, Object name) {
    String _temp0 = intl.Intl.selectLogic(elide, {'other': '$name\'s balance'});
    return '$_temp0';
  }

  @override
  String todaySpent(Object spent, Object cap) {
    return 'Today: **$spent / $cap**';
  }

  @override
  String endShort(Object date) {
    return 'Ends: $date';
  }

  @override
  String get reclaimCredit => 'Take back the credit';

  @override
  String reclaimDetail(Object amount) {
    return '$amount return to your balance';
  }

  @override
  String get editCapOrDate => 'Change the limit or the date';

  @override
  String capPerDay(Object cap, Object date) {
    return '$cap / day · $date';
  }

  @override
  String get newPasswordAction => 'New password';

  @override
  String get shownOnce => 'Shown only once';

  @override
  String get disableAccount => 'Disable the account';

  @override
  String disableDetail(Object name) {
    return '$name will no longer be able to pay';
  }

  @override
  String memberSpending(String elide, Object name) {
    String _temp0 = intl.Intl.selectLogic(elide, {
      'other': '$name\'s spending',
    });
    return '$_temp0';
  }

  @override
  String helloName(Object name) {
    return 'Hello, $name';
  }

  @override
  String familyAccountOf(Object name) {
    return '$name\'s family account';
  }

  @override
  String myCreditOf(Object type) {
    return 'My $type credit';
  }

  @override
  String leftToday(Object amount) {
    return '**$amount** left today';
  }

  @override
  String untilDate(Object date) {
    return 'Until $date';
  }

  @override
  String get dailyCapTitle => 'Today\'s limit';

  @override
  String capResets(Object cap) {
    return 'The limit resets to $cap every day at midnight.';
  }

  @override
  String get myPayments => 'My payments';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get notifPaymentApproved => 'Payment approved';

  @override
  String notifPaymentApprovedBody(Object amount, Object merchant, Object type) {
    return '$amount at $merchant ($type).';
  }

  @override
  String notifFamilyPaid(Object name) {
    return '$name paid';
  }

  @override
  String notifFamilyPaidBody(Object amount, Object merchant, Object left) {
    return '$amount at $merchant. $left left for today.';
  }

  @override
  String notifCreditReceived(Object company) {
    return 'Credit received from $company';
  }

  @override
  String notifCreditReceivedBody(Object amount, Object details) {
    return '$amount: $details.';
  }

  @override
  String get notifNewLogin => 'New login';

  @override
  String get notifNewLoginBody =>
      'Login from a new device. Not you? Contact support.';

  @override
  String listAnd(Object first, Object last) {
    return '$first and $last';
  }

  @override
  String get myProfile => 'My profile';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get language => 'Language';

  @override
  String get langFr => 'Français';

  @override
  String get langAr => 'العربية';

  @override
  String get langEn => 'English';

  @override
  String get accountSecurity => 'Account and security';

  @override
  String get changePin => 'Change my PIN';

  @override
  String get pinDigits => '4 digits';

  @override
  String get biometricLogin => 'Fingerprint login';

  @override
  String get notificationsSetting => 'Notifications';

  @override
  String get needHelp => 'Need help?';

  @override
  String get needHelpSubtitle => 'FAQ and support contact';

  @override
  String get logout => 'Log out';

  @override
  String get helpTitle => 'Help';

  @override
  String get helpHeadline => 'We\'re here to help';

  @override
  String get helpSubtitle => 'Quick answers, or talk to support.';

  @override
  String get faq1Q => 'How do I pay at a merchant?';

  @override
  String get faq1A =>
      'Tap the green Pay button, choose the credit type and show the ticket to the cashier. Then confirm with your PIN.';

  @override
  String get faq2Q => 'Why was my payment declined?';

  @override
  String get faq2A =>
      'The merchant may not accept this credit type, your balance is too low, or the code has expired. The exact reason is shown on screen.';

  @override
  String get faq3Q => 'Who tops up my credit?';

  @override
  String get faq3A =>
      'Your company. You get a notification for each new credit.';

  @override
  String get faq4Q => 'I forgot my PIN';

  @override
  String get faq4A =>
      'Log in with your email and password, then create a new PIN in Profile.';

  @override
  String get writeSupport => 'Write to support';

  @override
  String get yourHr => 'Your HR';

  @override
  String get welcome => 'Welcome,';

  @override
  String get emptyTitle => 'Your plate is still empty';

  @override
  String emptyText(Object company) {
    return 'As soon as $company gives you a credit, it shows up here and you get a notification.';
  }

  @override
  String get enableNotifications => 'Turn on notifications';

  @override
  String get enableNotificationsDetail => 'To know when the credit arrives';

  @override
  String get discoverMerchants => 'Discover merchants';

  @override
  String get discoverMerchantsDetail => 'Where you will be able to pay';

  @override
  String get offlineBanner => 'You are offline';

  @override
  String updatedAt(Object time) {
    return 'Updated at $time';
  }

  @override
  String get lastKnownBalance => 'Last known balance';

  @override
  String get offlineTitle => 'Payment needs the Internet';

  @override
  String get offlineText => 'Check Wi-Fi or mobile data, then try again.';

  @override
  String get retry => 'Try again';

  @override
  String get proMerchantSpace => 'Merchant space';

  @override
  String get proLoginSubtitle =>
      'Owner or cashier: same screen, the app adapts to your role.';

  @override
  String get proLoginHelp =>
      'Lost your password? Ask your owner or FlexiPay support.';

  @override
  String cashRegisterOf(Object name) {
    return '$name\'s till';
  }

  @override
  String get collectTitle => 'Collect';

  @override
  String get scanQr => 'Scan the QR';

  @override
  String get enterCode => 'Enter the code';

  @override
  String get paymentApproved => 'Payment approved';

  @override
  String get customerConfirmed => 'The customer confirmed with their PIN.';

  @override
  String get paymentRefused => 'Payment declined';

  @override
  String refusedFundsPro(Object type, Object amount) {
    return 'Insufficient $type balance: $amount missing. Nothing was charged.';
  }

  @override
  String get customerLabel => 'Customer';

  @override
  String get timeLabel => 'Time';

  @override
  String get newCollection => 'New collection';

  @override
  String get seeDay => 'See the day';

  @override
  String get collectedToday => 'Collected today';

  @override
  String statCollections(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'collections',
      one: 'collection',
    );
    return '$_temp0';
  }

  @override
  String get averageBasket => 'average basket';

  @override
  String get statRefusals => 'declined';

  @override
  String get hourlyChart => 'Collections per hour';

  @override
  String get collections => 'Collections';

  @override
  String get filterByCashier => 'Filter by cashier';

  @override
  String get filterMe => 'Me';

  @override
  String familyTag(Object name) {
    return '$name (family)';
  }

  @override
  String refusedTag(Object name) {
    return '$name · declined';
  }

  @override
  String ownerEmail(Object email) {
    return 'Owner · $email';
  }

  @override
  String get myBalance => 'My balance';

  @override
  String get toPayOut => 'To pay out';

  @override
  String get availableTodayJ0 => 'Available today (D+0)';

  @override
  String get ifRequestNow => 'If you request now';

  @override
  String commissionRate(Object rate) {
    return 'Commission $rate';
  }

  @override
  String vatRate(Object rate) {
    return 'VAT $rate';
  }

  @override
  String get feesInclTax => 'Fees incl. tax';

  @override
  String get withholding => 'Withholding tax';

  @override
  String withholdingNone(Object amount, Object threshold) {
    return '$amount (fees under $threshold)';
  }

  @override
  String get stampDuty => 'Stamp duty';

  @override
  String get transferFee => 'Transfer fee';

  @override
  String get youWillReceive => 'You will receive';

  @override
  String get requestPayout => 'Request payout';

  @override
  String get payoutInfo =>
      'FlexiPay transfers the money to the bank account on file, then sends you the bank reference.';

  @override
  String get transferTracking => 'Transfer tracking';

  @override
  String get payoutsTitle => 'Payouts';

  @override
  String requestRef(Object ref) {
    return 'Request $ref';
  }

  @override
  String netOf(Object amount) {
    return 'Net of $amount collected';
  }

  @override
  String get inProgress => 'In progress';

  @override
  String get stepRequested => 'Requested';

  @override
  String get stepAcceptance => 'Accepted by FlexiPay';

  @override
  String get pending => 'Pending';

  @override
  String get stepPaid => 'Paid + bank reference';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get historySection => 'History';

  @override
  String payoutPaid(Object ref) {
    return '$ref · Paid';
  }

  @override
  String get ownerOnly => 'Owner only';

  @override
  String get myTeam => 'My team';

  @override
  String get youOwner => 'You · Owner';

  @override
  String cashierRole(Object name) {
    return '$name · Cashier';
  }

  @override
  String activeLastAccess(Object time) {
    return 'Active · last access $time';
  }

  @override
  String get cashierActions => 'Cashier actions';

  @override
  String get cashierActionsText =>
      'Edit, disable or generate a new password (shown only once).';

  @override
  String get addCashier => 'Add a cashier';

  @override
  String get newCashier => 'New cashier';

  @override
  String get fullNameLabel => 'First and last name';

  @override
  String get tempPassword => 'Temporary password (shown only once)';

  @override
  String get createCashier => 'Create the cashier';

  @override
  String get catalogTitle => 'Component catalog';

  @override
  String get catalogDemo => 'Demo';

  @override
  String get catalogOffline => 'Simulate network loss';

  @override
  String get payNfcTitle => 'Hold your phone near the FlexiPay sticker';

  @override
  String get payNfcHint =>
      'The amount then appears: you confirm with your PIN.';

  @override
  String get payNfcUnavailable =>
      'NFC is not available on this phone: scan the QR or type the till code.';

  @override
  String get payScanQr => 'Scan the QR';

  @override
  String get payTypeCode => 'Type the till code';

  @override
  String get payScanTitle => 'Scan the QR on the sticker';

  @override
  String get payCodeTitle => 'Till code';

  @override
  String get payCodeHint => '4 digits shown at the till';

  @override
  String get payStickerRead => 'Sticker read';

  @override
  String registerAtCity(Object register, Object city) {
    return '$register · $city';
  }

  @override
  String get refusedPaidTitle => 'Already paid';

  @override
  String get refusedPaidMessage =>
      'Another customer has already paid this request.';

  @override
  String get refusedStickerTitle => 'Invalid sticker';

  @override
  String get refusedStickerMessage =>
      'This sticker is not recognized by FlexiPay.';

  @override
  String get refusedNoPendingTitle => 'No request at the till';

  @override
  String get refusedNoPendingMessage =>
      'Ask the cashier to enter the amount, then try again.';

  @override
  String get refusedFamilyTitle => 'Daily limit reached';

  @override
  String refusedFamilyMessage(Object amount) {
    return 'You have $amount left for today.';
  }

  @override
  String get refusedTryAgain => 'Try again';

  @override
  String get refusedNothingDebited => 'Nothing was charged.';

  @override
  String requestPayment(Object amount) {
    return 'Request $amount';
  }

  @override
  String get waitingCustomer => 'Waiting for the customer…';

  @override
  String get waitingHint =>
      'The customer holds their phone near the sticker, scans the QR or types this code.';

  @override
  String get shortCodeLabel => 'Till code';

  @override
  String get cancelRequest => 'Cancel the request';

  @override
  String get requestExpiredTitle => 'Request expired';

  @override
  String get requestCancelledTitle => 'Request cancelled';

  @override
  String get newRequest => 'New request';

  @override
  String paidByCustomer(Object name) {
    return 'Paid by $name';
  }

  @override
  String refusedForCustomer(Object name) {
    return 'Declined for $name';
  }

  @override
  String get tillRefusalFunds => 'Insufficient balance. Nothing was charged.';

  @override
  String get tillRefusalLimit => 'Daily limit reached. Nothing was charged.';

  @override
  String get tillRefusalOther => 'Payment declined. Nothing was charged.';

  @override
  String get registersTitle => 'My tills';

  @override
  String get registerSticker => 'Pair a sticker';

  @override
  String get stickerApproach => 'Hold the NFC sticker near the phone';

  @override
  String stickerApproachHint(Object register) {
    return 'The link of $register will be written on it.';
  }

  @override
  String stickerWritten(Object register) {
    return 'Sticker paired with $register';
  }

  @override
  String get stickerWriteFailed =>
      'Could not write. Try again with a blank NFC sticker.';

  @override
  String get registerDisabled => 'Disabled';

  @override
  String get myRegister => 'My till';

  @override
  String get catalogNextCustomer => 'Next customer';

  @override
  String get registerStickerPdf => 'Download the sticker (PDF)';
}
