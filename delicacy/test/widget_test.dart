import 'package:flutter_test/flutter_test.dart';
import 'package:delicacy/main.dart';

void main() {
  testWidgets('Home opens the report form and validates required fields',
      (tester) async {
    await tester.pumpWidget(const SemesterProjectApp());
    await tester.pumpAndSettle();

    expect(find.text('Delicacy System'), findsOneWidget);
    await tester.tap(find.text('Report delicacy information'));
    await tester.pumpAndSettle();

    expect(find.text('Report a delicacy'), findsOneWidget);
    await tester.ensureVisible(find.text('Submit report'));
    await tester.tap(find.text('Submit report'));
    await tester.pumpAndSettle();

    expect(find.text('Enter the delicacy name'), findsOneWidget);
    expect(
      find.text('Describe what information is missing or incorrect'),
      findsOneWidget,
    );
  });
}
