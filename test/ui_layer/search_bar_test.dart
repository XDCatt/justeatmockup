import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justeatmockup/widgets/search_bar.dart' as search_bar;

void main() {
  testWidgets('SearchBar displays label and triggers onSearch', (WidgetTester tester) async {

    final controller = TextEditingController();
    var wasSearchCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: search_bar.SearchBar(
            controller: controller,
            labelText: 'Enter postcode',
            onSearch: () {
              wasSearchCalled = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Enter postcode'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'EC4M7RF');
    expect(controller.text, 'EC4M7RF');

    await tester.tap(find.text('Search'));
    await tester.pump(); // Rebuild after tap

    expect(wasSearchCalled, isTrue);

    wasSearchCalled = false; // Reset
    await tester.enterText(find.byType(TextField), 'W1D3QF');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(wasSearchCalled, isTrue);
  });
}
