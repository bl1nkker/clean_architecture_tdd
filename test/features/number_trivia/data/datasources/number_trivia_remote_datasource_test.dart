import 'dart:convert';

import 'package:clean_architecture_tdd/core/error/exceptions.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import '../../../../fixtures/reader.dart';
import 'number_trivia_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late NumberTriviaRemoteDataSourceImpl dataSource;

  setUp(() {
    mockClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    const int tNumber = 1;
    final NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

    test('''should perform a GET request on a URL with number 
        being endpoint and with application/json header''', () {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockClient.get(Uri.parse('http://numberapi.com/$tNumber'),
          headers: {'Content-type': "application/json"}));
    });

    test('should return a numberTrivia when the status code is success',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      expect(result, equals(tNumberTriviaModel));
    });
    test('should throw a ServerException when the status code is failure',
        () async {
      // arrange
      setUpMockHttpClientFailure404();
      // act
      final call = dataSource.getConcreteNumberTrivia;
      // assert
      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });
  group('getRandomNumberTrivia', () {
    final NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

    test('''should perform a GET request on a URL with number 
        being endpoint and with application/json header''', () {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      dataSource.getRandomNumberTrivia();
      // assert
      verify(mockClient.get(Uri.parse('http://numberapi.com/random'),
          headers: {'Content-type': "application/json"}));
    });

    test('should return a numberTrivia when the status code is success',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result = await dataSource.getRandomNumberTrivia();
      // assert
      expect(result, equals(tNumberTriviaModel));
    });
    test('should throw a ServerException when the status code is failure',
        () async {
      // arrange
      setUpMockHttpClientFailure404();
      // act
      final call = dataSource.getRandomNumberTrivia;
      // assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
