// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'fp_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class FpL10nAr extends FpL10n {
  FpL10nAr([String locale = 'ar']) : super(locale);

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
  String get currency => 'د.ت';

  @override
  String get back => 'رجوع';

  @override
  String get continueAction => 'متابعة';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get copy => 'نسخ';

  @override
  String get copied => 'تم النسخ';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get loading => 'جارٍ التحميل';

  @override
  String get pinEntered => 'الرمز السري المُدخل';

  @override
  String get pinKeyBiometric => 'استعمال بصمتي';

  @override
  String get pinKeyDelete => 'مسح';

  @override
  String get biometricReason => 'أكّد هويتك لفتح FlexiPay';

  @override
  String get genericError => 'حدث خطأ. أعد المحاولة.';

  @override
  String get creditTypeFood => 'إطعام';

  @override
  String get creditTypeClothing => 'ملابس';

  @override
  String get creditTypeFuel => 'محروقات';

  @override
  String get creditTypeGifts => 'هدايا';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navDiscover => 'اكتشف';

  @override
  String get navPay => 'ادفع';

  @override
  String get navHistory => 'السجل';

  @override
  String get navProfile => 'حسابي';

  @override
  String get proNavToday => 'اليوم';

  @override
  String get proNavBalance => 'الرصيد';

  @override
  String get proNavCollect => 'تحصيل';

  @override
  String get proNavPayouts => 'التحويلات';

  @override
  String get proNavTeam => 'الفريق';

  @override
  String get mainNavigation => 'التنقل الرئيسي';

  @override
  String get stampApproved => 'مقبول';

  @override
  String get stampRefused => 'مرفوض';

  @override
  String get splashTagline => 'امتيازاتك في تذكرة واحدة.';

  @override
  String get onboardingSkip => 'تخطٍّ';

  @override
  String get onboarding1Title => 'كل امتيازاتك في مكان واحد';

  @override
  String get onboarding1Text =>
      'إطعام، ملابس، محروقات، هدايا: رصيد لكل نوع، تقدّمه لك مؤسستك.';

  @override
  String get onboarding2Title => 'ادفع بإظهار تذكرة';

  @override
  String get onboarding2Text =>
      'يمسح أمين الصندوق رمز QR أو يُدخل رمزك. وتؤكّد برمزك السري.';

  @override
  String get onboarding3Title => 'شارك مع عائلتك';

  @override
  String get onboarding3Text =>
      'أنشئ حتى 5 حسابات عائلية، بسقف يومي وتاريخ انتهاء.';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingLogin => 'تسجيل الدخول';

  @override
  String get loginTicketLabel => 'تذكرة الدخول';

  @override
  String loginTicketNumber(Object number) {
    return 'رقم $number';
  }

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginSubtitle =>
      'استعمل البريد الإلكتروني وكلمة المرور اللذين وصلاك من مؤسستك.';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get loginSubmit => 'تأكيد تذكرتي';

  @override
  String get loginWithPin => 'الدخول بالرمز السري';

  @override
  String get loginHelp => 'مشكلة في الدخول؟ اتصل بالموارد البشرية.';

  @override
  String get loginError => 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get newPasswordTitle => 'كلمة مرور جديدة';

  @override
  String get newPasswordInfo =>
      '**أول دخول.** اختر كلمة مرورك الخاصة: الكلمة التي وصلتك من الموارد البشرية لن تعمل بعد الآن.';

  @override
  String get newPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get ruleLength => '8 أحرف على الأقل';

  @override
  String get ruleUpper => 'حرف كبير واحد';

  @override
  String get ruleDigit => 'رقم واحد';

  @override
  String get ruleMatch => 'كلمتا المرور متطابقتان';

  @override
  String get newPasswordSubmit => 'حفظ ومتابعة';

  @override
  String get createPinStep => 'الخطوة 2 من 2';

  @override
  String get createPinTitle => 'أنشئ رمزك السري';

  @override
  String get createPinSubtitle => '4 أرقام لتأكيد كل عملية دفع';

  @override
  String get enableBiometric => 'تفعيل الدخول بالبصمة أيضًا';

  @override
  String welcomeBack(Object name) {
    return 'مرحبًا بعودتك، $name';
  }

  @override
  String get quickLoginSubtitle => 'أدخل رمزك السري أو المس البصمة';

  @override
  String get enter => 'دخول';

  @override
  String get useEmail => 'استعمال البريد الإلكتروني';

  @override
  String get forgotPin => 'نسيت الرمز السري؟';

  @override
  String pinWrong(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'رمز سري خاطئ. بقيت $count محاولات.',
      two: 'رمز سري خاطئ. بقيت محاولتان.',
      one: 'رمز سري خاطئ. بقيت محاولة واحدة.',
    );
    return '$_temp0';
  }

  @override
  String get forgotTitle => 'نسيت كلمة المرور';

  @override
  String get forgotHeadline => 'لا داعي للقلق';

  @override
  String get forgotText =>
      'حفاظًا على أمانك، وحدها الموارد البشرية أو دعم FlexiPay يمكنها منحك كلمة مرور جديدة.';

  @override
  String get hrBadge => 'م.ب';

  @override
  String yourHrAt(Object company) {
    return 'الموارد البشرية · $company';
  }

  @override
  String get supportTitle => 'دعم FlexiPay';

  @override
  String get backToLogin => 'العودة إلى تسجيل الدخول';

  @override
  String get lockedTitle => 'الحساب مقفل مؤقتًا';

  @override
  String get lockedText => '3 رموز سرية خاطئة. يمكنك المحاولة مجددًا بعد:';

  @override
  String get lockedNext => 'ماذا يحدث بعد ذلك';

  @override
  String get lockLevel1 => 'القفل الأول: 15 دقيقة';

  @override
  String get lockLevel2 => 'القفل الثاني: 30 دقيقة';

  @override
  String get lockLevel3 => 'القفل الثالث: 60 دقيقة';

  @override
  String get lockLevel4 => 'بعد ذلك: إعادة الدخول بالبريد الإلكتروني';

  @override
  String get loginWithEmail => 'الدخول بالبريد الإلكتروني';

  @override
  String get contactSupport => 'الاتصال بالدعم';

  @override
  String get hello => 'مرحبا،';

  @override
  String notificationsUnread(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'الإشعارات، $count غير مقروءة',
      one: 'الإشعارات، 1 غير مقروء',
      zero: 'الإشعارات',
    );
    return '$_temp0';
  }

  @override
  String get availableBalance => 'الرصيد المتاح';

  @override
  String offeredBy(Object company) {
    return 'مقدَّم من $company';
  }

  @override
  String get familyAction => 'العائلة';

  @override
  String get myCredits => 'أرصدتي';

  @override
  String outOf(Object amount) {
    return 'من $amount';
  }

  @override
  String get noCreditYet => 'لا يوجد رصيد بعد';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String statPayments(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عمليات دفع',
      one: 'عملية دفع',
    );
    return '$_temp0';
  }

  @override
  String statMerchants(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'محلات',
      one: 'محل',
    );
    return '$_temp0';
  }

  @override
  String statFamilyMembers(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أفراد من العائلة',
      one: 'فرد من العائلة',
    );
    return '$_temp0';
  }

  @override
  String get weekChartLabel => 'المصاريف حسب اليوم';

  @override
  String get activity => 'النشاط';

  @override
  String creditReceivedFrom(Object company) {
    return 'رصيد مستلم · $company';
  }

  @override
  String creditBalanceOf(Object type) {
    return 'رصيد $type';
  }

  @override
  String usedAmount(Object amount) {
    return 'المستعمل: $amount';
  }

  @override
  String receivedAmount(Object amount) {
    return 'المستلم: $amount';
  }

  @override
  String get statShared => 'مُشارَك';

  @override
  String get expiresOn => 'ينتهي في';

  @override
  String get whereToUse => 'أين أستعمله';

  @override
  String get movements => 'الحركات';

  @override
  String sharedWith(Object name) {
    return 'مُشارَك مع $name';
  }

  @override
  String payWith(Object type) {
    return 'ادفع بـ$type';
  }

  @override
  String get discoverTitle => 'اكتشف';

  @override
  String get discoverSubtitle => 'أين تستعمل أرصدتك بالقرب منك';

  @override
  String get searchMerchant => 'ابحث عن محل';

  @override
  String get viewOnMap => 'عرض على الخريطة';

  @override
  String get filterByType => 'تصفية حسب النوع';

  @override
  String get filterAll => 'الكل';

  @override
  String merchantCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count محلات',
      two: 'محلان',
      one: 'محل واحد',
      zero: 'لا يوجد محل',
    );
    return '$_temp0';
  }

  @override
  String get sortByDistance => 'الترتيب: المسافة';

  @override
  String get openNow => 'مفتوح';

  @override
  String get kindSupermarket => 'مساحة تجارية';

  @override
  String get kindFuelStation => 'محطة وقود';

  @override
  String get kindRestaurant => 'مطعم';

  @override
  String get kindShop => 'متجر';

  @override
  String get payTitle => 'ادفع';

  @override
  String get creditTypeLabel => 'نوع الرصيد';

  @override
  String get confirmTitle => 'تأكيد';

  @override
  String get amountLabel => 'المبلغ';

  @override
  String get enterPinToPay => 'أدخل رمزك السري للدفع';

  @override
  String payAmount(Object amount) {
    return 'ادفع $amount';
  }

  @override
  String get seeRefusalExample => 'عرض مثال على الرفض';

  @override
  String get paidAmount => 'المبلغ المدفوع';

  @override
  String cashierAt(Object name, Object date) {
    return 'أمين الصندوق: $name · $date';
  }

  @override
  String get typeLabel => 'النوع';

  @override
  String get remaining => 'المتبقي';

  @override
  String get reference => 'المرجع';

  @override
  String get paidBy => 'دفعه';

  @override
  String get approvedTitle => 'تذكرة مقبولة';

  @override
  String approvedText(Object name) {
    return 'شهية طيبة يا $name! الوصل موجود في سجلّك.';
  }

  @override
  String get done => 'تم';

  @override
  String get shareReceipt => 'مشاركة الوصل';

  @override
  String get receiptLabel => 'وصل';

  @override
  String get refusedTypeTitle => 'نوع غير مقبول';

  @override
  String refusedTypeMessage(Object merchant, Object type) {
    return '$merchant لا يقبل رصيد $type.';
  }

  @override
  String refusedTypeTip(Object types) {
    return 'هنا يمكنك الدفع بـ$types.';
  }

  @override
  String get refusedFundsTitle => 'رصيد غير كافٍ';

  @override
  String refusedFundsMessage(Object amount, Object type) {
    return 'ينقصك $amount في رصيد $type.';
  }

  @override
  String refusedFundsTip(Object amount) {
    return 'اطلب من أمين الصندوق تحصيل $amount وادفع الباقي بطريقة أخرى.';
  }

  @override
  String get refusedMerchantTitle => 'محل غير مفعّل بعد';

  @override
  String refusedMerchantMessage(Object merchant) {
    return '$merchant لم يُصادَق عليه بعد من FlexiPay.';
  }

  @override
  String refusedMerchantTip(Object type) {
    return 'لم يُخصم أي مبلغ. ابحث عن محل آخر يقبل $type.';
  }

  @override
  String get refusedMerchantAction => 'عرض المحلات المقبولة';

  @override
  String get refusedExpiredTitle => 'انتهت صلاحية الطلب';

  @override
  String get refusedExpiredMessage => 'طلب الصندوق لم يعد صالحًا.';

  @override
  String get refusedExpiredTip =>
      'يبقى الطلب صالحًا لمدة دقيقتين. اطلب من أمين الصندوق إعادة إرساله.';

  @override
  String get merchantLabel => 'المحل';

  @override
  String get requestedAmount => 'المبلغ المطلوب';

  @override
  String get yourBalance => 'رصيدك';

  @override
  String get backHome => 'العودة إلى الرئيسية';

  @override
  String get detail => 'التفاصيل';

  @override
  String listOr(Object first, Object last) {
    return '$first أو $last';
  }

  @override
  String get historyTitle => 'السجل';

  @override
  String get monthFilter => 'الشهر';

  @override
  String spentIn(Object month) {
    return 'المصاريف في $month';
  }

  @override
  String get monthSummary => 'ملخص الشهر';

  @override
  String get statReceivedTnd => 'د.ت مستلمة';

  @override
  String get statSharedTnd => 'د.ت مُشارَكة';

  @override
  String get receiptTitle => 'الوصل';

  @override
  String get share => 'مشاركة';

  @override
  String get receiptDetailed => 'وصل مفصّل';

  @override
  String get dateLabel => 'التاريخ';

  @override
  String get cashierLabel => 'أمين الصندوق';

  @override
  String get balanceBefore => 'الرصيد قبل';

  @override
  String get balanceAfter => 'الرصيد بعد';

  @override
  String get reportProblem => 'الإبلاغ عن مشكلة في هذه العملية';

  @override
  String get familyTitle => 'عائلتي';

  @override
  String get familyAccounts => 'الحسابات العائلية';

  @override
  String familyUsage(Object used, Object max) {
    return '$used من $max';
  }

  @override
  String get addMember => 'إضافة فرد';

  @override
  String familyUntil(Object type, Object date) {
    return '$type · حتى $date';
  }

  @override
  String get familyInfo =>
      'الرصيد المُشارَك يُخصم من رصيدك. يمكنك استرجاعه في أي وقت.';

  @override
  String get firstNameLabel => 'الاسم';

  @override
  String get phoneOrEmail => 'الهاتف أو البريد الإلكتروني';

  @override
  String get creditTypeToShare => 'نوع الرصيد المُشارَك';

  @override
  String get amountToShare => 'المبلغ المُشارَك (د.ت)';

  @override
  String availableAmount(Object amount) {
    return 'المتاح: $amount';
  }

  @override
  String get dailyCap => 'السقف اليومي';

  @override
  String get decrease => 'إنقاص';

  @override
  String get increase => 'زيادة';

  @override
  String get endDate => 'تاريخ الانتهاء';

  @override
  String memberSummary(
    Object name,
    Object cap,
    Object type,
    Object date,
    Object limit,
  ) {
    return 'سيتمكّن $name من إنفاق **$cap يوميًا** في $type، حتى **$date**، في حدود **$limit**.';
  }

  @override
  String createMemberAccount(String elide, Object name) {
    String _temp0 = intl.Intl.selectLogic(elide, {'other': 'إنشاء حساب $name'});
    return '$_temp0';
  }

  @override
  String memberCreatedTitle(String elide, Object name) {
    String _temp0 = intl.Intl.selectLogic(elide, {
      'other': 'تم إنشاء حساب $name',
    });
    return '$_temp0';
  }

  @override
  String memberCreatedText(Object name) {
    return 'أعطه كلمة المرور هذه. **لن تُعرض مجددًا أبدًا**: على $name تغييرها عند أول دخول.';
  }

  @override
  String get passwordNoted => 'دوّنت كلمة المرور';

  @override
  String memberBalance(String elide, Object name) {
    String _temp0 = intl.Intl.selectLogic(elide, {'other': 'رصيد $name'});
    return '$_temp0';
  }

  @override
  String todaySpent(Object spent, Object cap) {
    return 'اليوم: **$spent / $cap**';
  }

  @override
  String endShort(Object date) {
    return 'النهاية: $date';
  }

  @override
  String get reclaimCredit => 'استرجاع الرصيد';

  @override
  String reclaimDetail(Object amount) {
    return 'يعود $amount إلى رصيدك';
  }

  @override
  String get editCapOrDate => 'تعديل السقف أو التاريخ';

  @override
  String capPerDay(Object cap, Object date) {
    return '$cap / يوم · $date';
  }

  @override
  String get newPasswordAction => 'كلمة مرور جديدة';

  @override
  String get shownOnce => 'تُعرض مرة واحدة فقط';

  @override
  String get disableAccount => 'تعطيل الحساب';

  @override
  String disableDetail(Object name) {
    return 'لن يتمكّن $name من الدفع';
  }

  @override
  String memberSpending(String elide, Object name) {
    String _temp0 = intl.Intl.selectLogic(elide, {'other': 'مصاريف $name'});
    return '$_temp0';
  }

  @override
  String helloName(Object name) {
    return 'مرحبا، $name';
  }

  @override
  String familyAccountOf(Object name) {
    return 'حساب عائلي لـ$name';
  }

  @override
  String myCreditOf(Object type) {
    return 'رصيدي $type';
  }

  @override
  String leftToday(Object amount) {
    return 'يبقى **$amount** اليوم';
  }

  @override
  String untilDate(Object date) {
    return 'حتى $date';
  }

  @override
  String get dailyCapTitle => 'سقف اليوم';

  @override
  String capResets(Object cap) {
    return 'يعود السقف إلى $cap كل يوم عند منتصف الليل.';
  }

  @override
  String get myPayments => 'مدفوعاتي';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get markAllRead => 'قراءة الكل';

  @override
  String get notifPaymentApproved => 'دفع مقبول';

  @override
  String notifPaymentApprovedBody(Object amount, Object merchant, Object type) {
    return '$amount لدى $merchant ($type).';
  }

  @override
  String notifFamilyPaid(Object name) {
    return 'دفع $name';
  }

  @override
  String notifFamilyPaidBody(Object amount, Object merchant, Object left) {
    return '$amount لدى $merchant. يبقى له $left اليوم.';
  }

  @override
  String notifCreditReceived(Object company) {
    return 'رصيد مستلم من $company';
  }

  @override
  String notifCreditReceivedBody(Object amount, Object details) {
    return '$amount: $details.';
  }

  @override
  String get notifNewLogin => 'دخول جديد';

  @override
  String get notifNewLoginBody => 'دخول من جهاز جديد. لست أنت؟ اتصل بالدعم.';

  @override
  String listAnd(Object first, Object last) {
    return '$first و$last';
  }

  @override
  String get myProfile => 'ملفي';

  @override
  String get appearance => 'المظهر';

  @override
  String get theme => 'السمة';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystem => 'النظام';

  @override
  String get language => 'اللغة';

  @override
  String get langFr => 'Français';

  @override
  String get langAr => 'العربية';

  @override
  String get langEn => 'English';

  @override
  String get accountSecurity => 'الحساب والأمان';

  @override
  String get changePin => 'تغيير رمزي السري';

  @override
  String get pinDigits => '4 أرقام';

  @override
  String get biometricLogin => 'الدخول بالبصمة';

  @override
  String get notificationsSetting => 'الإشعارات';

  @override
  String get needHelp => 'تحتاج مساعدة؟';

  @override
  String get needHelpSubtitle => 'الأسئلة الشائعة والاتصال بالدعم';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get helpTitle => 'المساعدة';

  @override
  String get helpHeadline => 'نحن هنا لمساعدتك';

  @override
  String get helpSubtitle => 'أجوبة سريعة، أو تحدّث مع الدعم.';

  @override
  String get faq1Q => 'كيف أدفع لدى تاجر؟';

  @override
  String get faq1A =>
      'المس زر ادفع الأخضر، اختر نوع الرصيد وأظهر التذكرة لأمين الصندوق. ثم أكّد برمزك السري.';

  @override
  String get faq2Q => 'لماذا رُفضت عملية الدفع؟';

  @override
  String get faq2A =>
      'ربما لا يقبل المحل هذا النوع من الرصيد، أو رصيدك منخفض جدًا، أو انتهت صلاحية الرمز. يظهر السبب الدقيق على الشاشة.';

  @override
  String get faq3Q => 'من يشحن رصيدي؟';

  @override
  String get faq3A => 'مؤسستك. تصلك إشعار مع كل رصيد جديد.';

  @override
  String get faq4Q => 'نسيت رمزي السري';

  @override
  String get faq4A =>
      'سجّل الدخول ببريدك الإلكتروني وكلمة المرور، ثم أنشئ رمزًا سريًا جديدًا في حسابي.';

  @override
  String get writeSupport => 'مراسلة الدعم';

  @override
  String get yourHr => 'الموارد البشرية';

  @override
  String get welcome => 'أهلًا،';

  @override
  String get emptyTitle => 'صحنك ما زال فارغًا';

  @override
  String emptyText(Object company) {
    return 'بمجرد أن تمنحك $company رصيدًا، سيظهر هنا وستتلقى إشعارًا.';
  }

  @override
  String get enableNotifications => 'تفعيل الإشعارات';

  @override
  String get enableNotificationsDetail => 'لتعرف متى يصل الرصيد';

  @override
  String get discoverMerchants => 'اكتشف المحلات';

  @override
  String get discoverMerchantsDetail => 'حيث يمكنك الدفع';

  @override
  String get offlineBanner => 'أنت غير متصل';

  @override
  String updatedAt(Object time) {
    return 'آخر تحديث $time';
  }

  @override
  String get lastKnownBalance => 'آخر رصيد معروف';

  @override
  String get offlineTitle => 'الدفع يحتاج إلى الإنترنت';

  @override
  String get offlineText =>
      'تحقّق من الواي فاي أو بيانات الهاتف، ثم أعد المحاولة.';

  @override
  String get retry => 'أعد المحاولة';

  @override
  String get proMerchantSpace => 'فضاء التاجر';

  @override
  String get proLoginSubtitle =>
      'المالك أو أمين الصندوق: الشاشة نفسها، والتطبيق يتكيّف مع دورك.';

  @override
  String get proLoginHelp =>
      'فقدت كلمة المرور؟ اطلبها من المالك أو من دعم FlexiPay.';

  @override
  String cashRegisterOf(Object name) {
    return 'صندوق $name';
  }

  @override
  String get collectTitle => 'تحصيل';

  @override
  String get scanQr => 'مسح رمز QR';

  @override
  String get enterCode => 'إدخال الرمز';

  @override
  String get paymentApproved => 'دفع مقبول';

  @override
  String get customerConfirmed => 'أكّد الحريف برمزه السري.';

  @override
  String get paymentRefused => 'دفع مرفوض';

  @override
  String refusedFundsPro(Object type, Object amount) {
    return 'رصيد $type غير كافٍ: ينقص $amount. لم يُخصم أي شيء.';
  }

  @override
  String get customerLabel => 'الحريف';

  @override
  String get timeLabel => 'الساعة';

  @override
  String get newCollection => 'تحصيل جديد';

  @override
  String get seeDay => 'عرض اليوم';

  @override
  String get collectedToday => 'المحصَّل اليوم';

  @override
  String statCollections(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عمليات تحصيل',
      one: 'عملية تحصيل',
    );
    return '$_temp0';
  }

  @override
  String get averageBasket => 'متوسط السلة';

  @override
  String get statRefusals => 'رفض';

  @override
  String get hourlyChart => 'التحصيل حسب الساعة';

  @override
  String get collections => 'عمليات التحصيل';

  @override
  String get filterByCashier => 'تصفية حسب أمين الصندوق';

  @override
  String get filterMe => 'أنا';

  @override
  String familyTag(Object name) {
    return '$name (عائلة)';
  }

  @override
  String refusedTag(Object name) {
    return '$name · مرفوض';
  }

  @override
  String ownerEmail(Object email) {
    return 'المالك · $email';
  }

  @override
  String get myBalance => 'رصيدي';

  @override
  String get toPayOut => 'للتحويل';

  @override
  String get availableTodayJ0 => 'متاح اليوم (ي+0)';

  @override
  String get ifRequestNow => 'إذا طلبت الآن';

  @override
  String commissionRate(Object rate) {
    return 'عمولة $rate';
  }

  @override
  String vatRate(Object rate) {
    return 'الأداء على القيمة المضافة $rate';
  }

  @override
  String get feesInclTax => 'المصاريف بكل الأداءات';

  @override
  String get withholding => 'الخصم من المورد';

  @override
  String withholdingNone(Object amount, Object threshold) {
    return '$amount (مصاريف أقل من $threshold)';
  }

  @override
  String get stampDuty => 'معلوم الطابع';

  @override
  String get transferFee => 'مصاريف التحويل';

  @override
  String get youWillReceive => 'ستتلقى';

  @override
  String get requestPayout => 'طلب التحويل';

  @override
  String get payoutInfo =>
      'تحوّل FlexiPay المال إلى الحساب البنكي المسجّل في ملفك، ثم ترسل لك المرجع البنكي.';

  @override
  String get transferTracking => 'متابعة التحويلات';

  @override
  String get payoutsTitle => 'التحويلات';

  @override
  String requestRef(Object ref) {
    return 'الطلب $ref';
  }

  @override
  String netOf(Object amount) {
    return 'صافٍ من $amount محصَّلة';
  }

  @override
  String get inProgress => 'قيد المعالجة';

  @override
  String get stepRequested => 'مطلوب';

  @override
  String get stepAcceptance => 'قبول من FlexiPay';

  @override
  String get pending => 'في الانتظار';

  @override
  String get stepPaid => 'مدفوع + المرجع البنكي';

  @override
  String get upcoming => 'قادم';

  @override
  String get historySection => 'السجل';

  @override
  String payoutPaid(Object ref) {
    return '$ref · مدفوع';
  }

  @override
  String get ownerOnly => 'خاص بالمالك';

  @override
  String get myTeam => 'فريقي';

  @override
  String get youOwner => 'أنت · المالك';

  @override
  String cashierRole(Object name) {
    return '$name · أمين صندوق';
  }

  @override
  String activeLastAccess(Object time) {
    return 'نشط · آخر دخول $time';
  }

  @override
  String get cashierActions => 'إجراءات على أمين صندوق';

  @override
  String get cashierActionsText =>
      'تعديل، تعطيل أو إنشاء كلمة مرور جديدة (تُعرض مرة واحدة فقط).';

  @override
  String get addCashier => 'إضافة أمين صندوق';

  @override
  String get newCashier => 'أمين صندوق جديد';

  @override
  String get fullNameLabel => 'الاسم واللقب';

  @override
  String get tempPassword => 'كلمة مرور مؤقتة (تُعرض مرة واحدة فقط)';

  @override
  String get createCashier => 'إنشاء أمين الصندوق';

  @override
  String get catalogTitle => 'دليل المكوّنات';

  @override
  String get catalogDemo => 'عرض توضيحي';

  @override
  String get catalogOffline => 'محاكاة انقطاع الشبكة';

  @override
  String get payNfcTitle => 'قرّب هاتفك من ملصق FlexiPay';

  @override
  String get payNfcHint => 'يظهر المبلغ بعد ذلك: تؤكّد برمزك السري.';

  @override
  String get payNfcUnavailable =>
      'NFC غير متاح على هذا الهاتف: امسح رمز QR أو اكتب رمز الصندوق.';

  @override
  String get payScanQr => 'مسح رمز QR';

  @override
  String get payTypeCode => 'كتابة رمز الصندوق';

  @override
  String get payScanTitle => 'امسح رمز QR على الملصق';

  @override
  String get payCodeTitle => 'رمز الصندوق';

  @override
  String get payCodeHint => '4 أرقام معروضة على الصندوق';

  @override
  String get payStickerRead => 'تمت قراءة الملصق';

  @override
  String registerAtCity(Object register, Object city) {
    return '$register · $city';
  }

  @override
  String get refusedPaidTitle => 'مدفوعة مسبقًا';

  @override
  String get refusedPaidMessage => 'دفع حريف آخر هذا الطلب مسبقًا.';

  @override
  String get refusedStickerTitle => 'ملصق غير صالح';

  @override
  String get refusedStickerMessage => 'هذا الملصق غير معروف لدى FlexiPay.';

  @override
  String get refusedNoPendingTitle => 'لا يوجد طلب على الصندوق';

  @override
  String get refusedNoPendingMessage =>
      'اطلب من أمين الصندوق إدخال المبلغ ثم أعد المحاولة.';

  @override
  String get refusedFamilyTitle => 'تم بلوغ سقف اليوم';

  @override
  String refusedFamilyMessage(Object amount) {
    return 'يبقى لك $amount اليوم.';
  }

  @override
  String get refusedTryAgain => 'أعد المحاولة';

  @override
  String get refusedNothingDebited => 'لم يُخصم أي مبلغ.';

  @override
  String requestPayment(Object amount) {
    return 'طلب $amount';
  }

  @override
  String get waitingCustomer => 'في انتظار الحريف…';

  @override
  String get waitingHint =>
      'يقرّب الحريف هاتفه من الملصق أو يمسح رمز QR أو يكتب هذا الرمز.';

  @override
  String get shortCodeLabel => 'رمز الصندوق';

  @override
  String get cancelRequest => 'إلغاء الطلب';

  @override
  String get requestExpiredTitle => 'انتهت صلاحية الطلب';

  @override
  String get requestCancelledTitle => 'أُلغي الطلب';

  @override
  String get newRequest => 'طلب جديد';

  @override
  String paidByCustomer(Object name) {
    return 'دفعه $name';
  }

  @override
  String refusedForCustomer(Object name) {
    return 'مرفوض لـ$name';
  }

  @override
  String get tillRefusalFunds => 'رصيد غير كافٍ. لم يُخصم أي شيء.';

  @override
  String get tillRefusalLimit => 'تم بلوغ سقف اليوم. لم يُخصم أي شيء.';

  @override
  String get tillRefusalOther => 'تم رفض الدفع. لم يُخصم أي شيء.';

  @override
  String get registersTitle => 'صناديقي';

  @override
  String get registerSticker => 'ربط ملصق';

  @override
  String get stickerApproach => 'قرّب ملصق NFC من الهاتف';

  @override
  String stickerApproachHint(Object register) {
    return 'سيُكتب عليه رابط $register.';
  }

  @override
  String stickerWritten(Object register) {
    return 'تم ربط الملصق بـ$register';
  }

  @override
  String get stickerWriteFailed =>
      'تعذّرت الكتابة. أعد المحاولة بملصق NFC فارغ.';

  @override
  String get registerDisabled => 'معطّل';

  @override
  String get myRegister => 'صندوقي';

  @override
  String get catalogNextCustomer => 'الحريف التالي';

  @override
  String get registerStickerPdf => 'تنزيل الملصق (PDF)';

  @override
  String get mfaCodeTitle => 'رمز التحقق';

  @override
  String get mfaCodeHint => 'أدخل الرمز المكوّن من 6 أرقام من تطبيق المصادقة.';

  @override
  String get mfaCodeInvalid => 'رمز خاطئ أو منتهي الصلاحية. أدخل الرمز الجديد.';

  @override
  String get mfaCodePlaceholder => '000000';

  @override
  String get mfaCodeAction => 'تأكيد';

  @override
  String get cancelAction => 'إلغاء';

  @override
  String get mfaEnrollOnWeb =>
      'فعّل أولاً المصادقة الثنائية من فضاء FlexiPay على الويب، ثم أعد تسجيل الدخول هنا.';

  @override
  String get passwordRefused => 'كلمة المرور هذه غير مقبولة. اختر كلمة أخرى.';

  @override
  String get pinWeak => 'هذا الرمز بسيط جدًا (0000، 1234…). اختر رمزًا آخر.';

  @override
  String get lastNameLabel => 'اللقب';

  @override
  String get relationshipLabel => 'صلة القرابة';

  @override
  String get relationshipSpouse => 'الزوج أو الزوجة';

  @override
  String get relationshipChild => 'الابن أو الابنة';

  @override
  String get relationshipParent => 'الأب أو الأم';

  @override
  String get memberPhoneLabel => 'الهاتف (+216…)';

  @override
  String get creditsExpired => 'رصيد منتهي الصلاحية';

  @override
  String get notifCreditExpiring => 'رصيد سينتهي قريبًا';

  @override
  String notifCreditExpiringBody(String amount, String type) {
    return '$amount من رصيد $type ستنتهي صلاحيتها قريبًا.';
  }

  @override
  String get refusedDeclinedTitle => 'تم رفض الدفع';

  @override
  String get refusedDeclinedMessage =>
      'هذا الدفع غير ممكن بحسابك في الوقت الحالي.';

  @override
  String payoutRejected(String ref) {
    return '$ref · مرفوض';
  }
}
