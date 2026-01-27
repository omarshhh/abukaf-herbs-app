// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'AbuKaf Herbs';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get welcomeTitle => 'أهلاً بك في AbuKaf Herbs';

  @override
  String get registerWelcomeTitle => 'مرحبًا بك في عائلة أبو كف 🌿';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get googleLoginButton => 'الدخول باستخدام Google';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get noAccountRegister => 'ليس لديك حساب؟ أنشئ حسابًا';

  @override
  String get registerTitle => 'إنشاء حساب';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get alreadyHaveAccountLogin => 'لديك حساب؟ تسجيل الدخول';

  @override
  String get errorRequired => 'هذا الحقل مطلوب';

  @override
  String get errorSomethingWrong => 'حدث خطأ، يرجى المحاولة مرة أخرى';

  @override
  String get errorNetwork => 'لا يوجد اتصال بالإنترنت';

  @override
  String get errorUnauthorized => 'غير مصرح لك';

  @override
  String get errorUnknown => 'حدث خطأ غير متوقع';

  @override
  String get errorEmailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get errorInvalidEmail => 'البريد الإلكتروني غير صحيح';

  @override
  String get errorEmailAlreadyUsed => 'البريد الإلكتروني مستخدم مسبقًا';

  @override
  String get errorEmailNotFound => 'لا يوجد حساب بهذا البريد الإلكتروني';

  @override
  String get errorInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة';

  @override
  String get errorPasswordRequired => 'كلمة المرور مطلوبة';

  @override
  String get errorPasswordShort => 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';

  @override
  String get errorPasswordWeak => 'كلمة المرور ضعيفة';

  @override
  String get errorWrongPassword => 'كلمة المرور غير صحيحة';

  @override
  String get errorConfirmPasswordRequired => 'يرجى تأكيد كلمة المرور';

  @override
  String get errorPasswordsNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get errorFirstNameRequired => 'الاسم الأول مطلوب';

  @override
  String get errorLastNameRequired => 'اسم العائلة مطلوب';

  @override
  String get errorPhoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get errorInvalidPhone => 'رقم الهاتف غير صحيح';

  @override
  String get errorPhoneAlreadyUsed => 'رقم الهاتف مستخدم مسبقًا';

  @override
  String get errorLoginFailed => 'فشل تسجيل الدخول';

  @override
  String get errorRegisterFailed => 'فشل إنشاء الحساب';

  @override
  String get errorAccountDisabled => 'تم تعطيل هذا الحساب';

  @override
  String get errorUserNotFound => 'المستخدم غير موجود';

  @override
  String get errorGoogleCanceled => 'تم إلغاء تسجيل الدخول عبر Google';

  @override
  String get errorGoogleFailed => 'فشل تسجيل الدخول عبر Google';

  @override
  String get errorLocationRequired => 'الموقع مطلوب';

  @override
  String get errorLocationDenied => 'تم رفض إذن الموقع';

  @override
  String get errorLocationDisabled => 'خدمات الموقع غير مفعلة';

  @override
  String get errorEmptyCart => 'سلة المشتريات فارغة';

  @override
  String get errorOrderFailed => 'فشل تنفيذ الطلب';

  @override
  String get errorPaymentFailed => 'فشل الدفع';

  @override
  String get locationTitle => 'حدد موقع التوصيل';

  @override
  String get locationMyLocation => 'موقعي';

  @override
  String get locationMoveMapHint => 'حرّك الخريطة وضع الدبوس على بيتك بدقة';

  @override
  String get locationStreetLabel => 'اسم الشارع';

  @override
  String get locationBuildingLabel => 'رقم البناية';

  @override
  String get locationFloorLabel => 'الطابق';

  @override
  String get locationNotesLabel => 'ملاحظات إضافية (اختياري)';

  @override
  String get locationNotesHint => 'مثال: بجانب الصيدلية، مدخل خلفي...';

  @override
  String get locationSaveButton => 'حفظ موقع التوصيل';

  @override
  String get locationServiceDisabled =>
      'خدمة الموقع مطفأة. فعّل GPS ثم أعد المحاولة.';

  @override
  String get locationPermissionDenied =>
      'تم رفض إذن الموقع. يمكنك اختيار الموقع يدويًا من الخريطة.';

  @override
  String get locationPermissionDeniedForever =>
      'تم رفض إذن الموقع نهائيًا. فعِّله من الإعدادات، أو اختر الموقع يدويًا من الخريطة.';

  @override
  String get locationCantGetCurrent => 'تعذر الحصول على موقعك الحالي.';

  @override
  String get locationPickOnMapError => 'حدد موقعك على الخريطة.';

  @override
  String get locationStreetRequired => 'أدخل اسم الشارع.';

  @override
  String get locationBuildingRequired => 'أدخل رقم البناية.';

  @override
  String get locationFloorRequired => 'أدخل رقم الطابق.';

  @override
  String get locationNotLoggedIn => 'المستخدم غير مسجل دخول.';

  @override
  String get locationSavedSuccess => 'تم حفظ موقع التوصيل بنجاح.';

  @override
  String locationSaveFailed(Object error) {
    return 'فشل حفظ الموقع: $error';
  }

  @override
  String get completeProfileTitle => 'إكمال الملف الشخصي';

  @override
  String get completeProfileSubtitle =>
      'يرجى إدخال اسمك ورقم هاتفك لإكمال حسابك.';

  @override
  String get completeProfileSaveButton => 'حفظ وإكمال';

  @override
  String get savedSuccess => 'تم حفظ البيانات';

  @override
  String get followUs => 'تابعنا';

  @override
  String get contactUs => 'تواصل معنا';

  @override
  String get resetPasswordSubtitle =>
      'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور.';

  @override
  String get resetPasswordSendButton => 'إرسال رابط الاستعادة';

  @override
  String get resetPasswordEmailSent =>
      'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني.';

  @override
  String get appTitle => 'أبوكاف للأعشاب';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navOrders => 'الطلبات';

  @override
  String get navProfile => 'حسابي';

  @override
  String get categoriesTitle => 'الفئات';

  @override
  String get ordersTitle => 'طلباتي';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get ordersPlaceholder => 'لا توجد طلبات بعد';

  @override
  String get profilePlaceholder => 'صفحة الحساب (لاحقًا)';

  @override
  String get categoryProductsTitle => 'المنتجات';

  @override
  String categoryProductsSubtitle(String categoryName) {
    return 'منتجات فئة $categoryName';
  }

  @override
  String get catHerbs => 'أعشاب';

  @override
  String get catSpices => 'بهارات';

  @override
  String get catOils => 'زيوت';

  @override
  String get catHoney => 'عسل';

  @override
  String get catCosmetics => 'مستحضرات تجميل';

  @override
  String get catBestSellers => 'الأكثر مبيعًا';

  @override
  String get catBundles => 'البكجات';

  @override
  String get searchHint => 'ابحث عن الأعشاب';

  @override
  String helloUser(Object name) {
    return 'مرحباً، $name';
  }

  @override
  String get ourPicks => 'اخترنالك';

  @override
  String get settings => 'الإعدادات';

  @override
  String get aboutUs => 'من نحن';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get guest => 'زائر';

  @override
  String get forYouTitle => 'من أجلك';

  @override
  String get searchResultsTitle => 'نتائج البحث';

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String get searchStartTyping => 'ابدأ بالكتابة للبحث عن الأعشاب';

  @override
  String get searchResultPlaceholder => 'نتيجة بحث مؤقتة';

  @override
  String get actionViewDetails => 'عرض التفاصيل';

  @override
  String get actionAddToCart => 'إضافة إلى السلة';

  @override
  String get toastAddedToCart => 'تمت الإضافة إلى السلة';

  @override
  String get labelForYou => 'اخترنالك';

  @override
  String get sectionBenefits => 'الفوائد';

  @override
  String get sectionHowToUse => 'طريقة الاستعمال';

  @override
  String get sectionQuantity => 'الكمية';

  @override
  String get labelTotal => 'الإجمالي';

  @override
  String get labelMin => 'الحد الأدنى';

  @override
  String get labelMax => 'الحد الأعلى';

  @override
  String get labelStep => 'الزيادة';

  @override
  String get labelAvailable => 'متاح';

  @override
  String get labelHidden => 'مخفي';

  @override
  String get currencyJOD => 'د.أ';

  @override
  String get placeholderDash => '—';

  @override
  String get unitGram => 'غ';

  @override
  String get unitKilogram => 'كغ';

  @override
  String get unitMilliliter => 'مل';

  @override
  String get unitLiter => 'لتر';

  @override
  String get unitPiece => 'قطعة';

  @override
  String get errorGeneric => 'حدث خطأ';

  @override
  String get noProductsFound => 'لا توجد منتجات';

  @override
  String get noInternetTitle => 'لا يوجد اتصال بالإنترنت';

  @override
  String get noInternetBody => 'تحقق من الاتصال ثم حاول مرة أخرى.';

  @override
  String get navCart => 'السلة';

  @override
  String get cartEmptyTitle => 'سلتك فارغة';

  @override
  String get cartEmptySubtitle => 'أضف منتجات إلى السلة لتظهر هنا.';

  @override
  String get startShopping => 'ابدأ التسوق';

  @override
  String get actionViewCart => 'عرض السلة';

  @override
  String get orderSummaryTitle => 'ملخص الطلب';

  @override
  String get labelSubtotal => 'المجموع الفرعي';

  @override
  String get labelDeliveryFee => 'رسوم التوصيل';

  @override
  String get labelGrandTotal => 'الإجمالي';

  @override
  String get paymentMethodTitle => 'طريقة الدفع';

  @override
  String get paymentCODOnly => 'الدفع عند الاستلام (الخيار الوحيد حالياً)';

  @override
  String get actionCheckout => 'إتمام الطلب';

  @override
  String get checkoutComingSoon => 'قريباً: إتمام الطلب وربط الموقع.';

  @override
  String get labelQty => 'الكمية';

  @override
  String get actionRemove => 'حذف';

  @override
  String get actionShowMore => 'إظهار المزيد';

  @override
  String get actionShowLess => 'إخفاء';

  @override
  String get locationGateTitle => 'الموقع';

  @override
  String get locationSetupTitle => 'تحديد موقعك';

  @override
  String get locationEditTitle => 'تعديل الموقع';

  @override
  String get locationEnterAddress => 'أدخل بيانات العنوان';

  @override
  String get locationGovLabel => 'المحافظة';

  @override
  String get locationAreaLabel => 'المنطقة (مثال: الجبيهة)';

  @override
  String get locationApartmentLabel => 'رقم الشقة';

  @override
  String get locationNextToMap => 'التالي: تحديد الموقع على الخريطة';

  @override
  String get locationPickOnMapTitle => 'تحديد الموقع على الخريطة';

  @override
  String get locationSave => 'حفظ الموقع';

  @override
  String get locationPickFirst => 'يرجى تحديد موقعك على الخريطة أولًا.';

  @override
  String get locationDetecting => 'جاري تحديد موقعك...';

  @override
  String get locationFieldRequired => 'هذا الحقل مطلوب';

  @override
  String get locationChooseGov => 'اختر المحافظة';

  @override
  String get govAmman => 'عمان';

  @override
  String get govIrbid => 'إربد';

  @override
  String get govZarqa => 'الزرقاء';

  @override
  String get govBalqa => 'البلقاء';

  @override
  String get govMafraq => 'المفرق';

  @override
  String get govJerash => 'جرش';

  @override
  String get govAjloun => 'عجلون';

  @override
  String get govMadaba => 'مادبا';

  @override
  String get govKarak => 'الكرك';

  @override
  String get govTafilah => 'الطفيلة';

  @override
  String get govMaan => 'معان';

  @override
  String get govAqaba => 'العقبة';

  @override
  String get locationPermissionTitle => 'مطلوب إذن الموقع';

  @override
  String get locationPermissionRequiredMessage =>
      'لا يمكن للتطبيق العمل بدون إذن الموقع. يرجى السماح بالوصول إلى الموقع للمتابعة.';

  @override
  String get locationPermissionDeniedForeverMessage =>
      'تم رفض إذن الموقع بشكل دائم. يرجى فتح الإعدادات ومنح الإذن للمتابعة.';

  @override
  String get locationServiceDisabledMessage =>
      'خدمات الموقع (GPS) متوقفة. يرجى تفعيلها للمتابعة.';

  @override
  String get locationRequestAgain => 'طلب الإذن مرة أخرى';

  @override
  String get actionOpenSettings => 'فتح الإعدادات';

  @override
  String get locationWaitingPermission => 'بانتظار منح إذن الموقع...';

  @override
  String get actionRetry => 'إعادة المحاولة';

  @override
  String get actionBack => 'رجوع';

  @override
  String get locationMissingInProfile =>
      'لا يمكن حساب التوصيل لأن بيانات الموقع غير مكتملة. يرجى تحديد موقعك أولاً.';

  @override
  String get labelItems => 'عدد العناصر';

  @override
  String get orderStatusPending => 'قيد المعالجة';

  @override
  String get orderStatusPreparing => 'قيد التحضير';

  @override
  String get orderStatusDelivering => 'قيد التوصيل';

  @override
  String get orderStatusDelivered => 'تم التسليم';

  @override
  String get orderStatusCancelled => 'ملغي';

  @override
  String get orderCancelledSuccess => 'تم إلغاء الطلب بنجاح.';

  @override
  String get orderItemsUnknown => 'العناصر غير متاحة';

  @override
  String get actionCancelOrder => 'إلغاء الطلب';

  @override
  String get actionContactUs => 'تواصل معنا';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get phone => 'الهاتف';

  @override
  String get address => 'العنوان';

  @override
  String get notSet => 'غير محدد';

  @override
  String get noAddress => 'لا يوجد عنوان';

  @override
  String get editName => 'تعديل الاسم';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get save => 'حفظ';

  @override
  String get edit => 'تعديل';

  @override
  String get failedToSave => 'فشل الحفظ';

  @override
  String get featureNotAvailableYet => 'هذه الميزة غير متاحة حاليًا';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get buildingShort => 'عمارة';

  @override
  String get apartmentShort => 'شقة';

  @override
  String get accountLabel => 'حساب مستخدم';

  @override
  String get myInfoTitle => 'معلوماتي';

  @override
  String get myInfoSubtitle => 'عرض وتعديل بياناتك';

  @override
  String get myNameLabel => 'اسمي';

  @override
  String get myPhoneLabel => 'رقمي';

  @override
  String get myLocationLabel => 'موقعي';

  @override
  String get confirmChangeLanguageTitle => 'تأكيد تغيير اللغة';

  @override
  String get confirmChangeLanguageBody => 'هل تريد تغيير لغة التطبيق؟';

  @override
  String get confirmChangeLanguageCta => 'تغيير';

  @override
  String get confirmLogoutTitle => 'تأكيد تسجيل الخروج';

  @override
  String get confirmLogoutBody => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get confirmLogoutCta => 'خروج';

  @override
  String get editPhone => 'تعديل الرقم';

  @override
  String get editLocation => 'تعديل الموقع';

  @override
  String get continueText => 'متابعة';

  @override
  String get editWarningOutForDelivery =>
      'تنبيه: التعديل لا ينطبق على الطلبات التي خرجت للتوصيل.';

  @override
  String get invalidPhone => 'رقم غير صحيح';

  @override
  String get aboutUsBody =>
      'عطارة أبو كف - فرع ضاحية الياسمين \"وجهتكم الأولى في ضاحية الياسمين لكل ما تقدمه الطبيعة من خيرات. نحن في عطارة أبو كف نفخر بتقديم أجود أنواع الأعشاب الطبية، والبهارات الطازجة التي تضفي نكهة أصيلة لمائدتكم، بالإضافة إلى تشكيلة واسعة من المكسرات الفاخرة، الزيوت الطبيعية، ومنتجات العناية بالبشرة والشعر. نجمع بين الخبرة الطويلة والجودة العالية لنلبي كافة احتياجاتكم الصحية والغذائية.\"';

  @override
  String get close => 'إغلاق';

  @override
  String get cancel => 'إلغاء';

  @override
  String get buildingLabel => 'عمارة';

  @override
  String get apartmentLabel => 'شقة';

  @override
  String get phoneMax10Digits => 'الحد الأقصى 10 أرقام';

  @override
  String get phoneAlreadyUsed => 'هذا الرقم مستخدم';

  @override
  String get phoneAvailable => 'الرقم متاح';

  @override
  String get checkingPhone => 'جاري التحقق من الرقم...';

  @override
  String get searchNoResults => 'لا توجد نتائج';

  @override
  String get ordersEmptyTitle => 'ما عندك طلبات لسه';

  @override
  String get ordersEmptySubtitle =>
      'اطلب أول طلب عشان تشوفه هون وتتابع حالته بسهولة.';

  @override
  String get ordersEmptyCta => 'تصفّح المنتجات';

  @override
  String get orderLabel => 'طلب';

  @override
  String get orderStatusLabel => 'الحالة';

  @override
  String get commonErrorTitle => 'صار خطأ';

  @override
  String get commonErrorPrefix => 'الخطأ';

  @override
  String get cancelOrderDialogTitle => 'إلغاء الطلب؟';

  @override
  String get cancelOrderDialogBody =>
      'هل أنت متأكد أنك تريد إلغاء هذا الطلب؟ لا يمكن التراجع عن هذه العملية.';

  @override
  String get actionKeepOrder => 'تراجع';

  @override
  String get actionConfirmCancel => 'إلغاء الطلب';
}
