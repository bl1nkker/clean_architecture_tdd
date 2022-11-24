import 'dart:convert';

import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/reader.dart';

void main() {
  const NumberTriviaModel tNumberTriviaModel =
      NumberTriviaModel(number: 1, text: 'Hello World');
  setUp(() {});

  test('should be a subclass of NumberTrivia entity', () {
    // assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON number is an integer',
        () async {
      // arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia.json'));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, isA<NumberTriviaModel>());
      expect(result.number, jsonMap['number']);
      expect(result.text, jsonMap['text']);
    });
    test(
        'should return a valid model when the JSON number is regarded as a double',
        () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('trivia_double.json'));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, isA<NumberTriviaModel>());
      expect(result.number, (jsonMap['number'] as num).toInt());
      expect(result.text, jsonMap['text']);
    });
  });
  group('toJson', () {
    test('should return a JSON map containing a proper data', () async {
      // arrange
      // act
      final result = tNumberTriviaModel.toJson();
      // assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result["text"], tNumberTriviaModel.text);
      expect(result["number"], tNumberTriviaModel.number);
    });
  });
}
