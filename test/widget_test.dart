import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:manul_time/app.dart';
import 'package:manul_time/core/constants/app_constants.dart';

void main() {
  testWidgets('App renders and shows initial counter', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: ManulTimeApp()),
    );
    // Initial counter should be "Manul #0"
    expect(find.textContaining('Manul #'), findsOneWidget);
  });

  test('formatCount formats numbers with commas', () {
    expect(AppConstants.formatCount(BigInt.zero), '0');
    expect(AppConstants.formatCount(BigInt.from(1234)), '1,234');
    expect(AppConstants.formatCount(BigInt.from(1234567)), '1,234,567');
  });
}
