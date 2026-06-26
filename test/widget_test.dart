import 'package:flutter_test/flutter_test.dart';
import 'package:novacart/main.dart';

void main() {
  testWidgets('app shows the landing screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ShopNestApp());

    expect(find.text('ShopNest'), findsOneWidget);
  });
}
