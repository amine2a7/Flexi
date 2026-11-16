/// Chemins de l'app bénéficiaire.
abstract final class Routes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const newPassword = '/login/new-password';
  static const createPin = '/login/create-pin';
  static const changePin = '/change-pin';
  static const unlock = '/unlock';
  static const forgotPassword = '/forgot-password';
  static const locked = '/locked';
  static const catalog = '/catalogue';
  static const help = '/help';

  static const home = '/home';
  static const discover = '/discover';
  static const history = '/history';
  static const profile = '/profile';

  static String credit(String type) => '/home/credit/$type';
  static const pay = '/pay';
  static const payConfirm = '/pay/confirm';
  static const payApproved = '/pay/approved';
  static const payRefused = '/pay/refused';
  static String receipt(String id) => '/receipt/$id';
  static const notifications = '/notifications';
  static const family = '/family';
  static const familyAdd = '/family/add';
  static String familyMember(String id) => '/family/member/$id';

  /// Routes accessibles sans session déverrouillée.
  static const public = {
    splash,
    onboarding,
    login,
    newPassword,
    createPin,
    unlock,
    forgotPassword,
    locked,
    catalog,
    help,
  };
}
