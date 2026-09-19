import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booyahx/app/app.dart';

void main() {
  testWidgets('BooyahX app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: BooyahXApp()),
    );
    await tester.pumpAndSettle();

    // Verify the app renders without errors
    expect(find.byType(BooyahXApp), findsOneWidget);
  });
}
