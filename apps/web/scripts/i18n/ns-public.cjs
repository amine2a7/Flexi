// Public pages (landing, contact, help), onboarding tour, admin "Messages". [fr, en, ar] per leaf.
module.exports = {
  landing: {
    metaTitle: ['FlexiPay — avantages salariés dématérialisés', 'FlexiPay — digital employee benefits', 'FlexiPay — مزايا الموظفين الرقمية'],
    nav: {
      how: ['Comment ça marche', 'How it works', 'كيف يعمل'],
      benefits: ['Avantages', 'Benefits', 'المزايا'],
      contact: ['Nous contacter', 'Contact us', 'اتصل بنا'],
      help: ['Aide', 'Help', 'المساعدة'],
      signIn: ['Se connecter', 'Sign in', 'تسجيل الدخول'],
      label: ['Navigation du site', 'Site navigation', 'تصفح الموقع'],
    },
    hero: {
      eyebrow: ['Tickets-restaurant et avantages dématérialisés', 'Digital meal vouchers and benefits', 'تذاكر مطاعم ومزايا رقمية'],
      title: ['Les avantages de vos salariés, sans papier ni carte.', 'Your employees’ benefits, with no paper and no card.', 'مزايا موظفيكم، بلا ورق ولا بطاقة.'],
      text: [
        'L’entreprise crédite ses salariés en dinars, ils paient chez les commerçants partenaires avec un code QR, et les commerçants sont réglés à J+2.',
        'The company credits its employees in dinars, they pay at partner merchants with a QR code, and merchants are settled at D+2.',
        'تشحن المؤسسة أرصدة موظفيها بالدينار، ويدفعون لدى التجار الشركاء برمز QR، ويُسوّى للتجار بعد يومين.',
      ],
      signIn: ['Se connecter', 'Sign in', 'تسجيل الدخول'],
      contact: ['Nous contacter', 'Contact us', 'اتصل بنا'],
    },
    types: {
      title: ['Quatre types de crédit, un solde pour chacun', 'Four credit types, one balance each', 'أربعة أنواع من الأرصدة، رصيد لكل نوع'],
      text: [
        'Chaque type a son solde, ses commerçants et ses règles. Aucun transfert entre types.',
        'Each type has its own balance, merchants and rules. No transfer between types.',
        'لكل نوع رصيده وتجّاره وقواعده. لا تحويل بين الأنواع.',
      ],
    },
    benefits: {
      title: ['Un service pour chacun', 'A service for everyone', 'خدمة لكل طرف'],
      company: {
        title: ['Entreprises', 'Companies', 'المؤسسات'],
        p1: ['Commande de crédits par type, payée par virement.', 'Credit orders per type, paid by bank transfer.', 'طلب أرصدة حسب النوع، تُدفع بتحويل بنكي.'],
        p2: ['Attribution en quelques clics ou par fichier CSV.', 'Allocation in a few clicks or by CSV file.', 'توزيع ببضع نقرات أو بملف CSV.'],
        p3: ['Factures et suivi des soldes en temps réel.', 'Invoices and real-time balance tracking.', 'فواتير ومتابعة الأرصدة في الوقت الفعلي.'],
      },
      merchant: {
        title: ['Commerçants', 'Merchants', 'التجار'],
        p1: ['Encaissement par code ou QR, sans terminal.', 'Collect by code or QR, with no terminal.', 'تحصيل بالرمز أو QR، دون جهاز دفع.'],
        p2: ['Règlement à J+2, commission connue à l’avance.', 'Settlement at D+2, commission known in advance.', 'تسوية بعد يومين، والعمولة معروفة مسبقًا.'],
        p3: ['Historique, créances et virements au même endroit.', 'History, receivables and payouts in one place.', 'السجل والمستحقات والتحويلات في مكان واحد.'],
      },
      employee: {
        title: ['Bénéficiaires', 'Beneficiaries', 'المستفيدون'],
        p1: ['Un solde par type, toujours à jour.', 'One balance per type, always up to date.', 'رصيد لكل نوع، محدّث دائمًا.'],
        p2: ['Paiement confirmé par un code PIN.', 'Payment confirmed with a PIN.', 'دفع يُؤكَّد برمز سري.'],
        p3: ['Reçu et historique de chaque opération.', 'Receipt and history of every operation.', 'وصل وسجل لكل عملية.'],
      },
    },
    steps: {
      title: ['Comment ça marche', 'How it works', 'كيف يعمل'],
      s1: {
        title: ['L’entreprise crédite', 'The company credits', 'المؤسسة تشحن'],
        text: [
          'Elle commande des crédits par type, les paie par virement, puis les attribue à ses salariés.',
          'It orders credits per type, pays them by transfer, then allocates them to its employees.',
          'تطلب أرصدة حسب النوع، وتدفعها بتحويل، ثم توزعها على موظفيها.',
        ],
      },
      s2: {
        title: ['Le bénéficiaire paie', 'The beneficiary pays', 'المستفيد يدفع'],
        text: [
          'Il montre son code QR au commerçant ou scanne celui du commerçant, puis confirme avec son PIN.',
          'They show their QR code to the merchant or scan the merchant’s, then confirm with their PIN.',
          'يعرض رمز QR الخاص به على التاجر أو يمسح رمز التاجر، ثم يؤكد برمزه السري.',
        ],
      },
      s3: {
        title: ['Le commerçant est réglé', 'The merchant is settled', 'التاجر يتلقى مستحقاته'],
        text: [
          'Les paiements confirmés lui sont virés à J+2, commission déduite.',
          'Confirmed payments are transferred at D+2, commission deducted.',
          'تُحوَّل إليه الدفعات المؤكدة بعد يومين، بعد خصم العمولة.',
        ],
      },
    },
    footer: {
      rights: ['© {year} FlexiPay. Tous droits réservés.', '© {year} FlexiPay. All rights reserved.', '© {year} FlexiPay. جميع الحقوق محفوظة.'],
      country: ['Service opéré en Tunisie, montants en dinars (TND).', 'Service operated in Tunisia, amounts in dinars (TND).', 'خدمة تعمل في تونس، والمبالغ بالدينار (TND).'],
    },
  },
  contact: {
    title: ['Nous contacter', 'Contact us', 'اتصل بنا'],
    description: [
      'Une question, un projet ? Laissez-nous un message, nous vous répondons sous deux jours ouvrés.',
      'A question, a project? Leave us a message, we answer within two business days.',
      'سؤال أو مشروع؟ اترك لنا رسالة، وسنرد خلال يومي عمل.',
    ],
    name: ['Nom et prénom', 'Full name', 'الاسم واللقب'],
    email: ['E-mail', 'E-mail', 'البريد الإلكتروني'],
    phone: ['Téléphone (facultatif)', 'Phone (optional)', 'الهاتف (اختياري)'],
    phoneHint: ['Exemple : 98 123 456 ou +216 98 123 456', 'Example: 98 123 456 or +216 98 123 456', 'مثال: 98 123 456 أو 98 123 456 216+'],
    company: ['Société (facultatif)', 'Company (optional)', 'الشركة (اختياري)'],
    type: ['Vous êtes', 'You are', 'أنت'],
    typePlaceholder: ['Choisissez', 'Choose', 'اختر'],
    types: {
      COMPANY: ['Une entreprise', 'A company', 'مؤسسة'],
      MERCHANT: ['Un commerçant', 'A merchant', 'تاجر'],
      OTHER: ['Autre', 'Other', 'أخرى'],
    },
    message: ['Message', 'Message', 'الرسالة'],
    messageHint: ['10 à 2 000 caractères.', '10 to 2,000 characters.', 'من 10 إلى 2000 حرف.'],
    submit: ['Envoyer le message', 'Send the message', 'إرسال الرسالة'],
    required: ['Champ obligatoire.', 'Required field.', 'حقل إلزامي.'],
    invalidEmail: ['Adresse e-mail invalide.', 'Invalid e-mail address.', 'عنوان بريد إلكتروني غير صالح.'],
    invalidPhone: ['Numéro invalide.', 'Invalid number.', 'رقم غير صالح.'],
    invalidName: ['Entre 2 et 120 caractères.', 'Between 2 and 120 characters.', 'بين 2 و120 حرفًا.'],
    invalidMessage: ['Entre 10 et 2 000 caractères.', 'Between 10 and 2,000 characters.', 'بين 10 و2000 حرف.'],
    sentTitle: ['Message envoyé', 'Message sent', 'تم إرسال الرسالة'],
    sentText: [
      'Merci. Votre référence : {reference}. Nous vous répondons par e-mail.',
      'Thank you. Your reference: {reference}. We will answer by e-mail.',
      'شكرًا. مرجعك: {reference}. سنرد عليك عبر البريد الإلكتروني.',
    ],
    another: ['Envoyer un autre message', 'Send another message', 'إرسال رسالة أخرى'],
    privacy: [
      'Vos coordonnées servent uniquement à vous répondre.',
      'Your details are only used to answer you.',
      'تُستعمل بياناتك فقط للرد عليك.',
    ],
  },
  help: {
    metaTitle: ['Aide — FlexiPay', 'Help — FlexiPay', 'المساعدة — FlexiPay'],
    title: ['Centre d’aide', 'Help centre', 'مركز المساعدة'],
    description: [
      'Se connecter, sécuriser son compte et utiliser chaque espace, écran par écran.',
      'Signing in, securing your account and using each space, screen by screen.',
      'تسجيل الدخول وتأمين الحساب واستعمال كل فضاء، شاشة بشاشة.',
    ],
    toc: ['Sommaire', 'Contents', 'المحتويات'],
    back: ['Retour', 'Back', 'رجوع'],
    capture: ['Capture : {title}', 'Screenshot: {title}', 'لقطة شاشة: {title}'],
    captureNote: [
      'Les captures montrent l’interface en français avec des données de démonstration.',
      'Screenshots show the interface in French with demo data.',
      'تعرض اللقطات الواجهة بالفرنسية مع بيانات تجريبية.',
    ],
    stillStuck: ['Toujours bloqué ?', 'Still stuck?', 'ما زلت عالقًا؟'],
    stillStuckText: [
      'Écrivez-nous depuis la page d’accueil, section « Nous contacter ».',
      'Write to us from the home page, “Contact us” section.',
      'راسلنا من الصفحة الرئيسية، قسم «اتصل بنا».',
    ],
    sections: {
      account: ['Compte et connexion', 'Account and sign-in', 'الحساب وتسجيل الدخول'],
      COMPANY: ['Espace Entreprise', 'Company space', 'فضاء المؤسسة'],
      MERCHANT: ['Espace Commerçant', 'Merchant space', 'فضاء التاجر'],
      EMPLOYEE: ['Espace Bénéficiaire', 'Beneficiary space', 'فضاء المستفيد'],
      ADMIN: ['Espace Administrateur', 'Administrator space', 'فضاء المشرف'],
    },
    topics: {
      login: {
        title: ['Se connecter', 'Sign in', 'تسجيل الدخول'],
        text: [
          'Saisissez votre e-mail (ou téléphone) et votre mot de passe, puis « Se connecter ». Vous arrivez directement dans l’espace de votre rôle.',
          'Enter your e-mail (or phone) and password, then “Sign in”. You land directly in the space of your role.',
          'أدخل بريدك الإلكتروني (أو هاتفك) وكلمة المرور، ثم «تسجيل الدخول». تصل مباشرة إلى فضاء دورك.',
        ],
      },
      mfa: {
        title: ['Double authentification (MFA)', 'Two-step verification (MFA)', 'التحقق الثنائي (MFA)'],
        text: [
          'Après le mot de passe, saisissez le code à 6 chiffres de votre application d’authentification. Sans téléphone, utilisez un code de secours : chacun ne sert qu’une fois.',
          'After the password, enter the 6-digit code of your authenticator app. Without your phone, use a recovery code: each works only once.',
          'بعد كلمة المرور، أدخل الرمز المكوّن من 6 أرقام من تطبيق المصادقة. دون هاتفك، استعمل رمز استرجاع: كل رمز يُستعمل مرة واحدة.',
        ],
      },
      firstLogin: {
        title: ['Première connexion', 'First sign-in', 'أول تسجيل دخول'],
        text: [
          'Connectez-vous avec le mot de passe temporaire reçu (valable 72 h), choisissez un nouveau mot de passe dans les 10 minutes, puis activez la double authentification en scannant le QR affiché. Notez vos codes de secours.',
          'Sign in with the temporary password you received (valid 72 h), choose a new password within 10 minutes, then turn on two-step verification by scanning the QR shown. Write down your recovery codes.',
          'سجّل الدخول بكلمة المرور المؤقتة المستلمة (صالحة 72 ساعة)، واختر كلمة مرور جديدة خلال 10 دقائق، ثم فعّل التحقق الثنائي بمسح رمز QR المعروض. دوّن رموز الاسترجاع.',
        ],
      },
      forgotPassword: {
        title: ['Mot de passe oublié', 'Forgotten password', 'نسيت كلمة المرور'],
        text: [
          'Sur la page de connexion, choisissez « Mot de passe oublié ». Avec un e-mail, vous recevez un lien valable 15 minutes ; avec un téléphone, un code SMS valable 10 minutes.',
          'On the sign-in page, choose “Forgot password”. With an e-mail you get a link valid 15 minutes; with a phone, an SMS code valid 10 minutes.',
          'في صفحة تسجيل الدخول، اختر «نسيت كلمة المرور». مع البريد الإلكتروني تتلقى رابطًا صالحًا 15 دقيقة، ومع الهاتف رمزًا نصيًا صالحًا 10 دقائق.',
        ],
      },
      sessionExpired: {
        title: ['Session expirée', 'Session expired', 'انتهاء الجلسة'],
        text: [
          'Après une période d’inactivité, la session se ferme pour protéger votre compte. Un avertissement apparaît avant ; reconnectez-vous pour reprendre là où vous étiez.',
          'After a period of inactivity, the session closes to protect your account. A warning appears first; sign in again to continue where you were.',
          'بعد فترة من عدم النشاط، تُغلق الجلسة لحماية حسابك. يظهر تنبيه قبل ذلك؛ سجّل الدخول من جديد لمواصلة عملك.',
        ],
      },
      accountLocked: {
        title: ['Compte bloqué', 'Account locked', 'الحساب مقفل'],
        text: [
          'Après plusieurs essais erronés, le compte est bloqué temporairement. Attendez la fin du délai indiqué ou réinitialisez votre mot de passe. Si le blocage persiste, contactez votre administrateur.',
          'After several wrong attempts, the account is locked for a while. Wait for the delay shown or reset your password. If it stays locked, contact your administrator.',
          'بعد عدة محاولات خاطئة، يُقفل الحساب مؤقتًا. انتظر انتهاء المدة المعروضة أو أعد تعيين كلمة المرور. إذا استمر القفل، اتصل بالمشرف.',
        ],
      },
      companyDashboard: {
        title: ['Tableau de bord', 'Dashboard', 'لوحة القيادة'],
        text: [
          'Une carte par type de crédit montre le solde disponible de l’entreprise, avec les commandes à payer et l’activité récente.',
          'One card per credit type shows the company’s available balance, with orders to pay and recent activity.',
          'بطاقة لكل نوع رصيد تعرض الرصيد المتاح للمؤسسة، مع الطلبيات الواجب دفعها والنشاط الأخير.',
        ],
      },
      companyEmployees: {
        title: ['Employés', 'Employees', 'الموظفون'],
        text: [
          'Ajoutez vos salariés un par un ou par import CSV ; chacun reçoit ses accès au bénéficiaire. Vous pouvez suspendre un compte.',
          'Add employees one by one or by CSV import; each receives beneficiary access. You can suspend an account.',
          'أضف موظفيك واحدًا تلو الآخر أو باستيراد ملف CSV؛ يتلقى كل منهم بيانات الدخول. يمكنك تعليق حساب.',
        ],
      },
      companyOrders: {
        title: ['Commandes de crédits', 'Credit orders', 'طلبيات الأرصدة'],
        text: [
          'Saisissez un montant par type, validez, puis virez la somme sur le compte indiqué et déposez la preuve de virement. FlexiPay valide et crédite chaque type.',
          'Enter an amount per type, submit, then transfer the sum to the account shown and upload the transfer proof. FlexiPay validates and credits each type.',
          'أدخل مبلغًا لكل نوع، وأكّد، ثم حوّل المبلغ إلى الحساب المعروض وارفع إثبات التحويل. تتحقق FlexiPay وتشحن كل نوع.',
        ],
      },
      companyAllocation: {
        title: ['Attribution', 'Allocation', 'التوزيع'],
        text: [
          'Choisissez un type de crédit et les salariés, avec un montant chacun : seul ce type est débité. Pour un grand nombre, importez un CSV avec une colonne par type.',
          'Choose a credit type and the employees, with an amount each: only that type is debited. For many people, import a CSV with one column per type.',
          'اختر نوع الرصيد والموظفين مع مبلغ لكل منهم: يُخصم هذا النوع فقط. لعدد كبير، استورد ملف CSV بعمود لكل نوع.',
        ],
      },
      companyInvoices: {
        title: ['Factures', 'Invoices', 'الفواتير'],
        text: [
          'Chaque commande validée produit une facture téléchargeable en PDF.',
          'Each validated order produces an invoice you can download as PDF.',
          'تُنتج كل طلبية مؤكدة فاتورة قابلة للتنزيل بصيغة PDF.',
        ],
      },
      merchantDashboard: {
        title: ['Tableau de bord', 'Dashboard', 'لوحة القيادة'],
        text: [
          'Le chiffre du jour, les montants à recevoir et la répartition par type de crédit.',
          'Today’s takings, amounts to receive and the split per credit type.',
          'رقم معاملات اليوم، والمبالغ المستحقة، والتوزيع حسب نوع الرصيد.',
        ],
      },
      merchantCollect: {
        title: ['Encaisser', 'Collect', 'التحصيل'],
        text: [
          'Saisissez le code à 8 chiffres affiché par le client et le montant ; il confirme avec son PIN. Le client peut aussi scanner votre QR FlexiPay affiché sur cet écran.',
          'Enter the 8-digit code shown by the customer and the amount; they confirm with their PIN. The customer can also scan your FlexiPay QR shown on this screen.',
          'أدخل الرمز المكوّن من 8 أرقام الذي يعرضه الحريف والمبلغ؛ يؤكد برمزه السري. يمكن للحريف أيضًا مسح رمز FlexiPay المعروض في هذه الشاشة.',
        ],
      },
      merchantHistory: {
        title: ['Historique', 'History', 'السجل'],
        text: [
          'Tous les paiements, filtrables par statut et par type ; ouvrez-en un pour voir la commission et la date de règlement.',
          'All payments, filterable by status and type; open one to see the commission and settlement date.',
          'كل الدفعات، مع التصفية حسب الحالة والنوع؛ افتح إحداها لرؤية العمولة وتاريخ التسوية.',
        ],
      },
      merchantReceivables: {
        title: ['Créances', 'Receivables', 'المستحقات'],
        text: [
          'Les montants confirmés qui seront réglés à J+2, jour par jour.',
          'Confirmed amounts to be settled at D+2, day by day.',
          'المبالغ المؤكدة التي ستُسوّى بعد يومين، يومًا بيوم.',
        ],
      },
      merchantPayouts: {
        title: ['Virements', 'Payouts', 'التحويلات'],
        text: [
          'Demandez le virement de vos fonds disponibles : brut, commission et net sont affichés avant d’envoyer. FlexiPay contrôle puis vire sur votre IBAN.',
          'Request the payout of your available funds: gross, commission and net are shown before sending. FlexiPay checks then transfers to your IBAN.',
          'اطلب تحويل أموالك المتاحة: يُعرض المبلغ الإجمالي والعمولة والصافي قبل الإرسال. تتحقق FlexiPay ثم تحوّل إلى IBAN الخاص بك.',
        ],
      },
      merchantSettlements: {
        title: ['Règlements', 'Settlements', 'التسويات'],
        text: [
          'Les relevés de règlement, avec le détail des paiements inclus.',
          'Settlement statements, with the detail of included payments.',
          'كشوف التسوية، مع تفاصيل الدفعات المشمولة.',
        ],
      },
      merchantShop: {
        title: ['Mon commerce', 'My shop', 'متجري'],
        text: [
          'Vos coordonnées, IBAN masqué, types de crédit acceptés et taux de commission.',
          'Your details, masked IBAN, accepted credit types and commission rates.',
          'بياناتك، وIBAN المقنّع، وأنواع الأرصدة المقبولة ونسب العمولة.',
        ],
      },
      employeeHome: {
        title: ['Mon solde', 'My balance', 'رصيدي'],
        text: [
          'Un solde par type, avec ce que vous avez dépensé aujourd’hui sur le plafond journalier et les crédits qui vont expirer.',
          'One balance per type, with what you spent today against the daily limit and credits about to expire.',
          'رصيد لكل نوع، مع ما أنفقته اليوم مقارنة بالسقف اليومي والأرصدة التي ستنتهي صلاحيتها.',
        ],
      },
      employeePay: {
        title: ['Payer', 'Pay', 'الدفع'],
        text: [
          '« Mon code » affiche un QR et 8 chiffres valables 60 secondes : le commerçant les saisit, vous confirmez avec votre PIN. « Payer un commerçant » : scannez son QR ou saisissez son code à 6 chiffres.',
          '“My code” shows a QR and 8 digits valid 60 seconds: the merchant types them, you confirm with your PIN. “Pay a merchant”: scan their QR or type their 6-digit code.',
          '«رمزي» يعرض رمز QR و8 أرقام صالحة 60 ثانية: يُدخلها التاجر وتؤكد برمزك السري. «الدفع لتاجر»: امسح رمزه أو أدخل رمزه المكوّن من 6 أرقام.',
        ],
      },
      employeeHistory: {
        title: ['Historique et reçus', 'History and receipts', 'السجل والوصولات'],
        text: [
          'Paiements, crédits reçus et expirations, filtrables par type ; chaque ligne ouvre un reçu imprimable.',
          'Payments, credits received and expiries, filterable by type; each line opens a printable receipt.',
          'الدفعات والأرصدة المستلمة وانتهاءات الصلاحية، مع التصفية حسب النوع؛ كل سطر يفتح وصلًا قابلًا للطباعة.',
        ],
      },
      employeeSecurity: {
        title: ['Profil et sécurité', 'Profile and security', 'الملف والأمان'],
        text: [
          'Consultez vos informations, changez votre mot de passe, votre PIN de paiement et régénérez vos codes de secours.',
          'See your details, change your password and payment PIN, and regenerate your recovery codes.',
          'اطلع على معلوماتك، وغيّر كلمة المرور والرمز السري للدفع، وأعد إنشاء رموز الاسترجاع.',
        ],
      },
      adminDashboard: {
        title: ['Supervision', 'Overview', 'الإشراف'],
        text: [
          'Les volumes du mois par type, les tâches en attente (commandes, KYC, virements, validations) et l’activité récente.',
          'Monthly volumes per type, pending tasks (orders, KYC, payouts, approvals) and recent activity.',
          'أحجام الشهر حسب النوع، والمهام المعلقة (طلبيات، تحقق، تحويلات، مصادقات) والنشاط الأخير.',
        ],
      },
      adminAccounts: {
        title: ['Commerçants et entreprises', 'Merchants and companies', 'التجار والمؤسسات'],
        text: [
          'Créez et suivez les comptes ; dans la fiche d’un commerçant, définissez les types de crédit qu’il accepte.',
          'Create and follow accounts; in a merchant’s record, set the credit types it accepts.',
          'أنشئ الحسابات وتابعها؛ في ملف التاجر، حدّد أنواع الأرصدة التي يقبلها.',
        ],
      },
      adminKyc: {
        title: ['Dossiers KYC', 'KYC files', 'ملفات التحقق'],
        text: [
          'Ouvrez un dossier, consultez les pièces, validez ou refusez avec un motif. Le compte reste inactif tant que le KYC n’est pas validé.',
          'Open a file, view the documents, approve or reject with a reason. The account stays inactive until KYC is approved.',
          'افتح ملفًا واطلع على الوثائق، ثم صادق أو ارفض مع ذكر السبب. يبقى الحساب غير نشط حتى المصادقة على التحقق.',
        ],
      },
      adminOrders: {
        title: ['Commandes', 'Orders', 'الطلبيات'],
        text: [
          'Confirmez les commandes, vérifiez la preuve de virement et validez : chaque type est alors crédité. Au-delà de 10 000,000 TND, un second administrateur doit valider.',
          'Confirm orders, check the transfer proof and validate: each type is then credited. Above 10,000.000 TND, a second administrator must validate.',
          'أكّد الطلبيات، وتحقق من إثبات التحويل، وصادق: يُشحن عندها كل نوع. فوق 10 000,000 دينار، يجب أن يصادق مشرف ثانٍ.',
        ],
      },
      adminPayouts: {
        title: ['Virements commerçants et règlements', 'Merchant payouts and settlements', 'تحويلات التجار والتسويات'],
        text: [
          'Contrôlez chaque demande (brut, commission, net, IBAN), validez ou refusez avec un motif. Les virements validés forment un lot de règlement.',
          'Check each request (gross, commission, net, IBAN), approve or reject with a reason. Approved payouts form a settlement batch.',
          'راجع كل طلب (الإجمالي، العمولة، الصافي، IBAN)، وصادق أو ارفض مع ذكر السبب. تُكوّن التحويلات المصادق عليها دفعة تسوية.',
        ],
      },
      adminSettings: {
        title: ['Commissions, validations et paramètres', 'Commissions, approvals and settings', 'العمولات والمصادقات والإعدادات'],
        text: [
          'Par type : commission, validité, plafond journalier, activation. Toute modification sensible est validée par un autre administrateur et tracée dans le journal d’audit.',
          'Per type: commission, validity, daily limit, activation. Every sensitive change is approved by another administrator and logged in the audit log.',
          'لكل نوع: العمولة والصلاحية والسقف اليومي والتفعيل. يصادق مشرف آخر على كل تعديل حساس ويُسجَّل في سجل التدقيق.',
        ],
      },
      adminTransactions: {
        title: ['Transactions et journal d’audit', 'Transactions and audit log', 'المعاملات وسجل التدقيق'],
        text: [
          'Toutes les opérations de la plateforme, filtrables par type de crédit, et l’historique des actions sensibles.',
          'All platform operations, filterable by credit type, and the history of sensitive actions.',
          'كل عمليات المنصة مع التصفية حسب نوع الرصيد، وسجل الإجراءات الحساسة.',
        ],
      },
      adminMessages: {
        title: ['Messages', 'Messages', 'الرسائل'],
        text: [
          'Les messages envoyés depuis « Nous contacter » sur la page d’accueil. Ouvrez-en un, répondez par e-mail ou téléphone, puis marquez-le comme traité.',
          'Messages sent from “Contact us” on the home page. Open one, answer by e-mail or phone, then mark it as handled.',
          'الرسائل المرسلة من «اتصل بنا» في الصفحة الرئيسية. افتح رسالة، ورد بالبريد أو الهاتف، ثم علّمها كمعالجة.',
        ],
      },
    },
  },
  tour: {
    label: ['Visite guidée', 'Guided tour', 'جولة إرشادية'],
    progress: ['Étape {current} sur {total}', 'Step {current} of {total}', 'الخطوة {current} من {total}'],
    skip: ['Passer la visite', 'Skip the tour', 'تخطي الجولة'],
    previous: ['Précédent', 'Previous', 'السابق'],
    next: ['Suivant', 'Next', 'التالي'],
    finish: ['C’est parti', 'Let’s go', 'لنبدأ'],
    relaunch: ['Revoir la visite guidée', 'Replay the guided tour', 'إعادة الجولة الإرشادية'],
    helpCentre: ['Centre d’aide', 'Help centre', 'مركز المساعدة'],
    MERCHANT: {
      s1: {
        title: ['Bienvenue dans votre espace commerçant', 'Welcome to your merchant space', 'مرحبًا بك في فضاء التاجر'],
        text: ['Encaissements, créances et virements : tout est ici.', 'Collections, receivables and payouts: everything is here.', 'التحصيل والمستحقات والتحويلات: كل شيء هنا.'],
      },
      s2: {
        title: ['Encaisser un paiement', 'Collect a payment', 'تحصيل دفعة'],
        text: [
          'Dans « Encaissement », saisissez le code à 8 chiffres du client et le montant. Il confirme avec son PIN. Il peut aussi scanner votre QR.',
          'In “Collect”, enter the customer’s 8-digit code and the amount. They confirm with their PIN. They can also scan your QR.',
          'في «التحصيل»، أدخل رمز الحريف المكوّن من 8 أرقام والمبلغ. يؤكد برمزه السري. ويمكنه أيضًا مسح رمزك.',
        ],
      },
      s3: {
        title: ['Être réglé à J+2', 'Get settled at D+2', 'التسوية بعد يومين'],
        text: [
          'Chaque paiement confirmé est réglé à J+2, moins la commission de son type. Suivez-le dans « Créances » puis « Virements ».',
          'Each confirmed payment is settled at D+2, minus the commission of its type. Follow it in “Receivables” then “Payouts”.',
          'تُسوّى كل دفعة مؤكدة بعد يومين، بعد خصم عمولة نوعها. تابعها في «المستحقات» ثم «التحويلات».',
        ],
      },
      s4: {
        title: ['Vos types de crédit', 'Your credit types', 'أنواع الأرصدة لديك'],
        text: [
          'Vous acceptez les types définis par FlexiPay ; le client ne peut payer qu’avec ceux-là. Ils figurent dans « Mon commerce ».',
          'You accept the types set by FlexiPay; customers can only pay with those. They are listed in “My shop”.',
          'تقبل الأنواع التي تحددها FlexiPay؛ ولا يمكن للحريف الدفع إلا بها. تجدها في «متجري».',
        ],
      },
    },
    COMPANY: {
      s1: {
        title: ['Bienvenue dans votre espace entreprise', 'Welcome to your company space', 'مرحبًا بك في فضاء المؤسسة'],
        text: [
          'Un solde par type de crédit : Restauration, Habillement, Carburant, Cadeaux.',
          'One balance per credit type: Meals, Clothing, Fuel, Gifts.',
          'رصيد لكل نوع: المطاعم، الملابس، المحروقات، الهدايا.',
        ],
      },
      s2: {
        title: ['Ajoutez vos salariés', 'Add your employees', 'أضف موظفيك'],
        text: [
          'Dans « Employés », un par un ou par import CSV. Chacun reçoit ses accès.',
          'In “Employees”, one by one or by CSV import. Each receives their access.',
          'في «الموظفون»، واحدًا تلو الآخر أو باستيراد CSV. يتلقى كل منهم بيانات الدخول.',
        ],
      },
      s3: {
        title: ['Commandez des crédits', 'Order credits', 'اطلب أرصدة'],
        text: [
          'Un montant par type, puis un virement et sa preuve. FlexiPay valide et crédite chaque type.',
          'An amount per type, then a transfer and its proof. FlexiPay validates and credits each type.',
          'مبلغ لكل نوع، ثم تحويل وإثباته. تتحقق FlexiPay وتشحن كل نوع.',
        ],
      },
      s4: {
        title: ['Attribuez-les', 'Allocate them', 'وزّعها'],
        text: [
          'Dans « Attribution », choisissez un type et les salariés : seul ce type est débité.',
          'In “Allocation”, choose a type and the employees: only that type is debited.',
          'في «التوزيع»، اختر نوعًا والموظفين: يُخصم هذا النوع فقط.',
        ],
      },
    },
    EMPLOYEE: {
      s1: {
        title: ['Bienvenue sur FlexiPay', 'Welcome to FlexiPay', 'مرحبًا بك في FlexiPay'],
        text: [
          'Votre entreprise vous offre des crédits : un solde par type, à utiliser chez les commerçants qui l’acceptent.',
          'Your company gives you credits: one balance per type, to use at merchants that accept it.',
          'تمنحك مؤسستك أرصدة: رصيد لكل نوع، للاستعمال لدى التجار الذين يقبلونه.',
        ],
      },
      s2: {
        title: ['Payer avec votre code', 'Pay with your code', 'ادفع برمزك'],
        text: [
          'Dans « Payer », affichez votre code. Le commerçant le saisit, vous confirmez avec votre PIN.',
          'In “Pay”, show your code. The merchant types it, you confirm with your PIN.',
          'في «الدفع»، اعرض رمزك. يُدخله التاجر وتؤكد برمزك السري.',
        ],
      },
      s3: {
        title: ['Ou scannez le commerçant', 'Or scan the merchant', 'أو امسح رمز التاجر'],
        text: [
          'Scannez son QR ou tapez son code à 6 chiffres, choisissez le type et le montant.',
          'Scan their QR or type their 6-digit code, choose the type and amount.',
          'امسح رمزه أو اكتب رمزه المكوّن من 6 أرقام، واختر النوع والمبلغ.',
        ],
      },
      s4: {
        title: ['Gardez votre PIN secret', 'Keep your PIN secret', 'احتفظ برمزك السري'],
        text: [
          'Personne chez FlexiPay ne vous le demandera. Changez-le à tout moment dans « Sécurité ».',
          'No one at FlexiPay will ever ask for it. Change it any time in “Security”.',
          'لن يطلبه منك أحد في FlexiPay. غيّره في أي وقت من «الأمان».',
        ],
      },
    },
  },
  adminMessages: {
    title: ['Messages', 'Messages', 'الرسائل'],
    description: [
      'Demandes reçues par le formulaire « Nous contacter » de la page d’accueil.',
      'Requests received through the “Contact us” form of the home page.',
      'الطلبات الواردة عبر نموذج «اتصل بنا» في الصفحة الرئيسية.',
    ],
    search: ['Nom, société, e-mail ou référence', 'Name, company, e-mail or reference', 'الاسم أو الشركة أو البريد أو المرجع'],
    statusLabel: ['État', 'Status', 'الحالة'],
    status: {
      NEW: ['Nouveau', 'New', 'جديد'],
      HANDLED: ['Traité', 'Handled', 'تمت المعالجة'],
    },
    requester: ['Demandeur', 'Requester', 'صاحب الطلب'],
    type: ['Type', 'Type', 'النوع'],
    received: ['Reçu le', 'Received', 'تاريخ الاستلام'],
    reference: ['Référence', 'Reference', 'المرجع'],
    open: ['Ouvrir le message {reference}', 'Open message {reference}', 'فتح الرسالة {reference}'],
    emptyTitle: ['Aucun message', 'No messages', 'لا توجد رسائل'],
    emptyMessage: ['Les messages du formulaire de contact apparaîtront ici.', 'Messages from the contact form will appear here.', 'ستظهر هنا رسائل نموذج الاتصال.'],
    back: ['Retour aux messages', 'Back to messages', 'العودة إلى الرسائل'],
    detailTitle: ['Message {reference}', 'Message {reference}', 'الرسالة {reference}'],
    sender: ['Expéditeur', 'Sender', 'المرسل'],
    name: ['Nom', 'Name', 'الاسم'],
    email: ['E-mail', 'E-mail', 'البريد الإلكتروني'],
    phone: ['Téléphone', 'Phone', 'الهاتف'],
    company: ['Société', 'Company', 'الشركة'],
    none: ['Non renseigné', 'Not given', 'غير مذكور'],
    message: ['Message', 'Message', 'الرسالة'],
    reply: ['Répondre par e-mail', 'Reply by e-mail', 'الرد بالبريد الإلكتروني'],
    handledBy: ['Traité par {name} le {date}', 'Handled by {name} on {date}', 'عالجها {name} بتاريخ {date}'],
    note: ['Note interne', 'Internal note', 'ملاحظة داخلية'],
    noteHint: ['Facultatif, 500 caractères au plus. Visible des seuls administrateurs.', 'Optional, 500 characters at most. Visible to administrators only.', 'اختياري، 500 حرف كحد أقصى. يراها المشرفون فقط.'],
    handle: ['Marquer comme traité', 'Mark as handled', 'تعليم كمعالجة'],
    handleTitle: ['Marquer le message comme traité', 'Mark the message as handled', 'تعليم الرسالة كمعالجة'],
    handleText: ['Le message passera à l’état « Traité ». L’action est enregistrée dans le journal d’audit.', 'The message will move to “Handled”. The action is recorded in the audit log.', 'ستنتقل الرسالة إلى حالة «تمت المعالجة». يُسجَّل الإجراء في سجل التدقيق.'],
    handled: ['Message marqué comme traité.', 'Message marked as handled.', 'تم تعليم الرسالة كمعالجة.'],
    noteTooLong: ['500 caractères au plus.', '500 characters at most.', '500 حرف كحد أقصى.'],
  },
};
