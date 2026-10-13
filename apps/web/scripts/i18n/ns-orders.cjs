// Circuit des commandes de crédits : [fr, en, ar].
module.exports = {
  "orders": {
    "status": {
      "AWAITING_CONFIRMATION": [
        "En attente de confirmation",
        "Awaiting confirmation",
        "في انتظار التأكيد"
      ],
      "AWAITING_PAYMENT": [
        "En attente de paiement",
        "Awaiting payment",
        "في انتظار الدفع"
      ],
      "AWAITING_VALIDATION": [
        "En attente de validation",
        "Awaiting validation",
        "في انتظار المصادقة"
      ],
      "VALIDATED": [
        "Validée",
        "Validated",
        "مصادق عليها"
      ],
      "REFUSED": [
        "Refusée",
        "Refused",
        "مرفوضة"
      ],
      "CANCELLED": [
        "Annulée",
        "Cancelled",
        "ملغاة"
      ]
    },
    "event": {
      "CREATED": [
        "Commande créée",
        "Order created",
        "إنشاء الطلبية"
      ],
      "CONFIRMED": [
        "Commande confirmée",
        "Order confirmed",
        "تأكيد الطلبية"
      ],
      "REFUSED": [
        "Commande refusée",
        "Order refused",
        "رفض الطلبية"
      ],
      "CANCELLED": [
        "Commande annulée",
        "Order cancelled",
        "إلغاء الطلبية"
      ],
      "TRANSFER_DECLARED": [
        "Virement déclaré",
        "Transfer declared",
        "التصريح بالتحويل"
      ],
      "PROOF_REJECTED": [
        "Justificatif rejeté",
        "Proof rejected",
        "رفض الإثبات"
      ],
      "VALIDATED": [
        "Paiement validé, crédits ajoutés au solde",
        "Payment validated, credits added to the balance",
        "المصادقة على الدفع وإضافة الأرصدة إلى الرصيد"
      ]
    },
    "role": {
      "ADMIN": [
        "FlexiPay",
        "FlexiPay",
        "FlexiPay"
      ],
      "COMPANY": [
        "Entreprise",
        "Company",
        "المؤسسة"
      ]
    },
    "fields": {
      "reference": [
        "Commande",
        "Order",
        "الطلبية"
      ],
      "company": [
        "Entreprise",
        "Company",
        "المؤسسة"
      ],
      "createdAt": [
        "Créée le",
        "Created on",
        "تاريخ الإنشاء"
      ],
      "credits": [
        "Crédits commandés",
        "Credits ordered",
        "الأرصدة المطلوبة"
      ],
      "fees": [
        "Frais de service",
        "Service fees",
        "رسوم الخدمة"
      ],
      "total": [
        "Montant à virer",
        "Amount to transfer",
        "المبلغ المراد تحويله"
      ],
      "paymentReference": [
        "Motif à indiquer sur le virement",
        "Reference to put on the transfer",
        "البيان الواجب ذكره في التحويل"
      ],
      "status": [
        "Statut",
        "Status",
        "الحالة"
      ],
      "declared": [
        "Montant déclaré",
        "Declared amount",
        "المبلغ المصرّح به"
      ],
      "action": [
        "Action",
        "Action",
        "الإجراء"
      ]
    },
    "open": [
      "Ouvrir",
      "Open",
      "فتح"
    ],
    "openOrder": [
      "Ouvrir la commande {reference}",
      "Open order {reference}",
      "فتح الطلبية {reference}"
    ],
    "back": [
      "Retour aux commandes",
      "Back to orders",
      "العودة إلى الطلبيات"
    ],
    "summary": [
      "Commande",
      "Order",
      "الطلبية"
    ],
    "history": {
      "title": [
        "Historique",
        "History",
        "السجل"
      ],
      "by": [
        "par {name} ({role})",
        "by {name} ({role})",
        "بواسطة {name} ({role})"
      ],
      "reason": [
        "Motif : {reason}",
        "Reason: {reason}",
        "السبب: {reason}"
      ]
    },
    "bank": {
      "title": [
        "Coordonnées bancaires de FlexiPay",
        "FlexiPay bank details",
        "الإحداثيات البنكية لـ FlexiPay"
      ],
      "description": [
        "Virez le montant exact sur ce compte en indiquant le motif {reference}.",
        "Transfer the exact amount to this account with the reference {reference}.",
        "حوّل المبلغ بالضبط إلى هذا الحساب مع ذكر البيان {reference}."
      ],
      "bankName": [
        "Banque",
        "Bank",
        "البنك"
      ],
      "holder": [
        "Titulaire",
        "Account holder",
        "صاحب الحساب"
      ],
      "rib": [
        "RIB",
        "RIB",
        "رقم الحساب البنكي (RIB)"
      ],
      "iban": [
        "IBAN",
        "IBAN",
        "IBAN"
      ],
      "copy": [
        "Copier",
        "Copy",
        "نسخ"
      ],
      "copyLabel": [
        "Copier : {field}",
        "Copy: {field}",
        "نسخ: {field}"
      ],
      "copied": [
        "{field} copié.",
        "{field} copied.",
        "تم نسخ {field}."
      ],
      "copyFailed": [
        "Copie impossible : sélectionnez le texte et copiez-le.",
        "Copy failed: select the text and copy it.",
        "تعذّر النسخ: حدّد النص وانسخه."
      ]
    },
    "proof": {
      "title": [
        "Capture du virement",
        "Transfer proof",
        "صورة التحويل"
      ],
      "download": [
        "Télécharger la capture",
        "Download the proof",
        "تنزيل الصورة"
      ],
      "loading": [
        "Chargement de la capture…",
        "Loading the proof…",
        "جارٍ تحميل الصورة…"
      ],
      "alt": [
        "Capture du virement de la commande {reference}",
        "Transfer proof of order {reference}",
        "صورة تحويل الطلبية {reference}"
      ],
      "pdf": [
        "Document PDF : téléchargez-le pour le consulter.",
        "PDF document: download it to view it.",
        "مستند PDF: نزّله للاطلاع عليه."
      ],
      "error": [
        "La capture n'a pas pu être chargée.",
        "The proof could not be loaded.",
        "تعذّر تحميل الصورة."
      ],
      "size": [
        "{name} · {size} Ko",
        "{name} · {size} KB",
        "{name} · {size} ك.ب"
      ]
    },
    "declaration": {
      "title": [
        "Virement déclaré",
        "Declared transfer",
        "التحويل المصرّح به"
      ],
      "transferReference": [
        "Référence du virement",
        "Transfer reference",
        "مرجع التحويل"
      ],
      "transferDate": [
        "Date du virement",
        "Transfer date",
        "تاريخ التحويل"
      ],
      "amount": [
        "Montant viré",
        "Amount transferred",
        "المبلغ المحوَّل"
      ],
      "declaredAt": [
        "Déclaré le",
        "Declared on",
        "تاريخ التصريح"
      ]
    },
    "declare": {
      "title": [
        "Déclarer mon virement",
        "Declare my transfer",
        "التصريح بتحويلي"
      ],
      "description": [
        "Après votre virement, renseignez-le ici avec sa capture. FlexiPay vérifie la réception des fonds puis ajoute les crédits à votre solde.",
        "Once you have made the transfer, enter it here with its proof. FlexiPay checks that the funds arrived, then adds the credits to your balance.",
        "بعد إجراء التحويل، صرّح به هنا مع صورته. تتحقق FlexiPay من وصول الأموال ثم تضيف الأرصدة إلى رصيدك."
      ],
      "redeclare": [
        "Déclarer à nouveau",
        "Declare again",
        "التصريح من جديد"
      ],
      "transferReference": [
        "Référence du virement",
        "Transfer reference",
        "مرجع التحويل"
      ],
      "transferReferenceHint": [
        "Telle qu'elle figure sur l'avis de votre banque.",
        "As shown on your bank's notice.",
        "كما يظهر في إشعار بنكك."
      ],
      "transferDate": [
        "Date du virement",
        "Transfer date",
        "تاريخ التحويل"
      ],
      "amount": [
        "Montant viré (TND)",
        "Amount transferred (TND)",
        "المبلغ المحوَّل (د.ت)"
      ],
      "amountHint": [
        "Montant à virer : {amount}. 3 décimales au plus, par exemple 12 450,500.",
        "Amount to transfer: {amount}. 3 decimals at most, e.g. 12,450.500.",
        "المبلغ المراد تحويله: {amount}. 3 أرقام عشرية على الأكثر، مثال: 12450,500."
      ],
      "proof": [
        "Capture du virement",
        "Transfer proof",
        "صورة التحويل"
      ],
      "proofHint": [
        "Image JPG ou PNG, ou PDF. 5 Mo maximum.",
        "JPG or PNG image, or PDF. 5 MB maximum.",
        "صورة JPG أو PNG، أو ملف PDF. 5 م.ب كحد أقصى."
      ],
      "submit": [
        "Envoyer la déclaration",
        "Send the declaration",
        "إرسال التصريح"
      ],
      "sentToast": [
        "Virement déclaré : FlexiPay va vérifier la réception des fonds.",
        "Transfer declared: FlexiPay will check that the funds arrived.",
        "تم التصريح بالتحويل: ستتحقق FlexiPay من وصول الأموال."
      ],
      "required": [
        "Champ obligatoire.",
        "Required field.",
        "حقل إلزامي."
      ],
      "tooLong": [
        "Texte trop long.",
        "Text too long.",
        "النص طويل جدًا."
      ],
      "dateInFuture": [
        "La date ne peut pas être dans le futur.",
        "The date cannot be in the future.",
        "لا يمكن أن يكون التاريخ في المستقبل."
      ],
      "dateInvalid": [
        "Date invalide.",
        "Invalid date.",
        "تاريخ غير صالح."
      ],
      "amountInvalid": [
        "Montant invalide : chiffres et séparateur décimal, 3 décimales au plus.",
        "Invalid amount: digits and a decimal separator, 3 decimals at most.",
        "مبلغ غير صالح: أرقام وفاصلة عشرية، 3 أرقام عشرية على الأكثر."
      ],
      "fileType": [
        "Format refusé : JPG, PNG ou PDF uniquement.",
        "Format not accepted: JPG, PNG or PDF only.",
        "صيغة مرفوضة: JPG أو PNG أو PDF فقط."
      ],
      "fileTooLarge": [
        "Fichier trop lourd : 5 Mo maximum.",
        "File too large: 5 MB maximum.",
        "الملف كبير جدًا: 5 م.ب كحد أقصى."
      ]
    },
    "company": {
      "title": [
        "Mes commandes",
        "My orders",
        "طلبياتي"
      ],
      "description": [
        "Suivez chaque commande : confirmation par FlexiPay, virement, validation et ajout des crédits.",
        "Follow each order: confirmation by FlexiPay, transfer, validation and credits added.",
        "تابع كل طلبية: التأكيد من FlexiPay، التحويل، المصادقة وإضافة الأرصدة."
      ],
      "detailTitle": [
        "Commande {reference}",
        "Order {reference}",
        "الطلبية {reference}"
      ],
      "stateAwaitingConfirmation": [
        "FlexiPay doit confirmer votre commande. Vous pourrez ensuite faire le virement et le déclarer ici.",
        "FlexiPay must confirm your order. You can then make the transfer and declare it here.",
        "يجب أن تؤكد FlexiPay طلبيتك. بعد ذلك يمكنك إجراء التحويل والتصريح به هنا."
      ],
      "stateAwaitingPayment": [
        "Commande confirmée : faites le virement sur le compte ci-dessous, puis déclarez-le.",
        "Order confirmed: make the transfer to the account below, then declare it.",
        "تم تأكيد الطلبية: أجرِ التحويل إلى الحساب أدناه ثم صرّح به."
      ],
      "stateAwaitingValidation": [
        "Virement déclaré. FlexiPay vérifie la réception des fonds avant d'ajouter les crédits à votre solde.",
        "Transfer declared. FlexiPay is checking that the funds arrived before adding the credits to your balance.",
        "تم التصريح بالتحويل. تتحقق FlexiPay من وصول الأموال قبل إضافة الأرصدة إلى رصيدك."
      ],
      "stateValidated": [
        "Paiement validé : {amount} de crédits ont été ajoutés à votre solde.",
        "Payment validated: {amount} of credits were added to your balance.",
        "تمت المصادقة على الدفع: أُضيفت أرصدة بقيمة {amount} إلى رصيدك."
      ],
      "stateCancelled": [
        "Vous avez annulé cette commande.",
        "You cancelled this order.",
        "لقد ألغيت هذه الطلبية."
      ],
      "refusedTitle": [
        "Commande refusée par FlexiPay",
        "Order refused by FlexiPay",
        "رفضت FlexiPay الطلبية"
      ],
      "rejectedTitle": [
        "Justificatif rejeté : déclarez à nouveau votre virement",
        "Proof rejected: declare your transfer again",
        "تم رفض الإثبات: صرّح بتحويلك من جديد"
      ],
      "cancel": [
        "Annuler la commande",
        "Cancel the order",
        "إلغاء الطلبية"
      ],
      "cancelTitle": [
        "Annuler la commande {reference} ?",
        "Cancel order {reference}?",
        "إلغاء الطلبية {reference}؟"
      ],
      "cancelMessage": [
        "La commande ne pourra plus être payée. Ne faites pas de virement pour cette commande.",
        "The order can no longer be paid. Do not make a transfer for this order.",
        "لن يعود بالإمكان دفع الطلبية. لا تُجرِ أي تحويل لهذه الطلبية."
      ],
      "cancelConfirm": [
        "Annuler la commande",
        "Cancel the order",
        "إلغاء الطلبية"
      ],
      "cancelledToast": [
        "Commande annulée.",
        "Order cancelled.",
        "تم إلغاء الطلبية."
      ],
      "createdToast": [
        "Commande {reference} créée : FlexiPay va la confirmer.",
        "Order {reference} created: FlexiPay will confirm it.",
        "تم إنشاء الطلبية {reference}: ستؤكدها FlexiPay."
      ],
      "kpiWallet": [
        "Solde disponible",
        "Available balance",
        "الرصيد المتاح"
      ],
      "kpiWalletHint": [
        "Crédits prêts à être attribués",
        "Credits ready to allocate",
        "أرصدة جاهزة للتوزيع"
      ],
      "kpiConfirmation": [
        "À confirmer par FlexiPay",
        "To be confirmed by FlexiPay",
        "في انتظار تأكيد FlexiPay"
      ],
      "kpiConfirmationHint": [
        "Aucune action de votre part",
        "No action needed from you",
        "لا يتطلب أي إجراء منك"
      ],
      "kpiPayment": [
        "En attente de votre virement",
        "Waiting for your transfer",
        "في انتظار تحويلك"
      ],
      "kpiPaymentHint": [
        "Virez puis déclarez le virement",
        "Transfer, then declare it",
        "حوّل ثم صرّح بالتحويل"
      ],
      "kpiValidation": [
        "Virements en vérification",
        "Transfers being checked",
        "تحويلات قيد التحقق"
      ],
      "kpiValidationHint": [
        "Crédits ajoutés après validation",
        "Credits added once validated",
        "تُضاف الأرصدة بعد المصادقة"
      ]
    },
    "admin": {
      "title": [
        "Commandes de crédits",
        "Credit orders",
        "طلبيات الأرصدة"
      ],
      "description": [
        "Confirmez les commandes des entreprises, puis validez chaque virement après réception des fonds sur le compte FlexiPay.",
        "Confirm company orders, then validate each transfer once the funds reach the FlexiPay account.",
        "أكّد طلبيات المؤسسات، ثم صادق على كل تحويل بعد وصول الأموال إلى حساب FlexiPay."
      ],
      "toConfirm": [
        "À confirmer",
        "To confirm",
        "للتأكيد"
      ],
      "toValidate": [
        "Virements à vérifier",
        "Transfers to check",
        "تحويلات للتحقق"
      ],
      "showOnly": [
        "Afficher ces commandes",
        "Show these orders",
        "عرض هذه الطلبيات"
      ],
      "allCompanies": [
        "Toutes les entreprises",
        "All companies",
        "كل المؤسسات"
      ],
      "needsAction": [
        "À traiter",
        "To handle",
        "للمعالجة"
      ],
      "apply": [
        "Filtrer",
        "Filter",
        "تصفية"
      ],
      "reset": [
        "Réinitialiser",
        "Reset",
        "إعادة الضبط"
      ],
      "emptyTitle": [
        "Aucune commande pour ces filtres",
        "No orders for these filters",
        "لا توجد طلبيات لهذه المرشحات"
      ],
      "detailTitle": [
        "Commande {reference}",
        "Order {reference}",
        "الطلبية {reference}"
      ],
      "stepConfirm": [
        "Nouvelle commande : confirmez-la pour que l'entreprise puisse faire son virement, ou refusez-la avec un motif.",
        "New order: confirm it so that the company can make its transfer, or refuse it with a reason.",
        "طلبية جديدة: أكّدها لتتمكن المؤسسة من التحويل، أو ارفضها مع ذكر السبب."
      ],
      "stepWaitPayment": [
        "En attente du virement et de la déclaration de l'entreprise.",
        "Waiting for the company's transfer and declaration.",
        "في انتظار تحويل المؤسسة وتصريحها."
      ],
      "stepValidate": [
        "Vérifiez sur le compte FlexiPay que le virement est bien arrivé, puis validez ou rejetez le justificatif.",
        "Check on the FlexiPay account that the transfer arrived, then validate or reject the proof.",
        "تحقق في حساب FlexiPay من وصول التحويل، ثم صادق على الإثبات أو ارفضه."
      ],
      "mismatchTitle": [
        "Montant déclaré différent du montant à virer",
        "Declared amount differs from the amount to transfer",
        "المبلغ المصرّح به يختلف عن المبلغ المراد تحويله"
      ],
      "mismatch": [
        "Déclaré : {declared}. Attendu : {expected}. Écart : {gap}.",
        "Declared: {declared}. Expected: {expected}. Difference: {gap}.",
        "المصرّح به: {declared}. المتوقع: {expected}. الفرق: {gap}."
      ],
      "confirm": [
        "Confirmer la commande",
        "Confirm the order",
        "تأكيد الطلبية"
      ],
      "confirmTitle": [
        "Confirmer la commande {reference} ?",
        "Confirm order {reference}?",
        "تأكيد الطلبية {reference}؟"
      ],
      "confirmMessage": [
        "L'entreprise pourra faire son virement de {amount} et le déclarer.",
        "The company will be able to make its {amount} transfer and declare it.",
        "سيمكن للمؤسسة إجراء تحويلها بقيمة {amount} والتصريح به."
      ],
      "confirmedToast": [
        "Commande confirmée.",
        "Order confirmed.",
        "تم تأكيد الطلبية."
      ],
      "refuse": [
        "Refuser la commande",
        "Refuse the order",
        "رفض الطلبية"
      ],
      "refuseTitle": [
        "Refuser la commande {reference}",
        "Refuse order {reference}",
        "رفض الطلبية {reference}"
      ],
      "refuseReason": [
        "Motif du refus (visible par l'entreprise)",
        "Reason for refusal (shown to the company)",
        "سبب الرفض (يظهر للمؤسسة)"
      ],
      "refusedToast": [
        "Commande refusée.",
        "Order refused.",
        "تم رفض الطلبية."
      ],
      "validate": [
        "Valider le paiement",
        "Validate the payment",
        "المصادقة على الدفع"
      ],
      "validateTitle": [
        "Valider le paiement de {reference} ?",
        "Validate the payment of {reference}?",
        "المصادقة على دفع {reference}؟"
      ],
      "validateMessage": [
        "Confirmez que {amount} sont bien arrivés sur le compte FlexiPay. {credits} de crédits seront ajoutés au solde de {company}.",
        "Confirm that {amount} reached the FlexiPay account. {credits} of credits will be added to the balance of {company}.",
        "أكّد وصول {amount} إلى حساب FlexiPay. ستُضاف أرصدة بقيمة {credits} إلى رصيد {company}."
      ],
      "validatedToast": [
        "Paiement validé : crédits ajoutés au solde de l'entreprise.",
        "Payment validated: credits added to the company's balance.",
        "تمت المصادقة على الدفع: أُضيفت الأرصدة إلى رصيد المؤسسة."
      ],
      "rejectProof": [
        "Rejeter le justificatif",
        "Reject the proof",
        "رفض الإثبات"
      ],
      "rejectTitle": [
        "Rejeter le justificatif de {reference}",
        "Reject the proof of {reference}",
        "رفض إثبات {reference}"
      ],
      "rejectMessage": [
        "La commande repasse en attente de paiement ; l'entreprise voit le motif et peut déclarer à nouveau.",
        "The order goes back to awaiting payment; the company sees the reason and can declare again.",
        "تعود الطلبية إلى انتظار الدفع؛ ترى المؤسسة السبب ويمكنها التصريح من جديد."
      ],
      "rejectReason": [
        "Motif du rejet (visible par l'entreprise)",
        "Reason for rejection (shown to the company)",
        "سبب الرفض (يظهر للمؤسسة)"
      ],
      "rejectReasonHint": [
        "Par exemple : montant reçu différent, virement introuvable.",
        "For example: different amount received, transfer not found.",
        "مثال: مبلغ مستلَم مختلف، تحويل غير موجود."
      ],
      "rejectedToast": [
        "Justificatif rejeté : l'entreprise est invitée à déclarer à nouveau.",
        "Proof rejected: the company is asked to declare again.",
        "تم رفض الإثبات: دُعيت المؤسسة إلى التصريح من جديد."
      ],
      "noDeclaration": [
        "Aucun virement déclaré pour le moment.",
        "No transfer declared yet.",
        "لم يُصرَّح بأي تحويل بعد."
      ],
      "refusedInfo": [
        "Motif du refus : {reason}",
        "Reason for refusal: {reason}",
        "سبب الرفض: {reason}"
      ],
      "lastRejection": [
        "Dernier justificatif rejeté : {reason}",
        "Last proof rejected: {reason}",
        "آخر إثبات مرفوض: {reason}"
      ]
    },
    "reasonRequired": [
      "Le motif est obligatoire.",
      "A reason is required.",
      "السبب إلزامي."
    ],
    "conflict": [
      "Cette commande a changé entre-temps : la page a été actualisée.",
      "This order changed in the meantime: the page was refreshed.",
      "تغيّرت هذه الطلبية في الأثناء: تم تحديث الصفحة."
    ]
  }
};
