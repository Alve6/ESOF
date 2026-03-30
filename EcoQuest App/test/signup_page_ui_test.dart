import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:namer_app/pages/signup_page.dart';

void main() {
  testWidgets('renders sign up UI correctly', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2000));

    await tester.pumpWidget(
      MaterialApp(
        home: SignUpPage(swapPages: () {}),
      ),
    );

    expect(find.text('Create an account'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(4));
    expect(find.textContaining('Already have an account'), findsOneWidget);
  });

  testWidgets('shows error when passwords do not match', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SignUpPage(swapPages: () {}),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), 'TestUser');
    await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'pass123');
    await tester.enterText(find.byType(TextField).at(3), 'wrongpass');

    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    expect(find.text('Error: passwords do not match'), findsOneWidget);
  });

  testWidgets('calls swapPages when tapping "Log in"', (WidgetTester tester) async {
    bool navigated = false;

    await tester.pumpWidget(MaterialApp(
      home: SignUpPage(swapPages: () {
        navigated = true;
      }),
    ));

    await tester.tap(find.text('Log in'));
    await tester.pump();

    expect(navigated, isTrue);
  });
}
