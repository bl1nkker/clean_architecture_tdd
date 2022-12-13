import 'dart:convert';

import 'package:clean_architecture_tdd/core/error/exceptions.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'number_trivia_local_datasource_test.mocks.dart';
import '../../../../fixtures/reader.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    test(
        'should return NumberTrivia from sharedPreferences when there is one in the cache',
        () async {
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(jsonDecode(fixture('trivia_cached.json')));
      // arrange
      when(mockSharedPreferences.getString(any))
          .thenAnswer((realInvocation) => fixture('trivia_cached.json'));
      // act
      final result = await dataSource.getLastNumberTrivia();
      // assert
      verify(mockSharedPreferences.getString(kCachedNumberTrivia));
      expect(result, equals(tNumberTriviaModel));
    });
    test(
        'should throw a CacheException from sharedPreferences when there is nothing in the cache',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any))
          .thenAnswer((realInvocation) => null);
      // act
      final call = dataSource.getLastNumberTrivia;
      // assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });
  group('cacheNumberTrivia', () {
    test('should call sharedPreferences to cache the data', () {
      const tNumberTriviaModel =
          NumberTriviaModel(number: 1, text: 'test trivia');
      // arrange
      when(mockSharedPreferences.setString(
              kCachedNumberTrivia, jsonEncode(tNumberTriviaModel.toJson())))
          .thenAnswer((realInvocation) => Future.value(true));
      // act
      dataSource.cacheNumberTrivia(tNumberTriviaModel);
      // assert
      final expectedJsonString = jsonEncode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
          kCachedNumberTrivia, expectedJsonString));
    });
  });
}
