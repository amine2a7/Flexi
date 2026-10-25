// Textes communs : [fr, en, ar].
module.exports = {
  "app": {
    "name": "FlexiPay"
  },
  "language": {
    "fr": "Français",
    "ar": "العربية",
    "en": "English",
    "short": {
      "fr": "FR",
      "ar": "ع",
      "en": "EN"
    }
  },
  "shell": {
    "placeholder": {
      "title": [
        "Squelette de l'application",
        "Application skeleton",
        "هيكل التطبيق"
      ],
      "message": [
        "Les écrans seront ajoutés espace par espace.",
        "Screens will be added space by space.",
        "ستُضاف الشاشات فضاءً تلو الآخر."
      ]
    }
  },
  "common": {
    "button": {
      "retry": [
        "Réessayer",
        "Try again",
        "إعادة المحاولة"
      ],
      "cancel": [
        "Annuler",
        "Cancel",
        "إلغاء"
      ]
    },
    "state": {
      "loading": [
        "Chargement…",
        "Loading…",
        "جارٍ التحميل…"
      ],
      "error": {
        "title": [
          "Une erreur est survenue",
          "Something went wrong",
          "حدث خطأ"
        ],
        "message": [
          "Nous n'avons pas pu charger ces informations.",
          "We could not load this information.",
          "تعذّر تحميل هذه المعلومات."
        ]
      },
      "notFound": {
        "title": [
          "Introuvable",
          "Not found",
          "غير موجود"
        ],
        "action": [
          "Retour à l'accueil",
          "Back to home",
          "العودة إلى الصفحة الرئيسية"
        ]
      }
    }
  },
  "errors": {
    "notFound": [
      "Cette page ou cette ressource est introuvable.",
      "This page or resource cannot be found.",
      "هذه الصفحة أو هذا المورد غير موجود."
    ],
    "validationFailed": [
      "Vérifiez les champs signalés.",
      "Check the highlighted fields.",
      "تحقّق من الحقول المشار إليها."
    ],
    "unauthenticated": [
      "Votre session a pris fin. Reconnectez-vous.",
      "Your session has ended. Please sign in again.",
      "انتهت جلستك. يرجى تسجيل الدخول من جديد."
    ],
    "sessionExpired": [
      "Votre session a expiré. Reconnectez-vous.",
      "Your session has expired. Please sign in again.",
      "انتهت صلاحية جلستك. يرجى تسجيل الدخول من جديد."
    ],
    "invalidCredentials": [
      "Identifiant ou mot de passe incorrect.",
      "Incorrect identifier or password.",
      "المعرّف أو كلمة المرور غير صحيحة."
    ],
    "mfaCodeInvalid": [
      "Code incorrect. Vérifiez le code affiché par votre application.",
      "Incorrect code. Check the code shown in your app.",
      "الرمز غير صحيح. تحقّق من الرمز المعروض في تطبيقك."
    ],
    "mfaChallengeExpired": [
      "La vérification a expiré. Reconnectez-vous.",
      "Verification has expired. Please sign in again.",
      "انتهت مهلة التحقق. يرجى تسجيل الدخول من جديد."
    ],
    "forbidden": [
      "Vous n'avez pas les droits pour cette action.",
      "You are not allowed to do this.",
      "ليست لديك صلاحية لهذا الإجراء."
    ],
    "resourceStateConflict": [
      "L'élément a changé entre-temps. Rechargez la page puis réessayez.",
      "This item has changed in the meantime. Reload the page and try again.",
      "تغيّر هذا العنصر في الأثناء. أعد تحميل الصفحة ثم حاول مجددًا."
    ],
    "insufficientFunds": [
      "Solde insuffisant pour cette opération.",
      "Insufficient balance for this operation.",
      "الرصيد غير كافٍ لهذه العملية."
    ],
    "limitExceeded": [
      "Plafond dépassé pour cette opération.",
      "Limit exceeded for this operation.",
      "تمّ تجاوز السقف لهذه العملية."
    ],
    "paymentDeclined": [
      "Paiement refusé. Le client peut vérifier son application.",
      "Payment declined. The customer can check their app.",
      "تمّ رفض الدفع. يمكن للعميل التحقق من تطبيقه."
    ],
    "rateLimited": [
      "Trop de tentatives. Patientez quelques instants puis réessayez.",
      "Too many attempts. Wait a moment and try again.",
      "محاولات كثيرة جدًا. انتظر قليلًا ثم حاول مجددًا."
    ],
    "internalError": [
      "Le service a rencontré un problème. Réessayez dans quelques instants.",
      "The service ran into a problem. Try again in a moment.",
      "واجهت الخدمة مشكلة. حاول مجددًا بعد قليل."
    ],
    "serviceUnavailable": [
      "Service momentanément indisponible. Réessayez plus tard.",
      "Service temporarily unavailable. Try again later.",
      "الخدمة غير متاحة مؤقتًا. حاول لاحقًا."
    ],
    "network": [
      "Connexion impossible. Vérifiez votre réseau puis réessayez.",
      "Cannot connect. Check your network and try again.",
      "تعذّر الاتصال. تحقّق من الشبكة ثم حاول مجددًا."
    ],
    "generic": [
      "L'opération n'a pas abouti. Réessayez.",
      "The operation did not go through. Try again.",
      "لم تكتمل العملية. حاول مجددًا."
    ],
    "pinInvalid": [
      "PIN incorrect.",
      "Wrong PIN.",
      "الرمز السري غير صحيح."
    ],
    "pinLocked": [
      "PIN bloqué après 3 essais : réessayez dans 15 minutes.",
      "PIN locked after 3 attempts: try again in 15 minutes.",
      "الرمز السري مقفل بعد 3 محاولات: أعد المحاولة بعد 15 دقيقة."
    ]
  },
  "ui": {
    "amount": {
      "credit": [
        "{amount} au crédit",
        "{amount} credit",
        "{amount} دائن"
      ],
      "debit": [
        "{amount} au débit",
        "{amount} debit",
        "{amount} مدين"
      ]
    },
    "table": {
      "count": [
        "{count, plural, one {# résultat} other {# résultats}}",
        "{count, plural, one {# result} other {# results}}",
        "{count, plural, one {# نتيجة} other {# نتائج}}"
      ],
      "countMore": [
        "Plus de {count} résultats",
        "More than {count} results",
        "أكثر من {count} نتيجة"
      ],
      "pagination": [
        "Pagination",
        "Pagination",
        "التنقل بين الصفحات"
      ],
      "previous": [
        "Précédent",
        "Previous",
        "السابق"
      ],
      "next": [
        "Suivant",
        "Next",
        "التالي"
      ],
      "page": [
        "Page {page}",
        "Page {page}",
        "الصفحة {page}"
      ],
      "sortBy": [
        "Trier par {column}",
        "Sort by {column}",
        "الترتيب حسب {column}"
      ]
    },
    "modal": {
      "close": [
        "Fermer",
        "Close",
        "إغلاق"
      ]
    },
    "countdown": {
      "label": [
        "Temps restant",
        "Time left",
        "الوقت المتبقي"
      ],
      "left": [
        "{seconds} s restantes",
        "{seconds} s left",
        "متبقٍ {seconds} ث"
      ],
      "expired": [
        "Délai dépassé",
        "Time is up",
        "انتهت المهلة"
      ]
    },
    "filters": {
      "apply": [
        "Filtrer",
        "Filter",
        "تصفية"
      ],
      "reset": [
        "Réinitialiser",
        "Reset",
        "إعادة التعيين"
      ],
      "allStatuses": [
        "Tous les statuts",
        "All statuses",
        "كل الحالات"
      ],
      "creditType": [
        "Type de crédit",
        "Credit type",
        "نوع الرصيد"
      ],
      "allTypes": [
        "Tous les types",
        "All types",
        "كل الأنواع"
      ]
    },
    "chart": {
      "empty": [
        "Aucune donnée sur la période.",
        "No data for this period.",
        "لا توجد بيانات لهذه الفترة."
      ],
      "data": [
        "Données du graphique : {title}",
        "Chart data: {title}",
        "بيانات الرسم البياني: {title}"
      ],
      "month": [
        "Mois",
        "Month",
        "الشهر"
      ]
    },
    "todo": {
      "title": [
        "À faire",
        "To do",
        "مهام"
      ],
      "empty": [
        "Rien à faire pour le moment.",
        "Nothing to do for now.",
        "لا شيء للقيام به حاليًا."
      ]
    },
    "file": {
      "loading": [
        "Chargement du fichier…",
        "Loading the file…",
        "جارٍ تحميل الملف…"
      ],
      "error": [
        "Le fichier n'a pas pu être chargé.",
        "The file could not be loaded.",
        "تعذّر تحميل الملف."
      ],
      "download": [
        "Télécharger",
        "Download",
        "تنزيل"
      ],
      "pdf": [
        "Document PDF : téléchargez-le pour le consulter.",
        "PDF document: download it to view it.",
        "مستند PDF: نزّله للاطلاع عليه."
      ],
      "size": [
        "{name} · {size} Ko",
        "{name} · {size} KB",
        "{name} · {size} ك.ب"
      ]
    },
    "creditTypes": {
      "column": [
        "Type",
        "Type",
        "النوع"
      ],
      "balanceOf": [
        "Solde {type}",
        "{type} balance",
        "رصيد {type}"
      ],
      "total": [
        "Total, à titre indicatif",
        "Total, for information",
        "المجموع، للعلم فقط"
      ],
      "share": [
        "{percent} %",
        "{percent}%",
        "{percent} %"
      ],
      "breakdownTitle": [
        "Répartition par type",
        "Breakdown by type",
        "التوزيع حسب النوع"
      ],
      "breakdownEmpty": [
        "Aucun montant sur la période.",
        "No amount for this period.",
        "لا مبالغ لهذه الفترة."
      ],
      "disabled": [
        "Désactivé",
        "Disabled",
        "معطّل"
      ],
      "accepted": [
        "Types acceptés",
        "Accepted types",
        "الأنواع المقبولة"
      ],
      "pickOne": [
        "Choisissez au moins un type.",
        "Choose at least one type.",
        "اختر نوعًا واحدًا على الأقل."
      ],
      "limitUsed": [
        "{spent} dépensés aujourd'hui sur {limit}",
        "{spent} spent today out of {limit}",
        "صُرف {spent} اليوم من أصل {limit}"
      ],
      "noTransfer": [
        "Chaque type a son propre solde : aucun transfert ni paiement entre types.",
        "Each type has its own balance: no transfer or payment between types.",
        "لكل نوع رصيده الخاص: لا تحويل ولا دفع بين الأنواع."
      ],
      "insufficient": [
        "Solde {type} insuffisant : il manque {missing}.",
        "Not enough {type} balance: {missing} missing.",
        "رصيد {type} غير كافٍ: ينقص {missing}."
      ]
    },
    "amountField": {
      "hint": [
        "Exemple : 18,500",
        "Example: 18.500",
        "مثال: 18,500"
      ],
      "preview": [
        "Montant lu : {amount}",
        "Amount read: {amount}",
        "المبلغ المقروء: {amount}"
      ],
      "invalid": [
        "Montant invalide : chiffres et séparateur décimal, 3 décimales au plus.",
        "Invalid amount: digits and decimal separator, 3 decimals at most.",
        "مبلغ غير صالح: أرقام وفاصل عشري، 3 أرقام عشرية على الأكثر."
      ]
    }
  },
  "layout": {
    "mainNav": [
      "Navigation principale",
      "Main navigation",
      "التنقل الرئيسي"
    ],
    "openMenu": [
      "Ouvrir le menu",
      "Open menu",
      "فتح القائمة"
    ],
    "closeMenu": [
      "Fermer le menu",
      "Close menu",
      "إغلاق القائمة"
    ],
    "signOut": [
      "Se déconnecter",
      "Sign out",
      "تسجيل الخروج"
    ],
    "space": {
      "ADMIN": [
        "Administration",
        "Administration",
        "الإدارة"
      ],
      "COMPANY": [
        "Espace entreprise",
        "Company space",
        "فضاء المؤسسة"
      ],
      "MERCHANT": [
        "Espace commerçant",
        "Merchant space",
        "فضاء التاجر"
      ],
      "EMPLOYEE": [
        "Espace bénéficiaire",
        "Beneficiary space",
        "فضاء المستفيد"
      ],
      "FAMILY_MEMBER": [
        "Espace famille",
        "Family space",
        "فضاء العائلة"
      ]
    },
    "forbidden": {
      "title": [
        "Accès refusé",
        "Access denied",
        "الدخول مرفوض"
      ],
      "message": [
        "Cet espace n'est pas accessible avec votre compte.",
        "This space is not available with your account.",
        "هذا الفضاء غير متاح لحسابك."
      ],
      "action": [
        "Aller à mon espace",
        "Go to my space",
        "الانتقال إلى فضائي"
      ]
    },
    "pageForbidden": {
      "title": [
        "Accès refusé",
        "Access denied",
        "الدخول مرفوض"
      ],
      "message": [
        "Votre rôle ne donne pas accès à cette page.",
        "Your role does not give access to this page.",
        "دورك لا يتيح الوصول إلى هذه الصفحة."
      ],
      "action": [
        "Retour à l'accueil",
        "Back to home",
        "العودة إلى الصفحة الرئيسية"
      ]
    },
    "session": {
      "warningTitle": [
        "Votre session va expirer",
        "Your session is about to expire",
        "جلستك على وشك الانتهاء"
      ],
      "warningMessage": [
        "Sans activité, vous serez déconnecté dans 2 minutes. Voulez-vous rester connecté ?",
        "Without activity, you will be signed out in 2 minutes. Do you want to stay signed in?",
        "في غياب أي نشاط، سيتم تسجيل خروجك خلال دقيقتين. هل تريد البقاء متصلًا؟"
      ],
      "stay": [
        "Rester connecté",
        "Stay signed in",
        "البقاء متصلًا"
      ],
      "signOut": [
        "Se déconnecter",
        "Sign out",
        "تسجيل الخروج"
      ]
    },
    "tagline": [
      "Plateforme digitale",
      "Digital platform",
      "منصة رقمية"
    ],
    "hello": [
      "Bonjour, {name}",
      "Hello, {name}",
      "مرحبًا، {name}"
    ],
    "secure": [
      "Espace sécurisé · {tenant}",
      "Secure space · {tenant}",
      "فضاء آمن · {tenant}"
    ],
    "activeAccount": [
      "Compte actif",
      "Active account",
      "حساب نشِط"
    ],
    "role": {
      "ADMIN": [
        "Administrateur",
        "Administrator",
        "مشرف"
      ],
      "COMPANY": [
        "Entreprise",
        "Company",
        "مؤسسة"
      ],
      "MERCHANT": [
        "Commerçant",
        "Merchant",
        "تاجر"
      ],
      "EMPLOYEE": [
        "Bénéficiaire",
        "Beneficiary",
        "مستفيد"
      ],
      "FAMILY_MEMBER": [
        "Membre de la famille",
        "Family member",
        "فرد من العائلة"
      ]
    },
    "eyebrow": {
      "ADMIN": [
        "Pilotage de la plateforme",
        "Platform management",
        "قيادة المنصة"
      ],
      "COMPANY": [
        "Entreprise cliente",
        "Client company",
        "مؤسسة حريفة"
      ],
      "MERCHANT": [
        "Commerçant partenaire",
        "Partner merchant",
        "تاجر شريك"
      ],
      "EMPLOYEE": [
        "Bénéficiaire",
        "Beneficiary",
        "مستفيد"
      ],
      "FAMILY_MEMBER": [
        "Famille",
        "Family",
        "العائلة"
      ]
    },
    "counter": [
      "{label} : {count} en attente",
      "{label}: {count} pending",
      "{label}: {count} في الانتظار"
    ],
    "help": [
      "Aide",
      "Help",
      "المساعدة"
    ],
    "helpCentre": [
      "Centre d’aide",
      "Help centre",
      "مركز المساعدة"
    ],
    "replayTour": [
      "Revoir la visite guidée",
      "Replay the guided tour",
      "إعادة الجولة الإرشادية"
    ]
  },
  "nav": {
    "skip": [
      "Aller au contenu principal",
      "Skip to main content",
      "الانتقال إلى المحتوى الرئيسي"
    ],
    "language": [
      "Langue",
      "Language",
      "اللغة"
    ],
    "merchant": {
      "dashboard": [
        "Tableau de bord",
        "Dashboard",
        "لوحة القيادة"
      ],
      "collect": [
        "Encaisser",
        "Collect",
        "تحصيل"
      ],
      "history": [
        "Historique",
        "History",
        "السجل"
      ],
      "receivables": [
        "Créances",
        "Receivables",
        "المستحقات"
      ],
      "payouts": [
        "Virements",
        "Payouts",
        "التحويلات"
      ],
      "settlements": [
        "Règlements",
        "Settlements",
        "التسويات"
      ],
      "shop": [
        "Mon commerce",
        "My shop",
        "محلّي"
      ]
    },
    "company": {
      "dashboard": [
        "Tableau de bord",
        "Dashboard",
        "لوحة القيادة"
      ],
      "employees": [
        "Employés",
        "Employees",
        "الموظفون"
      ],
      "orders": [
        "Commandes",
        "Orders",
        "الطلبيات"
      ],
      "allocation": [
        "Attribution",
        "Allocation",
        "التوزيع"
      ],
      "invoices": [
        "Factures",
        "Invoices",
        "الفواتير"
      ]
    },
    "admin": {
      "dashboard": [
        "Supervision",
        "Overview",
        "الإشراف"
      ],
      "merchants": [
        "Commerçants",
        "Merchants",
        "التجار"
      ],
      "companies": [
        "Entreprises",
        "Companies",
        "المؤسسات"
      ],
      "orders": [
        "Commandes",
        "Orders",
        "الطلبيات"
      ],
      "commissions": [
        "Commissions",
        "Commissions",
        "العمولات"
      ],
      "approvals": [
        "Validations",
        "Approvals",
        "المصادقات"
      ],
      "settlements": [
        "Règlements",
        "Settlements",
        "التسويات"
      ],
      "audit": [
        "Journal d'audit",
        "Audit log",
        "سجل التدقيق"
      ],
      "settings": [
        "Paramétrage",
        "Settings",
        "الإعدادات"
      ],
      "kyc": [
        "Dossiers KYC",
        "KYC files",
        "ملفات التحقق"
      ],
      "payouts": [
        "Virements commerçants",
        "Merchant payouts",
        "تحويلات التجار"
      ],
      "transactions": [
        "Transactions",
        "Transactions",
        "المعاملات"
      ],
      "messages": [
        "Messages",
        "Messages",
        "الرسائل"
      ]
    },
    "beneficiary": {
      "home": [
        "Accueil",
        "Home",
        "الرئيسية"
      ],
      "pay": [
        "Payer",
        "Pay",
        "دفع"
      ],
      "history": [
        "Historique",
        "History",
        "السجل"
      ],
      "profile": [
        "Profil",
        "Profile",
        "الملف"
      ],
      "security": [
        "Sécurité",
        "Security",
        "الأمان"
      ]
    }
  },
  "status": {
    "EN_ATTENTE": [
      "En attente",
      "Pending",
      "قيد الانتظار"
    ],
    "VALIDE": [
      "Validé",
      "Approved",
      "مصادق عليه"
    ],
    "A_REGLER": [
      "À régler",
      "To be settled",
      "للتسوية"
    ],
    "REGLE": [
      "Réglé",
      "Settled",
      "تمّت التسوية"
    ],
    "REFUSE": [
      "Refusé",
      "Declined",
      "مرفوض"
    ],
    "SUSPENDU": [
      "Suspendu",
      "Suspended",
      "معلّق"
    ],
    "EN_LITIGE": [
      "En litige",
      "Disputed",
      "محل نزاع"
    ],
    "EXPIRE": [
      "Expiré",
      "Expired",
      "منتهي الصلاحية"
    ],
    "SUSPECT": [
      "Suspect",
      "Suspicious",
      "مشبوه"
    ],
    "EN_ATTENTE_KYC": [
      "En attente KYC",
      "Pending KYC",
      "في انتظار التحقق من الهوية"
    ],
    "REJETE": [
      "Rejeté",
      "Rejected",
      "مرفوض"
    ],
    "CREEE": [
      "Créée",
      "Created",
      "مُنشأة"
    ],
    "PAYEE": [
      "Payée",
      "Paid",
      "مدفوعة"
    ],
    "RAPPROCHEE": [
      "Rapprochée",
      "Reconciled",
      "مطابَقة"
    ],
    "CREDITEE": [
      "Créditée",
      "Credited",
      "مُضافة إلى الرصيد"
    ],
    "ANNULEE": [
      "Annulée",
      "Cancelled",
      "ملغاة"
    ],
    "INITIE": [
      "Initié",
      "Initiated",
      "قيد البدء"
    ],
    "CONFIRME": [
      "Confirmé",
      "Confirmed",
      "مؤكَّد"
    ],
    "DEMANDEE": [
      "Demandée",
      "Requested",
      "مطلوبة"
    ],
    "CONTROLEE": [
      "Contrôlée",
      "Checked",
      "مُراجَعة"
    ],
    "ENVOYEE": [
      "Envoyée",
      "Sent",
      "مُرسلة"
    ],
    "EXECUTEE": [
      "Exécutée",
      "Executed",
      "منفَّذة"
    ],
    "REJETEE": [
      "Rejetée",
      "Rejected",
      "مرفوضة"
    ],
    "APPROUVEE": [
      "Approuvée",
      "Approved",
      "مصادق عليها"
    ],
    "INCONNU": [
      "Statut inconnu",
      "Unknown status",
      "حالة غير معروفة"
    ],
    "REFUSEE": [
      "Refusée",
      "Declined",
      "مرفوضة"
    ]
  },
  "statusLabel": {
    "INITIATED": [
      "Initié",
      "Initiated",
      "قيد البدء"
    ],
    "CONFIRMED": [
      "Confirmé",
      "Confirmed",
      "مؤكَّد"
    ],
    "SETTLED": [
      "Réglé",
      "Settled",
      "تمّت التسوية"
    ],
    "REFUSED": [
      "Refusé",
      "Declined",
      "مرفوض"
    ],
    "DISPUTED": [
      "En litige",
      "Disputed",
      "محل نزاع"
    ],
    "REQUESTED": [
      "Demandée",
      "Requested",
      "مطلوبة"
    ],
    "CHECKED": [
      "Contrôlée",
      "Checked",
      "مُراجَعة"
    ],
    "SENT": [
      "Envoyée",
      "Sent",
      "مُرسلة"
    ],
    "EXECUTED": [
      "Exécutée",
      "Executed",
      "منفَّذة"
    ],
    "REJECTED": [
      "Rejeté",
      "Rejected",
      "مرفوض"
    ],
    "CREATED": [
      "Créée",
      "Created",
      "مُنشأة"
    ],
    "PAID": [
      "Payée",
      "Paid",
      "مدفوعة"
    ],
    "RECONCILED": [
      "Rapprochée",
      "Reconciled",
      "مطابَقة"
    ],
    "CREDITED": [
      "Créditée",
      "Credited",
      "مُضافة إلى الرصيد"
    ],
    "CANCELLED": [
      "Annulée",
      "Cancelled",
      "ملغاة"
    ],
    "PENDING_KYC": [
      "En attente KYC",
      "Pending KYC",
      "في انتظار التحقق من الهوية"
    ],
    "APPROVED": [
      "Validé",
      "Approved",
      "مصادق عليه"
    ],
    "SUSPENDED": [
      "Suspendu",
      "Suspended",
      "معلّق"
    ],
    "INVITED": [
      "Invité",
      "Invited",
      "مدعو"
    ],
    "ACTIVE": [
      "Actif",
      "Active",
      "نشِط"
    ],
    "PENDING": [
      "En attente",
      "Pending",
      "قيد الانتظار"
    ],
    "merchantReceivable": [
      "En attente de règlement",
      "Awaiting settlement",
      "في انتظار التسوية"
    ]
  },
  "category": {
    "RESTAURANT": [
      "Restaurant",
      "Restaurant",
      "مطعم"
    ],
    "CAFE": [
      "Café",
      "Café",
      "مقهى"
    ],
    "GROCERY": [
      "Supérette",
      "Grocery",
      "محلّ مواد غذائية"
    ],
    "BAKERY": [
      "Boulangerie-pâtisserie",
      "Bakery",
      "مخبزة ومرطبات"
    ],
    "FAST_FOOD": [
      "Restauration rapide",
      "Fast food",
      "أكلة سريعة"
    ],
    "CLOTHING": [
      "Habillement",
      "Clothing",
      "ملابس"
    ],
    "FUEL_STATION": [
      "Station-service",
      "Fuel station",
      "محطة وقود"
    ],
    "GIFT_SHOP": [
      "Cadeaux et librairie",
      "Gifts and books",
      "هدايا ومكتبة"
    ]
  },
  "subRole": {
    "SUPER_ADMIN": [
      "Super administrateur",
      "Super administrator",
      "مشرف عام"
    ],
    "FINANCE": [
      "Finance",
      "Finance",
      "المالية"
    ],
    "SUPPORT": [
      "Support",
      "Support",
      "الدعم"
    ],
    "COMPLIANCE": [
      "Conformité",
      "Compliance",
      "الامتثال"
    ],
    "OWNER": [
      "Propriétaire",
      "Owner",
      "المالك"
    ],
    "MANAGER": [
      "Gestionnaire",
      "Manager",
      "المسيّر"
    ],
    "ACCOUNTANT": [
      "Comptable",
      "Accountant",
      "المحاسب"
    ],
    "READ_ONLY": [
      "Lecture seule",
      "Read only",
      "قراءة فقط"
    ],
    "CASHIER": [
      "Caissier",
      "Cashier",
      "أمين الصندوق"
    ]
  },
  "dev": {
    "accounts": {
      "title": [
        "Comptes de démonstration (développement)",
        "Demo accounts (development)",
        "حسابات تجريبية (تطوير)"
      ],
      "hint": [
        "Code MFA de tous les comptes : {code}",
        "MFA code for every account: {code}",
        "رمز التحقق لكل الحسابات: {code}"
      ],
      "admin": [
        "Administrateur",
        "Administrator",
        "مشرف"
      ],
      "company": [
        "Entreprise",
        "Company",
        "مؤسسة"
      ],
      "merchant": [
        "Commerçant",
        "Merchant",
        "تاجر"
      ],
      "firstLogin": [
        "Première connexion",
        "First sign-in",
        "أول تسجيل دخول"
      ],
      "admin2": [
        "Administrateur (2e validation)",
        "Administrator (second approval)",
        "مشرف (المصادقة الثانية)"
      ],
      "beneficiary": [
        "Bénéficiaire (employé)",
        "Beneficiary (employee)",
        "مستفيد (موظف)"
      ]
    },
    "codes": {
      "title": [
        "Codes clients de démonstration",
        "Demo customer codes",
        "رموز عملاء تجريبية"
      ],
      "confirmed": [
        "Confirmé par le client après 4 s",
        "Confirmed by the customer after 4 s",
        "يؤكده العميل بعد 4 ث"
      ],
      "refused": [
        "Refusé par le client",
        "Declined by the customer",
        "يرفضه العميل"
      ],
      "declined": [
        "Refusé immédiatement",
        "Declined at once",
        "مرفوض فورًا"
      ],
      "serverError": [
        "Erreur serveur",
        "Server error",
        "خطأ في الخادم"
      ],
      "scenarios": [
        "Ajoutez ?mock=slow, ?mock=error ou ?mock=empty à l'adresse pour tester un chargement lent, une erreur ou une liste vide.",
        "Add ?mock=slow, ?mock=error or ?mock=empty to the address to test slow loading, an error or an empty list.",
        "أضف ‎?mock=slow أو ‎?mock=error أو ‎?mock=empty إلى العنوان لاختبار تحميل بطيء أو خطأ أو قائمة فارغة."
      ]
    }
  },
  "creditType": {
    "RESTAURATION": [
      "Restauration",
      "Food",
      "المطاعم"
    ],
    "HABILLEMENT": [
      "Habillement",
      "Clothing",
      "الملابس"
    ],
    "CARBURANT": [
      "Carburant",
      "Fuel",
      "المحروقات"
    ],
    "CADEAUX": [
      "Cadeaux",
      "Gifts",
      "الهدايا"
    ]
  }
};
