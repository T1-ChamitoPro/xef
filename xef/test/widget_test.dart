import 'package:flutter_test/flutter_test.dart';
import 'package:xef/main.dart';

void main() {
  testWidgets('XefApp smoke test', (WidgetTester tester) async {
    // Verificar que XefApp se instancia correctamente
    const app = XefApp();
    expect(app, isNotNull);
  });
}
