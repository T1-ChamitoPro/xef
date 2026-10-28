import '../constants/app_constants.dart';

class AppDateUtils {
  AppDateUtils._();

  static String getDiaActual() {
    return AppConstants.diasSemana[DateTime.now().weekday - 1];
  }
}
