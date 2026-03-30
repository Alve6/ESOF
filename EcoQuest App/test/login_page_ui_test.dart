import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:namer_app/pages/login_page.dart';

void main() {
  testWidgets('renders login UI correctly', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2000));

    await tester.pumpWidget(MaterialApp(
      home: LoginPage(swapPages: () {}),
    ));

    expect(find.text('EcoQuest'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.textContaining("have an account"), findsOneWidget);
  });

  testWidgets('navigates to sign up on tap', (WidgetTester tester) async {
    bool navigated = false;

    await tester.pumpWidget(MaterialApp(
      home: LoginPage(swapPages: () {
        navigated = true;
      }),
    ));

    await tester.tap(find.text('Sign up'));
    await tester.pump();

    expect(navigated, isTrue);
  });
}
