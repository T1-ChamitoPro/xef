import '../constants/app_constants.dart';

/// Utilidades de fecha y tiempo para la app
class AppDateUtils {
  AppDateUtils._();

  /// Retorna el día de la semana actual en mayúsculas (LUNES..DOMINGO)
  static String getDiaActual() {
    return AppConstants.diasSemana[DateTime.now().weekday - 1];
  }
}
