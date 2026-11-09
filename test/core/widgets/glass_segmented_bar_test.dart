import 'package:flutter_test/flutter_test.dart';
import 'package:kipp/core/widgets/glass_segmented_bar.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('renders labels and reports the tapped index', (tester) async {
    int? tapped;
    await pumpApp(
      tester,
      GlassSegmentedBar(
        labels: const ['A', 'B', 'C', 'D'],
        selectedIndex: 0,
        onSelected: (i) => tapped = i,
      ),
    );
    for (final l in ['A', 'B', 'C', 'D']) {
      expect(find.text(l), findsOneWidget);
    }
    await tester.tap(find.text('D'));
    expect(tapped, 3);
  });
}
