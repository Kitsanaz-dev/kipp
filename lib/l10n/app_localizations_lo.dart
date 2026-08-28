// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Lao (`lo`).
class AppLocalizationsLo extends AppLocalizations {
  AppLocalizationsLo([String locale = 'lo']) : super(locale);

  @override
  String get signIn => 'ເຂົ້າສູ່ລະບົບ';

  @override
  String get signInSubtitle => 'ຍິນດີຕ້ອນຮັບກັບມາ';

  @override
  String get signUp => 'ສະໝັກສະມາຊິກ';

  @override
  String get signUpSubtitle => 'ສ້າງບັນຊີໃໝ່ເພື່ອເລີ່ມຄວບຄຸມການເງິນ';

  @override
  String get email => 'ອີເມວ';

  @override
  String get password => 'ລະຫັດຜ່ານ';

  @override
  String get confirmPassword => 'ຢືນຢັນລະຫັດຜ່ານ';

  @override
  String get fullName => 'ຊື່ເຕັມ';

  @override
  String get login => 'ເຂົ້າສູ່ລະບົບ';

  @override
  String get dontHaveAccount => 'ຍັງບໍ່ມີບັນຊີ? ';

  @override
  String get alreadyHaveAccount => 'ມີບັນຊີແລ້ວ? ';

  @override
  String get rememberMe => 'ຈື່ຂ້ອຍໄວ້';

  @override
  String get forgotPassword => 'ລືມລະຫັດຜ່ານ?';

  @override
  String get welcomeUser => 'ຍິນດີຕ້ອນຮັບ';

  @override
  String get todaysBalance => 'ຍອດເງິນມື້ນີ້';

  @override
  String get thisWeeksBalance => 'ຍອດເງິນອາທິດນີ້';

  @override
  String get thisMonthsBalance => 'ຍອດເງິນເດືອນນີ້';

  @override
  String get income => 'ລາຍຮັບ';

  @override
  String get expenses => 'ລາຍຈ່າຍ';

  @override
  String get today => 'ມື້ນີ້';

  @override
  String get thisWeek => 'ອາທິດນີ້';

  @override
  String get thisMonth => 'ເດືອນນີ້';

  @override
  String get yesterday => 'ມື້ວານ';

  @override
  String get noTransactions => 'ຍັງບໍ່ມີລາຍການ';

  @override
  String get noTransactionsOnThisDay => 'ບໍ່ມີລາຍການໃນວັນນີ້';

  @override
  String get home => 'ຫນ້າຫຼັກ';

  @override
  String get addTransaction => 'ເພີ່ມລາຍການ';

  @override
  String get amount => 'ຈຳນວນເງິນ';

  @override
  String get type => 'ປະເພດ';

  @override
  String get selectType => 'ເລືອກປະເພດ';

  @override
  String get description => 'ຄຳອະທິບາຍ';

  @override
  String get save => 'ບັນທຶກ';

  @override
  String get savedSuccessfully => 'ບັນທຶກສຳເລັດແລ້ວ';

  @override
  String saveFailed(String error) {
    return 'ບໍ່ສາມາດບັນທຶກໄດ້: $error';
  }

  @override
  String get pleaseEnterAmount => 'ກະລຸນາປ້ອນຈຳນວນເງິນ';

  @override
  String get pleaseEnterValidNumber => 'ກະລຸນາປ້ອນຕົວເລກທີ່ຖືກຕ້ອງ';

  @override
  String get amountMustBeGreaterThanZero => 'ຈຳນວນເງິນຕ້ອງຫຼາຍກວ່າ 0';

  @override
  String get pleaseSelectType => 'ກະລຸນາເລືອກປະເພດ';

  @override
  String get history => 'ປະຫວັດ';

  @override
  String get profile => 'ໂປຣໄຟລ໌';

  @override
  String get editProfileInfo => 'ແກ້ໄຂຂໍ້ມູນໂປຣໄຟລ໌';

  @override
  String get theme => 'ຮູບແບບສີ';

  @override
  String get themeLight => 'ໂໝດແຈ້ງ';

  @override
  String get themeDark => 'ໂໝດມືດ';

  @override
  String get themeSystem => 'ຕາມລະບົບ';

  @override
  String get language => 'ພາສາ';

  @override
  String get logOut => 'ອອກຈາກລະບົບ';

  @override
  String get logOutConfirm => 'ທ່ານແນ່ໃຈບໍ່ວ່າຢາກອອກຈາກລະບົບ?';

  @override
  String get cancel => 'ຍົກເລີກ';

  @override
  String get totalIncome => 'ລາຍຮັບທັງໝົດ';

  @override
  String get totalExpense => 'ລາຍຈ່າຍທັງໝົດ';
}
