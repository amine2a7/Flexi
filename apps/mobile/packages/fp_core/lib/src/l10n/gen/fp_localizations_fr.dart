// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'fp_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class FpL10nFr extends FpL10n {
  FpL10nFr([String locale = 'fr']) : super(locale);

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
  String get back => 'Retour';

  @override
  String get continueAction => 'Continuer';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get copy => 'Copier';

  @override
  String get copied => 'Copié';

  @override
  String get today => 'Aujourd’hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get seeAll => 'Tout voir';

  @override
  String get loading => 'Chargement';

  @override
  String get pinEntered => 'Code PIN saisi';

  @override
  String get pinKeyBiometric => 'Utiliser mon empreinte';

  @override
  String get pinKeyDelete => 'Effacer';

  @override
  String get biometricReason => 'Confirmez votre identité pour ouvrir FlexiPay';

  @override
  String get genericError => 'Une erreur est survenue. Réessayez.';

  @override
  String get creditTypeFood => 'Restauration';

  @override
  String get creditTypeClothing => 'Habillement';

  @override
  String get creditTypeFuel => 'Carburant';

  @override
  String get creditTypeGifts => 'Cadeaux';

  @override
  String get navHome => 'Accueil';

  @override
  String get navDiscover => 'Découvrir';

  @override
  String get navPay => 'Payer';

  @override
  String get navHistory => 'Historique';

  @override
  String get navProfile => 'Profil';

  @override
  String get proNavToday => 'Aujourd’hui';

  @override
  String get proNavBalance => 'Solde';

  @override
  String get proNavCollect => 'Encaisser';

  @override
  String get proNavPayouts => 'Reversements';

  @override
  String get proNavTeam => 'Équipe';

  @override
  String get mainNavigation => 'Navigation principale';

  @override
  String get stampApproved => 'APPROUVÉ';

  @override
  String get stampRefused => 'REFUSÉ';

  @override
  String get splashTagline => 'Vos avantages, en un seul ticket.';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboarding1Title => 'Tous vos avantages au même endroit';

  @override
  String get onboarding1Text =>
      'Restauration, Habillement, Carburant, Cadeaux : un solde pour chaque type, offert par votre entreprise.';

  @override
  String get onboarding2Title => 'Payez en montrant un ticket';

  @override
  String get onboarding2Text =>
      'Le caissier scanne votre QR ou saisit votre code. Vous confirmez avec votre PIN.';

  @override
  String get onboarding3Title => 'Partagez avec votre famille';

  @override
  String get onboarding3Text =>
      'Créez jusqu’à 5 comptes famille, avec un plafond par jour et une date de fin.';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingLogin => 'Se connecter';

  @override
  String get loginTicketLabel => 'Ticket d\'accès';

  @override
  String loginTicketNumber(Object number) {
    return 'N° $number';
  }

  @override
  String get loginTitle => 'Connexion';

  @override
  String get loginSubtitle =>
      'Utilisez l’e-mail et le mot de passe reçus de votre entreprise.';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get loginSubmit => 'Valider mon ticket';

  @override
  String get loginWithPin => 'Se connecter avec le PIN';

  @override
  String get loginHelp => 'Problème de connexion ? Contactez votre RH.';

  @override
  String get loginError => 'E-mail ou mot de passe incorrect.';

  @override
  String get newPasswordTitle => 'Nouveau mot de passe';

  @override
  String get newPasswordInfo =>
      '**Première connexion.** Choisissez votre propre mot de passe : celui reçu de votre RH ne marchera plus.';

  @override
  String get newPasswordLabel => 'Nouveau mot de passe';

  @override
  String get confirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get ruleLength => 'Au moins 8 caractères';

  @override
  String get ruleUpper => 'Une majuscule';

  @override
  String get ruleDigit => 'Un chiffre';

  @override
  String get ruleMatch => 'Les deux mots de passe sont identiques';

  @override
  String get newPasswordSubmit => 'Enregistrer et continuer';

  @override
  String get createPinStep => 'Étape 2 sur 2';

  @override
  String get createPinTitle => 'Créez votre PIN';

  @override
  String get createPinSubtitle => '4 chiffres pour confirmer chaque paiement';

  @override
  String get enableBiometric => 'Activer aussi la connexion par empreinte';

  @override
  String welcomeBack(Object name) {
    return 'Bon retour, $name';
  }

  @override
  String get quickLoginSubtitle => 'Entrez votre PIN ou touchez l’empreinte';

  @override
  String get enter => 'Entrer';

  @override
  String get useEmail => 'Utiliser l’e-mail';

  @override
  String get forgotPin => 'PIN oublié ?';

  @override
  String pinWrong(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'PIN incorrect. Encore $count essais.',
      one: 'PIN incorrect. Encore 1 essai.',
    );
    return '$_temp0';
  }

  @override
  String get forgotTitle => 'Mot de passe oublié';

  @override
  String get forgotHeadline => 'Pas de panique';

  @override
  String get forgotText =>
      'Pour votre sécurité, seul votre RH ou le support FlexiPay peut vous donner un nouveau mot de passe.';

  @override
  String get hrBadge => 'RH';

  @override
  String yourHrAt(Object company) {
    return 'Votre RH · $company';
  }

  @override
  String get supportTitle => 'Support FlexiPay';

  @override
  String get backToLogin => 'Retour à la connexion';

  @override
  String get lockedTitle => 'Compte bloqué pour un moment';

  @override
  String get lockedText => '3 PIN incorrects. Vous pourrez réessayer dans :';

  @override
  String get lockedNext => 'Ce qui se passe ensuite';

  @override
  String get lockLevel1 => '1er blocage : 15 minutes';

  @override
  String get lockLevel2 => '2e blocage : 30 minutes';

  @override
  String get lockLevel3 => '3e blocage : 60 minutes';

  @override
  String get lockLevel4 => 'Ensuite : reconnexion par e-mail';

  @override
  String get loginWithEmail => 'Se connecter avec l’e-mail';

  @override
  String get contactSupport => 'Contacter le support';

  @override
  String get hello => 'Bonjour,';

  @override
  String notificationsUnread(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Notifications, $count non lues',
      one: 'Notifications, 1 non lue',
      zero: 'Notifications',
    );
    return '$_temp0';
  }

  @override
  String get availableBalance => 'Solde disponible';

  @override
  String offeredBy(Object company) {
    return 'Offert par $company';
  }

  @override
  String get familyAction => 'Famille';

  @override
  String get myCredits => 'Mes crédits';

  @override
  String outOf(Object amount) {
    return 'sur $amount';
  }

  @override
  String get noCreditYet => 'Pas encore de crédit';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String statPayments(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'paiements',
      one: 'paiement',
      zero: 'paiement',
    );
    return '$_temp0';
  }

  @override
  String statMerchants(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'commerces',
      one: 'commerce',
      zero: 'commerce',
    );
    return '$_temp0';
  }

  @override
  String statFamilyMembers(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'membres famille',
      one: 'membre famille',
      zero: 'membre famille',
    );
    return '$_temp0';
  }

  @override
  String get weekChartLabel => 'Dépenses par jour';

  @override
  String get activity => 'Activité';

  @override
  String creditReceivedFrom(Object company) {
    return 'Crédit reçu · $company';
  }

  @override
  String creditBalanceOf(Object type) {
    return 'Solde $type';
  }

  @override
  String usedAmount(Object amount) {
    return 'Utilisé : $amount';
  }

  @override
  String receivedAmount(Object amount) {
    return 'Reçu : $amount';
  }

  @override
  String get statShared => 'partagés';

  @override
  String get expiresOn => 'expire le';

  @override
  String get whereToUse => 'Où l’utiliser';

  @override
  String get movements => 'Mouvements';

  @override
  String sharedWith(Object name) {
    return 'Partagé avec $name';
  }

  @override
  String payWith(Object type) {
    return 'Payer avec $type';
  }

  @override
  String get discoverTitle => 'Découvrir';

  @override
  String get discoverSubtitle => 'Où utiliser vos crédits près de chez vous';

  @override
  String get searchMerchant => 'Rechercher un commerce';

  @override
  String get viewOnMap => 'Voir sur la carte';

  @override
  String get filterByType => 'Filtrer par type';

  @override
  String get filterAll => 'Tous';

  @override
  String merchantCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count commerces',
      one: '1 commerce',
      zero: 'Aucun commerce',
    );
    return '$_temp0';
  }

  @override
  String get sortByDistance => 'Tri : distance';

  @override
  String get openNow => 'Ouvert';

  @override
  String get kindSupermarket => 'Supermarché';

  @override
  String get kindFuelStation => 'Station-service';

  @override
  String get kindRestaurant => 'Restaurant';

  @override
  String get kindShop => 'Boutique';

  @override
  String get payTitle => 'Payer';

  @override
  String get creditTypeLabel => 'Type de crédit';

  @override
  String get confirmTitle => 'Confirmer';

  @override
  String get amountLabel => 'Montant';

  @override
  String get enterPinToPay => 'Entrez votre PIN pour payer';

  @override
  String payAmount(Object amount) {
    return 'Payer $amount';
  }

  @override
  String get seeRefusalExample => 'Voir un exemple de refus';

  @override
  String get paidAmount => 'Montant payé';

  @override
  String cashierAt(Object name, Object date) {
    return 'Caissier : $name · $date';
  }

  @override
  String get typeLabel => 'Type';

  @override
  String get remaining => 'Reste';

  @override
  String get reference => 'Référence';

  @override
  String get paidBy => 'Payé par';

  @override
  String get approvedTitle => 'Ticket approuvé';

  @override
  String approvedText(Object name) {
    return 'Bon appétit $name ! Le reçu est dans votre historique.';
  }

  @override
  String get done => 'Terminé';

  @override
  String get shareReceipt => 'Partager le reçu';

  @override
  String get receiptLabel => 'Reçu';

  @override
  String get refusedTypeTitle => 'Type non accepté';

  @override
  String refusedTypeMessage(Object merchant, Object type) {
    return '$merchant n’accepte pas le crédit $type.';
  }

  @override
  String refusedTypeTip(Object types) {
    return 'Ici vous pouvez payer avec $types.';
  }

  @override
  String get refusedFundsTitle => 'Solde insuffisant';

  @override
  String refusedFundsMessage(Object amount, Object type) {
    return 'Il vous manque $amount sur votre crédit $type.';
  }

  @override
  String refusedFundsTip(Object amount) {
    return 'Demandez au caissier d’encaisser $amount et réglez le reste autrement.';
  }

  @override
  String get refusedMerchantTitle => 'Commerce pas encore actif';

  @override
  String refusedMerchantMessage(Object merchant) {
    return '$merchant n’est pas encore validée par FlexiPay.';
  }

  @override
  String refusedMerchantTip(Object type) {
    return 'Aucun montant n’a été débité. Trouvez un autre commerce qui accepte l’$type.';
  }

  @override
  String get refusedMerchantAction => 'Voir les commerces acceptés';

  @override
  String get refusedExpiredTitle => 'Demande expirée';

  @override
  String get refusedExpiredMessage =>
      'La demande de la caisse n\'est plus valable.';

  @override
  String get refusedExpiredTip =>
      'Une demande reste valable 2 minutes. Demandez au caissier de la renvoyer.';

  @override
  String get merchantLabel => 'Commerce';

  @override
  String get requestedAmount => 'Montant demandé';

  @override
  String get yourBalance => 'Votre solde';

  @override
  String get backHome => 'Retour à l’accueil';

  @override
  String get detail => 'Détail';

  @override
  String listOr(Object first, Object last) {
    return '$first ou $last';
  }

  @override
  String get historyTitle => 'Historique';

  @override
  String get monthFilter => 'Mois';

  @override
  String spentIn(Object month) {
    return 'Dépensé en $month';
  }

  @override
  String get monthSummary => 'Résumé du mois';

  @override
  String get statReceivedTnd => 'TND reçus';

  @override
  String get statSharedTnd => 'TND partagés';

  @override
  String get receiptTitle => 'Reçu';

  @override
  String get share => 'Partager';

  @override
  String get receiptDetailed => 'Reçu détaillé';

  @override
  String get dateLabel => 'Date';

  @override
  String get cashierLabel => 'Caissier';

  @override
  String get balanceBefore => 'Solde avant';

  @override
  String get balanceAfter => 'Solde après';

  @override
  String get reportProblem => 'Signaler un problème sur ce paiement';

  @override
  String get familyTitle => 'Ma famille';

  @override
  String get familyAccounts => 'Comptes famille';

  @override
  String familyUsage(Object used, Object max) {
    return '$used sur $max';
  }

  @override
  String get addMember => 'Ajouter un membre';

  @override
  String familyUntil(Object type, Object date) {
    return '$type · jusqu’au $date';
  }

  @override
  String get familyInfo =>
      'Le crédit partagé sort de votre solde. Vous pouvez le reprendre à tout moment.';

  @override
  String get firstNameLabel => 'Prénom';

  @override
  String get phoneOrEmail => 'Téléphone ou e-mail';

  @override
  String get creditTypeToShare => 'Type de crédit à partager';

  @override
  String get amountToShare => 'Montant à partager (TND)';

  @override
  String availableAmount(Object amount) {
    return 'Disponible : $amount';
  }

  @override
  String get dailyCap => 'Plafond par jour';

  @override
  String get decrease => 'Diminuer';

  @override
  String get increase => 'Augmenter';

  @override
  String get endDate => 'Date de fin';

  @override
  String memberSummary(
    Object name,
    Object cap,
    Object type,
    Object date,
    Object limit,
  ) {
    return '$name pourra dépenser **$cap par jour** en $type, jusqu’au **$date**, dans la limite de **$limit**.';
  }

  @override
  String createMemberAccount(String elide, Object name) {
    String _temp0 = intl.Intl.selectLogic(elide, {
      'yes': 'Créer le compte d’$name',
      'other': 'Créer le compte de $name',
    });
    return '$_temp0';
  }

  @override
  String memberCreatedTitle(String elide, Object name) {
    String _temp0 = intl.Intl.selectLogic(elide, {
      'yes': 'Compte d’$name créé',
      'other': 'Compte de $name créé',
    });
    return '$_temp0';
  }

  @override
  String memberCreatedText(Object name) {
    return 'Donnez-lui ce mot de passe. Il ne sera **plus jamais affiché** : $name devra le changer à sa 1re connexion.';
  }

  @override
  String get passwordNoted => 'J’ai noté le mot de passe';

  @override
  String memberBalance(String elide, Object name) {
    String _temp0 = intl.Intl.selectLogic(elide, {
      'yes': 'Solde d’$name',
      'other': 'Solde de $name',
    });
    return '$_temp0';
  }

  @override
  String todaySpent(Object spent, Object cap) {
    return 'Aujourd’hui : **$spent / $cap**';
  }

  @override
  String endShort(Object date) {
    return 'Fin : $date';
  }

  @override
  String get reclaimCredit => 'Reprendre le crédit';

  @override
  String reclaimDetail(Object amount) {
    return '$amount reviennent sur votre solde';
  }

  @override
  String get editCapOrDate => 'Modifier le plafond ou la date';

  @override
  String capPerDay(Object cap, Object date) {
    return '$cap / jour · $date';
  }

  @override
  String get newPasswordAction => 'Nouveau mot de passe';

  @override
  String get shownOnce => 'Affiché une seule fois';

  @override
  String get disableAccount => 'Désactiver le compte';

  @override
  String disableDetail(Object name) {
    return '$name ne pourra plus payer';
  }

  @override
  String memberSpending(String elide, Object name) {
    String _temp0 = intl.Intl.selectLogic(elide, {
      'yes': 'Dépenses d’$name',
      'other': 'Dépenses de $name',
    });
    return '$_temp0';
  }

  @override
  String helloName(Object name) {
    return 'Bonjour, $name';
  }

  @override
  String familyAccountOf(Object name) {
    return 'Compte famille de $name';
  }

  @override
  String myCreditOf(Object type) {
    return 'Mon crédit $type';
  }

  @override
  String leftToday(Object amount) {
    return 'Encore **$amount** aujourd’hui';
  }

  @override
  String untilDate(Object date) {
    return 'Jusqu’au $date';
  }

  @override
  String get dailyCapTitle => 'Plafond du jour';

  @override
  String capResets(Object cap) {
    return 'Le plafond revient à $cap chaque jour à minuit.';
  }

  @override
  String get myPayments => 'Mes paiements';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get markAllRead => 'Tout lire';

  @override
  String get notifPaymentApproved => 'Paiement approuvé';

  @override
  String notifPaymentApprovedBody(Object amount, Object merchant, Object type) {
    return '$amount chez $merchant ($type).';
  }

  @override
  String notifFamilyPaid(Object name) {
    return '$name a payé';
  }

  @override
  String notifFamilyPaidBody(Object amount, Object merchant, Object left) {
    return '$amount chez $merchant. Il lui reste $left pour aujourd’hui.';
  }

  @override
  String notifCreditReceived(Object company) {
    return 'Crédit reçu de $company';
  }

  @override
  String notifCreditReceivedBody(Object amount, Object details) {
    return '$amount : $details.';
  }

  @override
  String get notifNewLogin => 'Nouvelle connexion';

  @override
  String get notifNewLoginBody =>
      'Connexion depuis un nouvel appareil. Ce n’est pas vous ? Contactez le support.';

  @override
  String listAnd(Object first, Object last) {
    return '$first et $last';
  }

  @override
  String get myProfile => 'Mon profil';

  @override
  String get appearance => 'Apparence';

  @override
  String get theme => 'Thème';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeSystem => 'Système';

  @override
  String get language => 'Langue';

  @override
  String get langFr => 'Français';

  @override
  String get langAr => 'العربية';

  @override
  String get langEn => 'English';

  @override
  String get accountSecurity => 'Compte et sécurité';

  @override
  String get changePin => 'Changer mon PIN';

  @override
  String get pinDigits => '4 chiffres';

  @override
  String get biometricLogin => 'Connexion par empreinte';

  @override
  String get notificationsSetting => 'Notifications';

  @override
  String get needHelp => 'Besoin d’aide ?';

  @override
  String get needHelpSubtitle => 'Questions fréquentes et contact du support';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get helpTitle => 'Aide';

  @override
  String get helpHeadline => 'On vous aide';

  @override
  String get helpSubtitle => 'Réponses rapides, ou parlez au support.';

  @override
  String get faq1Q => 'Comment payer chez un commerçant ?';

  @override
  String get faq1A =>
      'Touchez le bouton vert Payer, choisissez le type de crédit et montrez le ticket au caissier. Confirmez ensuite avec votre PIN.';

  @override
  String get faq2Q => 'Pourquoi mon paiement est refusé ?';

  @override
  String get faq2A =>
      'Le commerce n’accepte peut-être pas ce type de crédit, votre solde est trop bas, ou le code a expiré. Le motif exact s’affiche à l’écran.';

  @override
  String get faq3Q => 'Qui recharge mon crédit ?';

  @override
  String get faq3A =>
      'Votre entreprise. Vous recevez une notification à chaque nouveau crédit.';

  @override
  String get faq4Q => 'J’ai oublié mon PIN';

  @override
  String get faq4A =>
      'Connectez-vous avec votre e-mail et votre mot de passe, puis créez un nouveau PIN dans Profil.';

  @override
  String get writeSupport => 'Écrire au support';

  @override
  String get yourHr => 'Votre RH';

  @override
  String get welcome => 'Bienvenue,';

  @override
  String get emptyTitle => 'Votre assiette est encore vide';

  @override
  String emptyText(Object company) {
    return 'Dès que $company vous attribue un crédit, il apparaît ici et vous recevez une notification.';
  }

  @override
  String get enableNotifications => 'Activer les notifications';

  @override
  String get enableNotificationsDetail => 'Pour savoir quand le crédit arrive';

  @override
  String get discoverMerchants => 'Découvrir les commerces';

  @override
  String get discoverMerchantsDetail => 'Où vous pourrez payer';

  @override
  String get offlineBanner => 'Vous êtes hors ligne';

  @override
  String updatedAt(Object time) {
    return 'Mis à jour à $time';
  }

  @override
  String get lastKnownBalance => 'Dernier solde connu';

  @override
  String get offlineTitle => 'Le paiement a besoin d’Internet';

  @override
  String get offlineText =>
      'Vérifiez le Wi-Fi ou les données mobiles, puis réessayez.';

  @override
  String get retry => 'Réessayer';

  @override
  String get proMerchantSpace => 'Espace commerçant';

  @override
  String get proLoginSubtitle =>
      'Propriétaire ou caissier : même écran, l’app s’adapte à votre rôle.';

  @override
  String get proLoginHelp =>
      'Mot de passe perdu ? Demandez à votre propriétaire ou au support FlexiPay.';

  @override
  String cashRegisterOf(Object name) {
    return 'Caisse de $name';
  }

  @override
  String get collectTitle => 'Encaisser';

  @override
  String get scanQr => 'Scanner le QR';

  @override
  String get enterCode => 'Saisir le code';

  @override
  String get paymentApproved => 'Paiement approuvé';

  @override
  String get customerConfirmed => 'Le client a confirmé avec son PIN.';

  @override
  String get paymentRefused => 'Paiement refusé';

  @override
  String refusedFundsPro(Object type, Object amount) {
    return 'Solde $type insuffisant : il manque $amount. Rien n’a été débité.';
  }

  @override
  String get customerLabel => 'Client';

  @override
  String get timeLabel => 'Heure';

  @override
  String get newCollection => 'Nouvel encaissement';

  @override
  String get seeDay => 'Voir la journée';

  @override
  String get collectedToday => 'Encaissé aujourd’hui';

  @override
  String statCollections(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'encaissements',
      one: 'encaissement',
      zero: 'encaissement',
    );
    return '$_temp0';
  }

  @override
  String get averageBasket => 'panier moyen';

  @override
  String get statRefusals => 'refus';

  @override
  String get hourlyChart => 'Encaissements par heure';

  @override
  String get collections => 'Encaissements';

  @override
  String get filterByCashier => 'Filtrer par caissier';

  @override
  String get filterMe => 'Moi';

  @override
  String familyTag(Object name) {
    return '$name (famille)';
  }

  @override
  String refusedTag(Object name) {
    return '$name · refusé';
  }

  @override
  String ownerEmail(Object email) {
    return 'Propriétaire · $email';
  }

  @override
  String get myBalance => 'Mon solde';

  @override
  String get toPayOut => 'À reverser';

  @override
  String get availableTodayJ0 => 'Disponible aujourd’hui (J+0)';

  @override
  String get ifRequestNow => 'Si vous demandez maintenant';

  @override
  String commissionRate(Object rate) {
    return 'Commission $rate';
  }

  @override
  String vatRate(Object rate) {
    return 'TVA $rate';
  }

  @override
  String get feesInclTax => 'Frais TTC';

  @override
  String get withholding => 'Retenue à la source';

  @override
  String withholdingNone(Object amount, Object threshold) {
    return '$amount (frais sous $threshold)';
  }

  @override
  String get stampDuty => 'Timbre';

  @override
  String get transferFee => 'Frais de virement';

  @override
  String get youWillReceive => 'Vous recevrez';

  @override
  String get requestPayout => 'Demander le reversement';

  @override
  String get payoutInfo =>
      'FlexiPay vire l’argent sur le RIB de votre dossier, puis vous envoie la référence bancaire.';

  @override
  String get transferTracking => 'Suivi des virements';

  @override
  String get payoutsTitle => 'Reversements';

  @override
  String requestRef(Object ref) {
    return 'Demande $ref';
  }

  @override
  String netOf(Object amount) {
    return 'Net sur $amount encaissés';
  }

  @override
  String get inProgress => 'En cours';

  @override
  String get stepRequested => 'Demandé';

  @override
  String get stepAcceptance => 'Acceptation par FlexiPay';

  @override
  String get pending => 'En attente';

  @override
  String get stepPaid => 'Payé + référence bancaire';

  @override
  String get upcoming => 'À venir';

  @override
  String get historySection => 'Historique';

  @override
  String payoutPaid(Object ref) {
    return '$ref · Payé';
  }

  @override
  String get ownerOnly => 'Réservé au propriétaire';

  @override
  String get myTeam => 'Mon équipe';

  @override
  String get youOwner => 'Vous · Propriétaire';

  @override
  String cashierRole(Object name) {
    return '$name · Caissier';
  }

  @override
  String activeLastAccess(Object time) {
    return 'Actif · dernier accès $time';
  }

  @override
  String get cashierActions => 'Actions sur un caissier';

  @override
  String get cashierActionsText =>
      'Modifier, désactiver ou générer un nouveau mot de passe (affiché une seule fois).';

  @override
  String get addCashier => 'Ajouter un caissier';

  @override
  String get newCashier => 'Nouveau caissier';

  @override
  String get fullNameLabel => 'Prénom et nom';

  @override
  String get tempPassword => 'Mot de passe temporaire (affiché une seule fois)';

  @override
  String get createCashier => 'Créer le caissier';

  @override
  String get catalogTitle => 'Catalogue des composants';

  @override
  String get catalogDemo => 'Démonstration';

  @override
  String get catalogOffline => 'Simuler la perte de réseau';

  @override
  String get payNfcTitle =>
      'Approchez votre téléphone de l\'autocollant FlexiPay';

  @override
  String get payNfcHint =>
      'Le montant s\'affiche ensuite : vous confirmez avec votre PIN.';

  @override
  String get payNfcUnavailable =>
      'NFC indisponible sur ce téléphone : scannez le QR ou tapez le code de la caisse.';

  @override
  String get payScanQr => 'Scanner le QR';

  @override
  String get payTypeCode => 'Taper le code de la caisse';

  @override
  String get payScanTitle => 'Scannez le QR de l\'autocollant';

  @override
  String get payCodeTitle => 'Code de la caisse';

  @override
  String get payCodeHint => '4 chiffres affichés à la caisse';

  @override
  String get payStickerRead => 'Autocollant lu';

  @override
  String registerAtCity(Object register, Object city) {
    return '$register · $city';
  }

  @override
  String get refusedPaidTitle => 'Déjà payée';

  @override
  String get refusedPaidMessage => 'Un autre client a déjà payé cette demande.';

  @override
  String get refusedStickerTitle => 'Autocollant invalide';

  @override
  String get refusedStickerMessage =>
      'Cet autocollant n\'est pas reconnu par FlexiPay.';

  @override
  String get refusedNoPendingTitle => 'Aucune demande en caisse';

  @override
  String get refusedNoPendingMessage =>
      'Demandez au caissier de saisir le montant, puis réessayez.';

  @override
  String get refusedFamilyTitle => 'Plafond du jour atteint';

  @override
  String refusedFamilyMessage(Object amount) {
    return 'Il vous reste $amount pour aujourd\'hui.';
  }

  @override
  String get refusedTryAgain => 'Réessayer';

  @override
  String get refusedNothingDebited => 'Aucun montant n\'a été débité.';

  @override
  String requestPayment(Object amount) {
    return 'Demander $amount';
  }

  @override
  String get waitingCustomer => 'En attente du client…';

  @override
  String get waitingHint =>
      'Le client approche son téléphone de l\'autocollant, scanne le QR ou tape ce code.';

  @override
  String get shortCodeLabel => 'Code de la caisse';

  @override
  String get cancelRequest => 'Annuler la demande';

  @override
  String get requestExpiredTitle => 'Demande expirée';

  @override
  String get requestCancelledTitle => 'Demande annulée';

  @override
  String get newRequest => 'Nouvelle demande';

  @override
  String paidByCustomer(Object name) {
    return 'Payé par $name';
  }

  @override
  String refusedForCustomer(Object name) {
    return 'Refusé pour $name';
  }

  @override
  String get tillRefusalFunds => 'Solde insuffisant. Rien n\'a été débité.';

  @override
  String get tillRefusalLimit =>
      'Plafond du jour atteint. Rien n\'a été débité.';

  @override
  String get tillRefusalOther => 'Paiement refusé. Rien n\'a été débité.';

  @override
  String get registersTitle => 'Mes caisses';

  @override
  String get registerSticker => 'Associer un autocollant';

  @override
  String get stickerApproach => 'Approchez l\'autocollant NFC du téléphone';

  @override
  String stickerApproachHint(Object register) {
    return 'Le lien de $register y sera écrit.';
  }

  @override
  String stickerWritten(Object register) {
    return 'Autocollant associé à $register';
  }

  @override
  String get stickerWriteFailed =>
      'Écriture impossible. Réessayez avec un autocollant NFC vierge.';

  @override
  String get registerDisabled => 'Désactivée';

  @override
  String get myRegister => 'Ma caisse';

  @override
  String get catalogNextCustomer => 'Prochain client';
}
