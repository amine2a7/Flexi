import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'fp_localizations_ar.dart';
import 'fp_localizations_en.dart';
import 'fp_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of FpL10n
/// returned by `FpL10n.of(context)`.
///
/// Applications need to include `FpL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/fp_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: FpL10n.localizationsDelegates,
///   supportedLocales: FpL10n.supportedLocales,
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
/// be consistent with the languages listed in the FpL10n.supportedLocales
/// property.
abstract class FpL10n {
  FpL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static FpL10n of(BuildContext context) {
    return Localizations.of<FpL10n>(context, FpL10n)!;
  }

  static const LocalizationsDelegate<FpL10n> delegate = _FpL10nDelegate();

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
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In fr, this message translates to:
  /// **'FlexiPay'**
  String get appName;

  /// No description provided for @appNamePro.
  ///
  /// In fr, this message translates to:
  /// **'FlexiPay Pro'**
  String get appNamePro;

  /// No description provided for @brandFlexi.
  ///
  /// In fr, this message translates to:
  /// **'Flexi'**
  String get brandFlexi;

  /// No description provided for @brandPay.
  ///
  /// In fr, this message translates to:
  /// **'Pay'**
  String get brandPay;

  /// No description provided for @brandPro.
  ///
  /// In fr, this message translates to:
  /// **'Pro'**
  String get brandPro;

  /// No description provided for @currency.
  ///
  /// In fr, this message translates to:
  /// **'TND'**
  String get currency;

  /// No description provided for @back.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get back;

  /// No description provided for @continueAction.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get continueAction;

  /// No description provided for @emailLabel.
  ///
  /// In fr, this message translates to:
  /// **'E-mail'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get passwordLabel;

  /// No description provided for @showPassword.
  ///
  /// In fr, this message translates to:
  /// **'Afficher le mot de passe'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In fr, this message translates to:
  /// **'Masquer le mot de passe'**
  String get hidePassword;

  /// No description provided for @copy.
  ///
  /// In fr, this message translates to:
  /// **'Copier'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In fr, this message translates to:
  /// **'Copié'**
  String get copied;

  /// No description provided for @today.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd’hui'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In fr, this message translates to:
  /// **'Hier'**
  String get yesterday;

  /// No description provided for @seeAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout voir'**
  String get seeAll;

  /// No description provided for @loading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement'**
  String get loading;

  /// No description provided for @pinEntered.
  ///
  /// In fr, this message translates to:
  /// **'Code PIN saisi'**
  String get pinEntered;

  /// No description provided for @pinKeyBiometric.
  ///
  /// In fr, this message translates to:
  /// **'Utiliser mon empreinte'**
  String get pinKeyBiometric;

  /// No description provided for @pinKeyDelete.
  ///
  /// In fr, this message translates to:
  /// **'Effacer'**
  String get pinKeyDelete;

  /// No description provided for @biometricReason.
  ///
  /// In fr, this message translates to:
  /// **'Confirmez votre identité pour ouvrir FlexiPay'**
  String get biometricReason;

  /// No description provided for @genericError.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue. Réessayez.'**
  String get genericError;

  /// No description provided for @creditTypeFood.
  ///
  /// In fr, this message translates to:
  /// **'Restauration'**
  String get creditTypeFood;

  /// No description provided for @creditTypeClothing.
  ///
  /// In fr, this message translates to:
  /// **'Habillement'**
  String get creditTypeClothing;

  /// No description provided for @creditTypeFuel.
  ///
  /// In fr, this message translates to:
  /// **'Carburant'**
  String get creditTypeFuel;

  /// No description provided for @creditTypeGifts.
  ///
  /// In fr, this message translates to:
  /// **'Cadeaux'**
  String get creditTypeGifts;

  /// No description provided for @navHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// No description provided for @navDiscover.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir'**
  String get navDiscover;

  /// No description provided for @navPay.
  ///
  /// In fr, this message translates to:
  /// **'Payer'**
  String get navPay;

  /// No description provided for @navHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get navHistory;

  /// No description provided for @navProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @proNavToday.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd’hui'**
  String get proNavToday;

  /// No description provided for @proNavBalance.
  ///
  /// In fr, this message translates to:
  /// **'Solde'**
  String get proNavBalance;

  /// No description provided for @proNavCollect.
  ///
  /// In fr, this message translates to:
  /// **'Encaisser'**
  String get proNavCollect;

  /// No description provided for @proNavPayouts.
  ///
  /// In fr, this message translates to:
  /// **'Reversements'**
  String get proNavPayouts;

  /// No description provided for @proNavTeam.
  ///
  /// In fr, this message translates to:
  /// **'Équipe'**
  String get proNavTeam;

  /// No description provided for @mainNavigation.
  ///
  /// In fr, this message translates to:
  /// **'Navigation principale'**
  String get mainNavigation;

  /// No description provided for @stampApproved.
  ///
  /// In fr, this message translates to:
  /// **'APPROUVÉ'**
  String get stampApproved;

  /// No description provided for @stampRefused.
  ///
  /// In fr, this message translates to:
  /// **'REFUSÉ'**
  String get stampRefused;

  /// No description provided for @splashTagline.
  ///
  /// In fr, this message translates to:
  /// **'Vos avantages, en un seul ticket.'**
  String get splashTagline;

  /// No description provided for @onboardingSkip.
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get onboardingSkip;

  /// No description provided for @onboarding1Title.
  ///
  /// In fr, this message translates to:
  /// **'Tous vos avantages au même endroit'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Text.
  ///
  /// In fr, this message translates to:
  /// **'Restauration, Habillement, Carburant, Cadeaux : un solde pour chaque type, offert par votre entreprise.'**
  String get onboarding1Text;

  /// No description provided for @onboarding2Title.
  ///
  /// In fr, this message translates to:
  /// **'Payez en montrant un ticket'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Text.
  ///
  /// In fr, this message translates to:
  /// **'Le caissier scanne votre QR ou saisit votre code. Vous confirmez avec votre PIN.'**
  String get onboarding2Text;

  /// No description provided for @onboarding3Title.
  ///
  /// In fr, this message translates to:
  /// **'Partagez avec votre famille'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Text.
  ///
  /// In fr, this message translates to:
  /// **'Créez jusqu’à 5 comptes famille, avec un plafond par jour et une date de fin.'**
  String get onboarding3Text;

  /// No description provided for @onboardingNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get onboardingNext;

  /// No description provided for @onboardingLogin.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get onboardingLogin;

  /// No description provided for @loginTicketLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ticket d\'accès'**
  String get loginTicketLabel;

  /// No description provided for @loginTicketNumber.
  ///
  /// In fr, this message translates to:
  /// **'N° {number}'**
  String loginTicketNumber(Object number);

  /// No description provided for @loginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Utilisez l’e-mail et le mot de passe reçus de votre entreprise.'**
  String get loginSubtitle;

  /// No description provided for @forgotPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get forgotPassword;

  /// No description provided for @loginSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Valider mon ticket'**
  String get loginSubmit;

  /// No description provided for @loginWithPin.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter avec le PIN'**
  String get loginWithPin;

  /// No description provided for @loginHelp.
  ///
  /// In fr, this message translates to:
  /// **'Problème de connexion ? Contactez votre RH.'**
  String get loginHelp;

  /// No description provided for @loginError.
  ///
  /// In fr, this message translates to:
  /// **'E-mail ou mot de passe incorrect.'**
  String get loginError;

  /// No description provided for @newPasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get newPasswordTitle;

  /// No description provided for @newPasswordInfo.
  ///
  /// In fr, this message translates to:
  /// **'**Première connexion.** Choisissez votre propre mot de passe : celui reçu de votre RH ne marchera plus.'**
  String get newPasswordInfo;

  /// No description provided for @newPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get confirmPasswordLabel;

  /// No description provided for @ruleLength.
  ///
  /// In fr, this message translates to:
  /// **'Au moins 8 caractères'**
  String get ruleLength;

  /// No description provided for @ruleUpper.
  ///
  /// In fr, this message translates to:
  /// **'Une majuscule'**
  String get ruleUpper;

  /// No description provided for @ruleDigit.
  ///
  /// In fr, this message translates to:
  /// **'Un chiffre'**
  String get ruleDigit;

  /// No description provided for @ruleMatch.
  ///
  /// In fr, this message translates to:
  /// **'Les deux mots de passe sont identiques'**
  String get ruleMatch;

  /// No description provided for @newPasswordSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer et continuer'**
  String get newPasswordSubmit;

  /// No description provided for @createPinStep.
  ///
  /// In fr, this message translates to:
  /// **'Étape 2 sur 2'**
  String get createPinStep;

  /// No description provided for @createPinTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créez votre PIN'**
  String get createPinTitle;

  /// No description provided for @createPinSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'4 chiffres pour confirmer chaque paiement'**
  String get createPinSubtitle;

  /// No description provided for @enableBiometric.
  ///
  /// In fr, this message translates to:
  /// **'Activer aussi la connexion par empreinte'**
  String get enableBiometric;

  /// No description provided for @welcomeBack.
  ///
  /// In fr, this message translates to:
  /// **'Bon retour, {name}'**
  String welcomeBack(Object name);

  /// No description provided for @quickLoginSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre PIN ou touchez l’empreinte'**
  String get quickLoginSubtitle;

  /// No description provided for @enter.
  ///
  /// In fr, this message translates to:
  /// **'Entrer'**
  String get enter;

  /// No description provided for @useEmail.
  ///
  /// In fr, this message translates to:
  /// **'Utiliser l’e-mail'**
  String get useEmail;

  /// No description provided for @forgotPin.
  ///
  /// In fr, this message translates to:
  /// **'PIN oublié ?'**
  String get forgotPin;

  /// No description provided for @pinWrong.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{PIN incorrect. Encore 1 essai.} other{PIN incorrect. Encore {count} essais.}}'**
  String pinWrong(num count);

  /// No description provided for @forgotTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié'**
  String get forgotTitle;

  /// No description provided for @forgotHeadline.
  ///
  /// In fr, this message translates to:
  /// **'Pas de panique'**
  String get forgotHeadline;

  /// No description provided for @forgotText.
  ///
  /// In fr, this message translates to:
  /// **'Pour votre sécurité, seul votre RH ou le support FlexiPay peut vous donner un nouveau mot de passe.'**
  String get forgotText;

  /// No description provided for @hrBadge.
  ///
  /// In fr, this message translates to:
  /// **'RH'**
  String get hrBadge;

  /// No description provided for @yourHrAt.
  ///
  /// In fr, this message translates to:
  /// **'Votre RH · {company}'**
  String yourHrAt(Object company);

  /// No description provided for @supportTitle.
  ///
  /// In fr, this message translates to:
  /// **'Support FlexiPay'**
  String get supportTitle;

  /// No description provided for @backToLogin.
  ///
  /// In fr, this message translates to:
  /// **'Retour à la connexion'**
  String get backToLogin;

  /// No description provided for @lockedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Compte bloqué pour un moment'**
  String get lockedTitle;

  /// No description provided for @lockedText.
  ///
  /// In fr, this message translates to:
  /// **'3 PIN incorrects. Vous pourrez réessayer dans :'**
  String get lockedText;

  /// No description provided for @lockedNext.
  ///
  /// In fr, this message translates to:
  /// **'Ce qui se passe ensuite'**
  String get lockedNext;

  /// No description provided for @lockLevel1.
  ///
  /// In fr, this message translates to:
  /// **'1er blocage : 15 minutes'**
  String get lockLevel1;

  /// No description provided for @lockLevel2.
  ///
  /// In fr, this message translates to:
  /// **'2e blocage : 30 minutes'**
  String get lockLevel2;

  /// No description provided for @lockLevel3.
  ///
  /// In fr, this message translates to:
  /// **'3e blocage : 60 minutes'**
  String get lockLevel3;

  /// No description provided for @lockLevel4.
  ///
  /// In fr, this message translates to:
  /// **'Ensuite : reconnexion par e-mail'**
  String get lockLevel4;

  /// No description provided for @loginWithEmail.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter avec l’e-mail'**
  String get loginWithEmail;

  /// No description provided for @contactSupport.
  ///
  /// In fr, this message translates to:
  /// **'Contacter le support'**
  String get contactSupport;

  /// No description provided for @hello.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour,'**
  String get hello;

  /// No description provided for @notificationsUnread.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Notifications} =1{Notifications, 1 non lue} other{Notifications, {count} non lues}}'**
  String notificationsUnread(num count);

  /// No description provided for @availableBalance.
  ///
  /// In fr, this message translates to:
  /// **'Solde disponible'**
  String get availableBalance;

  /// No description provided for @offeredBy.
  ///
  /// In fr, this message translates to:
  /// **'Offert par {company}'**
  String offeredBy(Object company);

  /// No description provided for @familyAction.
  ///
  /// In fr, this message translates to:
  /// **'Famille'**
  String get familyAction;

  /// No description provided for @myCredits.
  ///
  /// In fr, this message translates to:
  /// **'Mes crédits'**
  String get myCredits;

  /// No description provided for @outOf.
  ///
  /// In fr, this message translates to:
  /// **'sur {amount}'**
  String outOf(Object amount);

  /// No description provided for @noCreditYet.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de crédit'**
  String get noCreditYet;

  /// No description provided for @thisWeek.
  ///
  /// In fr, this message translates to:
  /// **'Cette semaine'**
  String get thisWeek;

  /// No description provided for @statPayments.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{paiement} =1{paiement} other{paiements}}'**
  String statPayments(num count);

  /// No description provided for @statMerchants.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{commerce} =1{commerce} other{commerces}}'**
  String statMerchants(num count);

  /// No description provided for @statFamilyMembers.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{membre famille} =1{membre famille} other{membres famille}}'**
  String statFamilyMembers(num count);

  /// No description provided for @weekChartLabel.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses par jour'**
  String get weekChartLabel;

  /// No description provided for @activity.
  ///
  /// In fr, this message translates to:
  /// **'Activité'**
  String get activity;

  /// No description provided for @creditReceivedFrom.
  ///
  /// In fr, this message translates to:
  /// **'Crédit reçu · {company}'**
  String creditReceivedFrom(Object company);

  /// No description provided for @creditBalanceOf.
  ///
  /// In fr, this message translates to:
  /// **'Solde {type}'**
  String creditBalanceOf(Object type);

  /// No description provided for @usedAmount.
  ///
  /// In fr, this message translates to:
  /// **'Utilisé : {amount}'**
  String usedAmount(Object amount);

  /// No description provided for @receivedAmount.
  ///
  /// In fr, this message translates to:
  /// **'Reçu : {amount}'**
  String receivedAmount(Object amount);

  /// No description provided for @statShared.
  ///
  /// In fr, this message translates to:
  /// **'partagés'**
  String get statShared;

  /// No description provided for @expiresOn.
  ///
  /// In fr, this message translates to:
  /// **'expire le'**
  String get expiresOn;

  /// No description provided for @whereToUse.
  ///
  /// In fr, this message translates to:
  /// **'Où l’utiliser'**
  String get whereToUse;

  /// No description provided for @movements.
  ///
  /// In fr, this message translates to:
  /// **'Mouvements'**
  String get movements;

  /// No description provided for @sharedWith.
  ///
  /// In fr, this message translates to:
  /// **'Partagé avec {name}'**
  String sharedWith(Object name);

  /// No description provided for @payWith.
  ///
  /// In fr, this message translates to:
  /// **'Payer avec {type}'**
  String payWith(Object type);

  /// No description provided for @discoverTitle.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir'**
  String get discoverTitle;

  /// No description provided for @discoverSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Où utiliser vos crédits près de chez vous'**
  String get discoverSubtitle;

  /// No description provided for @searchMerchant.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un commerce'**
  String get searchMerchant;

  /// No description provided for @viewOnMap.
  ///
  /// In fr, this message translates to:
  /// **'Voir sur la carte'**
  String get viewOnMap;

  /// No description provided for @filterByType.
  ///
  /// In fr, this message translates to:
  /// **'Filtrer par type'**
  String get filterByType;

  /// No description provided for @filterAll.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get filterAll;

  /// No description provided for @merchantCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun commerce} =1{1 commerce} other{{count} commerces}}'**
  String merchantCount(num count);

  /// No description provided for @sortByDistance.
  ///
  /// In fr, this message translates to:
  /// **'Tri : distance'**
  String get sortByDistance;

  /// No description provided for @openNow.
  ///
  /// In fr, this message translates to:
  /// **'Ouvert'**
  String get openNow;

  /// No description provided for @kindSupermarket.
  ///
  /// In fr, this message translates to:
  /// **'Supermarché'**
  String get kindSupermarket;

  /// No description provided for @kindFuelStation.
  ///
  /// In fr, this message translates to:
  /// **'Station-service'**
  String get kindFuelStation;

  /// No description provided for @kindRestaurant.
  ///
  /// In fr, this message translates to:
  /// **'Restaurant'**
  String get kindRestaurant;

  /// No description provided for @kindShop.
  ///
  /// In fr, this message translates to:
  /// **'Boutique'**
  String get kindShop;

  /// No description provided for @payTitle.
  ///
  /// In fr, this message translates to:
  /// **'Payer'**
  String get payTitle;

  /// No description provided for @creditTypeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Type de crédit'**
  String get creditTypeLabel;

  /// No description provided for @confirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirmTitle;

  /// No description provided for @amountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Montant'**
  String get amountLabel;

  /// No description provided for @enterPinToPay.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre PIN pour payer'**
  String get enterPinToPay;

  /// No description provided for @payAmount.
  ///
  /// In fr, this message translates to:
  /// **'Payer {amount}'**
  String payAmount(Object amount);

  /// No description provided for @seeRefusalExample.
  ///
  /// In fr, this message translates to:
  /// **'Voir un exemple de refus'**
  String get seeRefusalExample;

  /// No description provided for @paidAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant payé'**
  String get paidAmount;

  /// No description provided for @cashierAt.
  ///
  /// In fr, this message translates to:
  /// **'Caissier : {name} · {date}'**
  String cashierAt(Object name, Object date);

  /// No description provided for @typeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get typeLabel;

  /// No description provided for @remaining.
  ///
  /// In fr, this message translates to:
  /// **'Reste'**
  String get remaining;

  /// No description provided for @reference.
  ///
  /// In fr, this message translates to:
  /// **'Référence'**
  String get reference;

  /// No description provided for @paidBy.
  ///
  /// In fr, this message translates to:
  /// **'Payé par'**
  String get paidBy;

  /// No description provided for @approvedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ticket approuvé'**
  String get approvedTitle;

  /// No description provided for @approvedText.
  ///
  /// In fr, this message translates to:
  /// **'Bon appétit {name} ! Le reçu est dans votre historique.'**
  String approvedText(Object name);

  /// No description provided for @done.
  ///
  /// In fr, this message translates to:
  /// **'Terminé'**
  String get done;

  /// No description provided for @shareReceipt.
  ///
  /// In fr, this message translates to:
  /// **'Partager le reçu'**
  String get shareReceipt;

  /// No description provided for @receiptLabel.
  ///
  /// In fr, this message translates to:
  /// **'Reçu'**
  String get receiptLabel;

  /// No description provided for @refusedTypeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Type non accepté'**
  String get refusedTypeTitle;

  /// No description provided for @refusedTypeMessage.
  ///
  /// In fr, this message translates to:
  /// **'{merchant} n’accepte pas le crédit {type}.'**
  String refusedTypeMessage(Object merchant, Object type);

  /// No description provided for @refusedTypeTip.
  ///
  /// In fr, this message translates to:
  /// **'Ici vous pouvez payer avec {types}.'**
  String refusedTypeTip(Object types);

  /// No description provided for @refusedFundsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Solde insuffisant'**
  String get refusedFundsTitle;

  /// No description provided for @refusedFundsMessage.
  ///
  /// In fr, this message translates to:
  /// **'Il vous manque {amount} sur votre crédit {type}.'**
  String refusedFundsMessage(Object amount, Object type);

  /// No description provided for @refusedFundsTip.
  ///
  /// In fr, this message translates to:
  /// **'Demandez au caissier d’encaisser {amount} et réglez le reste autrement.'**
  String refusedFundsTip(Object amount);

  /// No description provided for @refusedMerchantTitle.
  ///
  /// In fr, this message translates to:
  /// **'Commerce pas encore actif'**
  String get refusedMerchantTitle;

  /// No description provided for @refusedMerchantMessage.
  ///
  /// In fr, this message translates to:
  /// **'{merchant} n’est pas encore validée par FlexiPay.'**
  String refusedMerchantMessage(Object merchant);

  /// No description provided for @refusedMerchantTip.
  ///
  /// In fr, this message translates to:
  /// **'Aucun montant n’a été débité. Trouvez un autre commerce qui accepte l’{type}.'**
  String refusedMerchantTip(Object type);

  /// No description provided for @refusedMerchantAction.
  ///
  /// In fr, this message translates to:
  /// **'Voir les commerces acceptés'**
  String get refusedMerchantAction;

  /// No description provided for @refusedExpiredTitle.
  ///
  /// In fr, this message translates to:
  /// **'Demande expirée'**
  String get refusedExpiredTitle;

  /// No description provided for @refusedExpiredMessage.
  ///
  /// In fr, this message translates to:
  /// **'La demande de la caisse n\'est plus valable.'**
  String get refusedExpiredMessage;

  /// No description provided for @refusedExpiredTip.
  ///
  /// In fr, this message translates to:
  /// **'Une demande reste valable 2 minutes. Demandez au caissier de la renvoyer.'**
  String get refusedExpiredTip;

  /// No description provided for @merchantLabel.
  ///
  /// In fr, this message translates to:
  /// **'Commerce'**
  String get merchantLabel;

  /// No description provided for @requestedAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant demandé'**
  String get requestedAmount;

  /// No description provided for @yourBalance.
  ///
  /// In fr, this message translates to:
  /// **'Votre solde'**
  String get yourBalance;

  /// No description provided for @backHome.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l’accueil'**
  String get backHome;

  /// No description provided for @detail.
  ///
  /// In fr, this message translates to:
  /// **'Détail'**
  String get detail;

  /// No description provided for @listOr.
  ///
  /// In fr, this message translates to:
  /// **'{first} ou {last}'**
  String listOr(Object first, Object last);

  /// No description provided for @historyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get historyTitle;

  /// No description provided for @monthFilter.
  ///
  /// In fr, this message translates to:
  /// **'Mois'**
  String get monthFilter;

  /// No description provided for @spentIn.
  ///
  /// In fr, this message translates to:
  /// **'Dépensé en {month}'**
  String spentIn(Object month);

  /// No description provided for @monthSummary.
  ///
  /// In fr, this message translates to:
  /// **'Résumé du mois'**
  String get monthSummary;

  /// No description provided for @statReceivedTnd.
  ///
  /// In fr, this message translates to:
  /// **'TND reçus'**
  String get statReceivedTnd;

  /// No description provided for @statSharedTnd.
  ///
  /// In fr, this message translates to:
  /// **'TND partagés'**
  String get statSharedTnd;

  /// No description provided for @receiptTitle.
  ///
  /// In fr, this message translates to:
  /// **'Reçu'**
  String get receiptTitle;

  /// No description provided for @share.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get share;

  /// No description provided for @receiptDetailed.
  ///
  /// In fr, this message translates to:
  /// **'Reçu détaillé'**
  String get receiptDetailed;

  /// No description provided for @dateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @cashierLabel.
  ///
  /// In fr, this message translates to:
  /// **'Caissier'**
  String get cashierLabel;

  /// No description provided for @balanceBefore.
  ///
  /// In fr, this message translates to:
  /// **'Solde avant'**
  String get balanceBefore;

  /// No description provided for @balanceAfter.
  ///
  /// In fr, this message translates to:
  /// **'Solde après'**
  String get balanceAfter;

  /// No description provided for @reportProblem.
  ///
  /// In fr, this message translates to:
  /// **'Signaler un problème sur ce paiement'**
  String get reportProblem;

  /// No description provided for @familyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ma famille'**
  String get familyTitle;

  /// No description provided for @familyAccounts.
  ///
  /// In fr, this message translates to:
  /// **'Comptes famille'**
  String get familyAccounts;

  /// No description provided for @familyUsage.
  ///
  /// In fr, this message translates to:
  /// **'{used} sur {max}'**
  String familyUsage(Object used, Object max);

  /// No description provided for @addMember.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un membre'**
  String get addMember;

  /// No description provided for @familyUntil.
  ///
  /// In fr, this message translates to:
  /// **'{type} · jusqu’au {date}'**
  String familyUntil(Object type, Object date);

  /// No description provided for @familyInfo.
  ///
  /// In fr, this message translates to:
  /// **'Le crédit partagé sort de votre solde. Vous pouvez le reprendre à tout moment.'**
  String get familyInfo;

  /// No description provided for @firstNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Prénom'**
  String get firstNameLabel;

  /// No description provided for @phoneOrEmail.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone ou e-mail'**
  String get phoneOrEmail;

  /// No description provided for @creditTypeToShare.
  ///
  /// In fr, this message translates to:
  /// **'Type de crédit à partager'**
  String get creditTypeToShare;

  /// No description provided for @amountToShare.
  ///
  /// In fr, this message translates to:
  /// **'Montant à partager (TND)'**
  String get amountToShare;

  /// No description provided for @availableAmount.
  ///
  /// In fr, this message translates to:
  /// **'Disponible : {amount}'**
  String availableAmount(Object amount);

  /// No description provided for @dailyCap.
  ///
  /// In fr, this message translates to:
  /// **'Plafond par jour'**
  String get dailyCap;

  /// No description provided for @decrease.
  ///
  /// In fr, this message translates to:
  /// **'Diminuer'**
  String get decrease;

  /// No description provided for @increase.
  ///
  /// In fr, this message translates to:
  /// **'Augmenter'**
  String get increase;

  /// No description provided for @endDate.
  ///
  /// In fr, this message translates to:
  /// **'Date de fin'**
  String get endDate;

  /// No description provided for @memberSummary.
  ///
  /// In fr, this message translates to:
  /// **'{name} pourra dépenser **{cap} par jour** en {type}, jusqu’au **{date}**, dans la limite de **{limit}**.'**
  String memberSummary(
    Object name,
    Object cap,
    Object type,
    Object date,
    Object limit,
  );

  /// No description provided for @createMemberAccount.
  ///
  /// In fr, this message translates to:
  /// **'{elide, select, yes{Créer le compte d’{name}} other{Créer le compte de {name}}}'**
  String createMemberAccount(String elide, Object name);

  /// No description provided for @memberCreatedTitle.
  ///
  /// In fr, this message translates to:
  /// **'{elide, select, yes{Compte d’{name} créé} other{Compte de {name} créé}}'**
  String memberCreatedTitle(String elide, Object name);

  /// No description provided for @memberCreatedText.
  ///
  /// In fr, this message translates to:
  /// **'Donnez-lui ce mot de passe. Il ne sera **plus jamais affiché** : {name} devra le changer à sa 1re connexion.'**
  String memberCreatedText(Object name);

  /// No description provided for @passwordNoted.
  ///
  /// In fr, this message translates to:
  /// **'J’ai noté le mot de passe'**
  String get passwordNoted;

  /// No description provided for @memberBalance.
  ///
  /// In fr, this message translates to:
  /// **'{elide, select, yes{Solde d’{name}} other{Solde de {name}}}'**
  String memberBalance(String elide, Object name);

  /// No description provided for @todaySpent.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd’hui : **{spent} / {cap}**'**
  String todaySpent(Object spent, Object cap);

  /// No description provided for @endShort.
  ///
  /// In fr, this message translates to:
  /// **'Fin : {date}'**
  String endShort(Object date);

  /// No description provided for @reclaimCredit.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre le crédit'**
  String get reclaimCredit;

  /// No description provided for @reclaimDetail.
  ///
  /// In fr, this message translates to:
  /// **'{amount} reviennent sur votre solde'**
  String reclaimDetail(Object amount);

  /// No description provided for @editCapOrDate.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le plafond ou la date'**
  String get editCapOrDate;

  /// No description provided for @capPerDay.
  ///
  /// In fr, this message translates to:
  /// **'{cap} / jour · {date}'**
  String capPerDay(Object cap, Object date);

  /// No description provided for @newPasswordAction.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get newPasswordAction;

  /// No description provided for @shownOnce.
  ///
  /// In fr, this message translates to:
  /// **'Affiché une seule fois'**
  String get shownOnce;

  /// No description provided for @disableAccount.
  ///
  /// In fr, this message translates to:
  /// **'Désactiver le compte'**
  String get disableAccount;

  /// No description provided for @disableDetail.
  ///
  /// In fr, this message translates to:
  /// **'{name} ne pourra plus payer'**
  String disableDetail(Object name);

  /// No description provided for @memberSpending.
  ///
  /// In fr, this message translates to:
  /// **'{elide, select, yes{Dépenses d’{name}} other{Dépenses de {name}}}'**
  String memberSpending(String elide, Object name);

  /// No description provided for @helloName.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour, {name}'**
  String helloName(Object name);

  /// No description provided for @familyAccountOf.
  ///
  /// In fr, this message translates to:
  /// **'Compte famille de {name}'**
  String familyAccountOf(Object name);

  /// No description provided for @myCreditOf.
  ///
  /// In fr, this message translates to:
  /// **'Mon crédit {type}'**
  String myCreditOf(Object type);

  /// No description provided for @leftToday.
  ///
  /// In fr, this message translates to:
  /// **'Encore **{amount}** aujourd’hui'**
  String leftToday(Object amount);

  /// No description provided for @untilDate.
  ///
  /// In fr, this message translates to:
  /// **'Jusqu’au {date}'**
  String untilDate(Object date);

  /// No description provided for @dailyCapTitle.
  ///
  /// In fr, this message translates to:
  /// **'Plafond du jour'**
  String get dailyCapTitle;

  /// No description provided for @capResets.
  ///
  /// In fr, this message translates to:
  /// **'Le plafond revient à {cap} chaque jour à minuit.'**
  String capResets(Object cap);

  /// No description provided for @myPayments.
  ///
  /// In fr, this message translates to:
  /// **'Mes paiements'**
  String get myPayments;

  /// No description provided for @notificationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @markAllRead.
  ///
  /// In fr, this message translates to:
  /// **'Tout lire'**
  String get markAllRead;

  /// No description provided for @notifPaymentApproved.
  ///
  /// In fr, this message translates to:
  /// **'Paiement approuvé'**
  String get notifPaymentApproved;

  /// No description provided for @notifPaymentApprovedBody.
  ///
  /// In fr, this message translates to:
  /// **'{amount} chez {merchant} ({type}).'**
  String notifPaymentApprovedBody(Object amount, Object merchant, Object type);

  /// No description provided for @notifFamilyPaid.
  ///
  /// In fr, this message translates to:
  /// **'{name} a payé'**
  String notifFamilyPaid(Object name);

  /// No description provided for @notifFamilyPaidBody.
  ///
  /// In fr, this message translates to:
  /// **'{amount} chez {merchant}. Il lui reste {left} pour aujourd’hui.'**
  String notifFamilyPaidBody(Object amount, Object merchant, Object left);

  /// No description provided for @notifCreditReceived.
  ///
  /// In fr, this message translates to:
  /// **'Crédit reçu de {company}'**
  String notifCreditReceived(Object company);

  /// No description provided for @notifCreditReceivedBody.
  ///
  /// In fr, this message translates to:
  /// **'{amount} : {details}.'**
  String notifCreditReceivedBody(Object amount, Object details);

  /// No description provided for @notifNewLogin.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle connexion'**
  String get notifNewLogin;

  /// No description provided for @notifNewLoginBody.
  ///
  /// In fr, this message translates to:
  /// **'Connexion depuis un nouvel appareil. Ce n’est pas vous ? Contactez le support.'**
  String get notifNewLoginBody;

  /// No description provided for @listAnd.
  ///
  /// In fr, this message translates to:
  /// **'{first} et {last}'**
  String listAnd(Object first, Object last);

  /// No description provided for @myProfile.
  ///
  /// In fr, this message translates to:
  /// **'Mon profil'**
  String get myProfile;

  /// No description provided for @appearance.
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get themeSystem;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @langFr.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get langFr;

  /// No description provided for @langAr.
  ///
  /// In fr, this message translates to:
  /// **'العربية'**
  String get langAr;

  /// No description provided for @langEn.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get langEn;

  /// No description provided for @accountSecurity.
  ///
  /// In fr, this message translates to:
  /// **'Compte et sécurité'**
  String get accountSecurity;

  /// No description provided for @changePin.
  ///
  /// In fr, this message translates to:
  /// **'Changer mon PIN'**
  String get changePin;

  /// No description provided for @pinDigits.
  ///
  /// In fr, this message translates to:
  /// **'4 chiffres'**
  String get pinDigits;

  /// No description provided for @biometricLogin.
  ///
  /// In fr, this message translates to:
  /// **'Connexion par empreinte'**
  String get biometricLogin;

  /// No description provided for @notificationsSetting.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notificationsSetting;

  /// No description provided for @needHelp.
  ///
  /// In fr, this message translates to:
  /// **'Besoin d’aide ?'**
  String get needHelp;

  /// No description provided for @needHelpSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Questions fréquentes et contact du support'**
  String get needHelpSubtitle;

  /// No description provided for @logout.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get logout;

  /// No description provided for @helpTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aide'**
  String get helpTitle;

  /// No description provided for @helpHeadline.
  ///
  /// In fr, this message translates to:
  /// **'On vous aide'**
  String get helpHeadline;

  /// No description provided for @helpSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Réponses rapides, ou parlez au support.'**
  String get helpSubtitle;

  /// No description provided for @faq1Q.
  ///
  /// In fr, this message translates to:
  /// **'Comment payer chez un commerçant ?'**
  String get faq1Q;

  /// No description provided for @faq1A.
  ///
  /// In fr, this message translates to:
  /// **'Touchez le bouton vert Payer, choisissez le type de crédit et montrez le ticket au caissier. Confirmez ensuite avec votre PIN.'**
  String get faq1A;

  /// No description provided for @faq2Q.
  ///
  /// In fr, this message translates to:
  /// **'Pourquoi mon paiement est refusé ?'**
  String get faq2Q;

  /// No description provided for @faq2A.
  ///
  /// In fr, this message translates to:
  /// **'Le commerce n’accepte peut-être pas ce type de crédit, votre solde est trop bas, ou le code a expiré. Le motif exact s’affiche à l’écran.'**
  String get faq2A;

  /// No description provided for @faq3Q.
  ///
  /// In fr, this message translates to:
  /// **'Qui recharge mon crédit ?'**
  String get faq3Q;

  /// No description provided for @faq3A.
  ///
  /// In fr, this message translates to:
  /// **'Votre entreprise. Vous recevez une notification à chaque nouveau crédit.'**
  String get faq3A;

  /// No description provided for @faq4Q.
  ///
  /// In fr, this message translates to:
  /// **'J’ai oublié mon PIN'**
  String get faq4Q;

  /// No description provided for @faq4A.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous avec votre e-mail et votre mot de passe, puis créez un nouveau PIN dans Profil.'**
  String get faq4A;

  /// No description provided for @writeSupport.
  ///
  /// In fr, this message translates to:
  /// **'Écrire au support'**
  String get writeSupport;

  /// No description provided for @yourHr.
  ///
  /// In fr, this message translates to:
  /// **'Votre RH'**
  String get yourHr;

  /// No description provided for @welcome.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue,'**
  String get welcome;

  /// No description provided for @emptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre assiette est encore vide'**
  String get emptyTitle;

  /// No description provided for @emptyText.
  ///
  /// In fr, this message translates to:
  /// **'Dès que {company} vous attribue un crédit, il apparaît ici et vous recevez une notification.'**
  String emptyText(Object company);

  /// No description provided for @enableNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Activer les notifications'**
  String get enableNotifications;

  /// No description provided for @enableNotificationsDetail.
  ///
  /// In fr, this message translates to:
  /// **'Pour savoir quand le crédit arrive'**
  String get enableNotificationsDetail;

  /// No description provided for @discoverMerchants.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir les commerces'**
  String get discoverMerchants;

  /// No description provided for @discoverMerchantsDetail.
  ///
  /// In fr, this message translates to:
  /// **'Où vous pourrez payer'**
  String get discoverMerchantsDetail;

  /// No description provided for @offlineBanner.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes hors ligne'**
  String get offlineBanner;

  /// No description provided for @updatedAt.
  ///
  /// In fr, this message translates to:
  /// **'Mis à jour à {time}'**
  String updatedAt(Object time);

  /// No description provided for @lastKnownBalance.
  ///
  /// In fr, this message translates to:
  /// **'Dernier solde connu'**
  String get lastKnownBalance;

  /// No description provided for @offlineTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le paiement a besoin d’Internet'**
  String get offlineTitle;

  /// No description provided for @offlineText.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez le Wi-Fi ou les données mobiles, puis réessayez.'**
  String get offlineText;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @proMerchantSpace.
  ///
  /// In fr, this message translates to:
  /// **'Espace commerçant'**
  String get proMerchantSpace;

  /// No description provided for @proLoginSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Propriétaire ou caissier : même écran, l’app s’adapte à votre rôle.'**
  String get proLoginSubtitle;

  /// No description provided for @proLoginHelp.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe perdu ? Demandez à votre propriétaire ou au support FlexiPay.'**
  String get proLoginHelp;

  /// No description provided for @cashRegisterOf.
  ///
  /// In fr, this message translates to:
  /// **'Caisse de {name}'**
  String cashRegisterOf(Object name);

  /// No description provided for @collectTitle.
  ///
  /// In fr, this message translates to:
  /// **'Encaisser'**
  String get collectTitle;

  /// No description provided for @scanQr.
  ///
  /// In fr, this message translates to:
  /// **'Scanner le QR'**
  String get scanQr;

  /// No description provided for @enterCode.
  ///
  /// In fr, this message translates to:
  /// **'Saisir le code'**
  String get enterCode;

  /// No description provided for @paymentApproved.
  ///
  /// In fr, this message translates to:
  /// **'Paiement approuvé'**
  String get paymentApproved;

  /// No description provided for @customerConfirmed.
  ///
  /// In fr, this message translates to:
  /// **'Le client a confirmé avec son PIN.'**
  String get customerConfirmed;

  /// No description provided for @paymentRefused.
  ///
  /// In fr, this message translates to:
  /// **'Paiement refusé'**
  String get paymentRefused;

  /// No description provided for @refusedFundsPro.
  ///
  /// In fr, this message translates to:
  /// **'Solde {type} insuffisant : il manque {amount}. Rien n’a été débité.'**
  String refusedFundsPro(Object type, Object amount);

  /// No description provided for @customerLabel.
  ///
  /// In fr, this message translates to:
  /// **'Client'**
  String get customerLabel;

  /// No description provided for @timeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Heure'**
  String get timeLabel;

  /// No description provided for @newCollection.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel encaissement'**
  String get newCollection;

  /// No description provided for @seeDay.
  ///
  /// In fr, this message translates to:
  /// **'Voir la journée'**
  String get seeDay;

  /// No description provided for @collectedToday.
  ///
  /// In fr, this message translates to:
  /// **'Encaissé aujourd’hui'**
  String get collectedToday;

  /// No description provided for @statCollections.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{encaissement} =1{encaissement} other{encaissements}}'**
  String statCollections(num count);

  /// No description provided for @averageBasket.
  ///
  /// In fr, this message translates to:
  /// **'panier moyen'**
  String get averageBasket;

  /// No description provided for @statRefusals.
  ///
  /// In fr, this message translates to:
  /// **'refus'**
  String get statRefusals;

  /// No description provided for @hourlyChart.
  ///
  /// In fr, this message translates to:
  /// **'Encaissements par heure'**
  String get hourlyChart;

  /// No description provided for @collections.
  ///
  /// In fr, this message translates to:
  /// **'Encaissements'**
  String get collections;

  /// No description provided for @filterByCashier.
  ///
  /// In fr, this message translates to:
  /// **'Filtrer par caissier'**
  String get filterByCashier;

  /// No description provided for @filterMe.
  ///
  /// In fr, this message translates to:
  /// **'Moi'**
  String get filterMe;

  /// No description provided for @familyTag.
  ///
  /// In fr, this message translates to:
  /// **'{name} (famille)'**
  String familyTag(Object name);

  /// No description provided for @refusedTag.
  ///
  /// In fr, this message translates to:
  /// **'{name} · refusé'**
  String refusedTag(Object name);

  /// No description provided for @ownerEmail.
  ///
  /// In fr, this message translates to:
  /// **'Propriétaire · {email}'**
  String ownerEmail(Object email);

  /// No description provided for @myBalance.
  ///
  /// In fr, this message translates to:
  /// **'Mon solde'**
  String get myBalance;

  /// No description provided for @toPayOut.
  ///
  /// In fr, this message translates to:
  /// **'À reverser'**
  String get toPayOut;

  /// No description provided for @availableTodayJ0.
  ///
  /// In fr, this message translates to:
  /// **'Disponible aujourd’hui (J+0)'**
  String get availableTodayJ0;

  /// No description provided for @ifRequestNow.
  ///
  /// In fr, this message translates to:
  /// **'Si vous demandez maintenant'**
  String get ifRequestNow;

  /// No description provided for @commissionRate.
  ///
  /// In fr, this message translates to:
  /// **'Commission {rate}'**
  String commissionRate(Object rate);

  /// No description provided for @vatRate.
  ///
  /// In fr, this message translates to:
  /// **'TVA {rate}'**
  String vatRate(Object rate);

  /// No description provided for @feesInclTax.
  ///
  /// In fr, this message translates to:
  /// **'Frais TTC'**
  String get feesInclTax;

  /// No description provided for @withholding.
  ///
  /// In fr, this message translates to:
  /// **'Retenue à la source'**
  String get withholding;

  /// No description provided for @withholdingNone.
  ///
  /// In fr, this message translates to:
  /// **'{amount} (frais sous {threshold})'**
  String withholdingNone(Object amount, Object threshold);

  /// No description provided for @stampDuty.
  ///
  /// In fr, this message translates to:
  /// **'Timbre'**
  String get stampDuty;

  /// No description provided for @transferFee.
  ///
  /// In fr, this message translates to:
  /// **'Frais de virement'**
  String get transferFee;

  /// No description provided for @youWillReceive.
  ///
  /// In fr, this message translates to:
  /// **'Vous recevrez'**
  String get youWillReceive;

  /// No description provided for @requestPayout.
  ///
  /// In fr, this message translates to:
  /// **'Demander le reversement'**
  String get requestPayout;

  /// No description provided for @payoutInfo.
  ///
  /// In fr, this message translates to:
  /// **'FlexiPay vire l’argent sur le RIB de votre dossier, puis vous envoie la référence bancaire.'**
  String get payoutInfo;

  /// No description provided for @transferTracking.
  ///
  /// In fr, this message translates to:
  /// **'Suivi des virements'**
  String get transferTracking;

  /// No description provided for @payoutsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Reversements'**
  String get payoutsTitle;

  /// No description provided for @requestRef.
  ///
  /// In fr, this message translates to:
  /// **'Demande {ref}'**
  String requestRef(Object ref);

  /// No description provided for @netOf.
  ///
  /// In fr, this message translates to:
  /// **'Net sur {amount} encaissés'**
  String netOf(Object amount);

  /// No description provided for @inProgress.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get inProgress;

  /// No description provided for @stepRequested.
  ///
  /// In fr, this message translates to:
  /// **'Demandé'**
  String get stepRequested;

  /// No description provided for @stepAcceptance.
  ///
  /// In fr, this message translates to:
  /// **'Acceptation par FlexiPay'**
  String get stepAcceptance;

  /// No description provided for @pending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get pending;

  /// No description provided for @stepPaid.
  ///
  /// In fr, this message translates to:
  /// **'Payé + référence bancaire'**
  String get stepPaid;

  /// No description provided for @upcoming.
  ///
  /// In fr, this message translates to:
  /// **'À venir'**
  String get upcoming;

  /// No description provided for @historySection.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get historySection;

  /// No description provided for @payoutPaid.
  ///
  /// In fr, this message translates to:
  /// **'{ref} · Payé'**
  String payoutPaid(Object ref);

  /// No description provided for @ownerOnly.
  ///
  /// In fr, this message translates to:
  /// **'Réservé au propriétaire'**
  String get ownerOnly;

  /// No description provided for @myTeam.
  ///
  /// In fr, this message translates to:
  /// **'Mon équipe'**
  String get myTeam;

  /// No description provided for @youOwner.
  ///
  /// In fr, this message translates to:
  /// **'Vous · Propriétaire'**
  String get youOwner;

  /// No description provided for @cashierRole.
  ///
  /// In fr, this message translates to:
  /// **'{name} · Caissier'**
  String cashierRole(Object name);

  /// No description provided for @activeLastAccess.
  ///
  /// In fr, this message translates to:
  /// **'Actif · dernier accès {time}'**
  String activeLastAccess(Object time);

  /// No description provided for @cashierActions.
  ///
  /// In fr, this message translates to:
  /// **'Actions sur un caissier'**
  String get cashierActions;

  /// No description provided for @cashierActionsText.
  ///
  /// In fr, this message translates to:
  /// **'Modifier, désactiver ou générer un nouveau mot de passe (affiché une seule fois).'**
  String get cashierActionsText;

  /// No description provided for @addCashier.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un caissier'**
  String get addCashier;

  /// No description provided for @newCashier.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau caissier'**
  String get newCashier;

  /// No description provided for @fullNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Prénom et nom'**
  String get fullNameLabel;

  /// No description provided for @tempPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe temporaire (affiché une seule fois)'**
  String get tempPassword;

  /// No description provided for @createCashier.
  ///
  /// In fr, this message translates to:
  /// **'Créer le caissier'**
  String get createCashier;

  /// No description provided for @catalogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Catalogue des composants'**
  String get catalogTitle;

  /// No description provided for @catalogDemo.
  ///
  /// In fr, this message translates to:
  /// **'Démonstration'**
  String get catalogDemo;

  /// No description provided for @catalogOffline.
  ///
  /// In fr, this message translates to:
  /// **'Simuler la perte de réseau'**
  String get catalogOffline;

  /// No description provided for @payNfcTitle.
  ///
  /// In fr, this message translates to:
  /// **'Approchez votre téléphone de l\'autocollant FlexiPay'**
  String get payNfcTitle;

  /// No description provided for @payNfcHint.
  ///
  /// In fr, this message translates to:
  /// **'Le montant s\'affiche ensuite : vous confirmez avec votre PIN.'**
  String get payNfcHint;

  /// No description provided for @payNfcUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'NFC indisponible sur ce téléphone : scannez le QR ou tapez le code de la caisse.'**
  String get payNfcUnavailable;

  /// No description provided for @payScanQr.
  ///
  /// In fr, this message translates to:
  /// **'Scanner le QR'**
  String get payScanQr;

  /// No description provided for @payTypeCode.
  ///
  /// In fr, this message translates to:
  /// **'Taper le code de la caisse'**
  String get payTypeCode;

  /// No description provided for @payScanTitle.
  ///
  /// In fr, this message translates to:
  /// **'Scannez le QR de l\'autocollant'**
  String get payScanTitle;

  /// No description provided for @payCodeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Code de la caisse'**
  String get payCodeTitle;

  /// No description provided for @payCodeHint.
  ///
  /// In fr, this message translates to:
  /// **'4 chiffres affichés à la caisse'**
  String get payCodeHint;

  /// No description provided for @payStickerRead.
  ///
  /// In fr, this message translates to:
  /// **'Autocollant lu'**
  String get payStickerRead;

  /// No description provided for @registerAtCity.
  ///
  /// In fr, this message translates to:
  /// **'{register} · {city}'**
  String registerAtCity(Object register, Object city);

  /// No description provided for @refusedPaidTitle.
  ///
  /// In fr, this message translates to:
  /// **'Déjà payée'**
  String get refusedPaidTitle;

  /// No description provided for @refusedPaidMessage.
  ///
  /// In fr, this message translates to:
  /// **'Un autre client a déjà payé cette demande.'**
  String get refusedPaidMessage;

  /// No description provided for @refusedStickerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Autocollant invalide'**
  String get refusedStickerTitle;

  /// No description provided for @refusedStickerMessage.
  ///
  /// In fr, this message translates to:
  /// **'Cet autocollant n\'est pas reconnu par FlexiPay.'**
  String get refusedStickerMessage;

  /// No description provided for @refusedNoPendingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune demande en caisse'**
  String get refusedNoPendingTitle;

  /// No description provided for @refusedNoPendingMessage.
  ///
  /// In fr, this message translates to:
  /// **'Demandez au caissier de saisir le montant, puis réessayez.'**
  String get refusedNoPendingMessage;

  /// No description provided for @refusedFamilyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Plafond du jour atteint'**
  String get refusedFamilyTitle;

  /// No description provided for @refusedFamilyMessage.
  ///
  /// In fr, this message translates to:
  /// **'Il vous reste {amount} pour aujourd\'hui.'**
  String refusedFamilyMessage(Object amount);

  /// No description provided for @refusedTryAgain.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get refusedTryAgain;

  /// No description provided for @refusedNothingDebited.
  ///
  /// In fr, this message translates to:
  /// **'Aucun montant n\'a été débité.'**
  String get refusedNothingDebited;

  /// No description provided for @requestPayment.
  ///
  /// In fr, this message translates to:
  /// **'Demander {amount}'**
  String requestPayment(Object amount);

  /// No description provided for @waitingCustomer.
  ///
  /// In fr, this message translates to:
  /// **'En attente du client…'**
  String get waitingCustomer;

  /// No description provided for @waitingHint.
  ///
  /// In fr, this message translates to:
  /// **'Le client approche son téléphone de l\'autocollant, scanne le QR ou tape ce code.'**
  String get waitingHint;

  /// No description provided for @shortCodeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Code de la caisse'**
  String get shortCodeLabel;

  /// No description provided for @cancelRequest.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la demande'**
  String get cancelRequest;

  /// No description provided for @requestExpiredTitle.
  ///
  /// In fr, this message translates to:
  /// **'Demande expirée'**
  String get requestExpiredTitle;

  /// No description provided for @requestCancelledTitle.
  ///
  /// In fr, this message translates to:
  /// **'Demande annulée'**
  String get requestCancelledTitle;

  /// No description provided for @newRequest.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle demande'**
  String get newRequest;

  /// No description provided for @paidByCustomer.
  ///
  /// In fr, this message translates to:
  /// **'Payé par {name}'**
  String paidByCustomer(Object name);

  /// No description provided for @refusedForCustomer.
  ///
  /// In fr, this message translates to:
  /// **'Refusé pour {name}'**
  String refusedForCustomer(Object name);

  /// No description provided for @tillRefusalFunds.
  ///
  /// In fr, this message translates to:
  /// **'Solde insuffisant. Rien n\'a été débité.'**
  String get tillRefusalFunds;

  /// No description provided for @tillRefusalLimit.
  ///
  /// In fr, this message translates to:
  /// **'Plafond du jour atteint. Rien n\'a été débité.'**
  String get tillRefusalLimit;

  /// No description provided for @tillRefusalOther.
  ///
  /// In fr, this message translates to:
  /// **'Paiement refusé. Rien n\'a été débité.'**
  String get tillRefusalOther;

  /// No description provided for @registersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes caisses'**
  String get registersTitle;

  /// No description provided for @registerSticker.
  ///
  /// In fr, this message translates to:
  /// **'Associer un autocollant'**
  String get registerSticker;

  /// No description provided for @stickerApproach.
  ///
  /// In fr, this message translates to:
  /// **'Approchez l\'autocollant NFC du téléphone'**
  String get stickerApproach;

  /// No description provided for @stickerApproachHint.
  ///
  /// In fr, this message translates to:
  /// **'Le lien de {register} y sera écrit.'**
  String stickerApproachHint(Object register);

  /// No description provided for @stickerWritten.
  ///
  /// In fr, this message translates to:
  /// **'Autocollant associé à {register}'**
  String stickerWritten(Object register);

  /// No description provided for @stickerWriteFailed.
  ///
  /// In fr, this message translates to:
  /// **'Écriture impossible. Réessayez avec un autocollant NFC vierge.'**
  String get stickerWriteFailed;

  /// No description provided for @registerDisabled.
  ///
  /// In fr, this message translates to:
  /// **'Désactivée'**
  String get registerDisabled;

  /// No description provided for @myRegister.
  ///
  /// In fr, this message translates to:
  /// **'Ma caisse'**
  String get myRegister;

  /// No description provided for @catalogNextCustomer.
  ///
  /// In fr, this message translates to:
  /// **'Prochain client'**
  String get catalogNextCustomer;
}

class _FpL10nDelegate extends LocalizationsDelegate<FpL10n> {
  const _FpL10nDelegate();

  @override
  Future<FpL10n> load(Locale locale) {
    return SynchronousFuture<FpL10n>(lookupFpL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_FpL10nDelegate old) => false;
}

FpL10n lookupFpL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return FpL10nAr();
    case 'en':
      return FpL10nEn();
    case 'fr':
      return FpL10nFr();
  }

  throw FlutterError(
    'FpL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
