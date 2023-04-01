import 'package:cooking_app_flutter/core/infrastructure/auth/firebase_auth_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'firebase_auth_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FirebaseAuth>()])
void main() {
	late FirebaseAuth firebaseAuth;
	late FirebaseAuthManager manager;

	setUp(() {
		firebaseAuth = MockFirebaseAuth();
		manager = FirebaseAuthManager(firebaseAuth);
	});

	test("authState observes authStateChanges", () async {
		when(firebaseAuth.authStateChanges()).thenAnswer((_) => Stream.value(null));
		await manager.authState.single;
		verify(firebaseAuth.authStateChanges()).called(1);
	});

	test("currentUser calls firebaseAuth currentUser", () {
		manager.currentUser;
		verify(firebaseAuth.currentUser).called(1);
	});

	test("createUserWithEmailAndPassword calls firebaseAuth createUserWithEmailAndPassword with proper arguments", () async {
		const email = "email";
		const password = "password";
		await manager.createUserWithEmailAndPassword(email: email, password: password);
		verify(firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).called(1);
	});

	test("updateDisplayNameWithName calls updateDisplayName with both names", () async {
		const firstName = "firstName";
		const lastName = "lastName";
		const displayValue = "$firstName $lastName";
		await manager.updateDisplayNameWithName(firstName: firstName, lastName: lastName);
		verify(firebaseAuth.currentUser?.updateDisplayName(displayValue)).called(1);
	});

	test("updateDisplayNameWithDisplayValue calls updateDisplayName with argument passed", () async {
		const displayValue = "displayValue";
		await manager.updateDisplayNameWithDisplayValue(displayValue: displayValue);
		verify(firebaseAuth.currentUser?.updateDisplayName(displayValue)).called(1);
	});

	test("signInWithEmailAndPassword calls firebaseAuth signInWithEmailAndPassword with proper params", () async {
		const email = "email";
		const password = "password";
		await manager.signInWithEmailAndPassword(email: email, password: password);
		verify(firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).called(1);
	});

	test("signOut calls firebaseAuth signOut", () async {
		await manager.signOut();
		verify(firebaseAuth.signOut()).called(1);
	});
}
