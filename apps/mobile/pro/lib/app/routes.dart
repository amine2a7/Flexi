/// Chemins de l'app Pro.
abstract final class ProRoutes {
  static const login = '/';
  static const catalog = '/catalogue';
  static const collect = '/collect';
  static const waiting = '/collect/waiting';
  static const result = '/collect/result';
  static const registers = '/team/registers';
  static const sticker = '/team/registers/sticker';
  static const day = '/day';
  static const balance = '/balance';
  static const payouts = '/payouts';
  static const team = '/team';

  /// Écrans réservés au propriétaire.
  static const ownerOnly = {balance, payouts, team, registers, sticker};

  static const public = {login, catalog};
}
