import 'package:clean_architecture_tdd/core/util/input_converter.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'number_trivia_bloc_test.mocks.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([GetConcreteNumberTrivia])
@GenerateMocks([GetRandomNumberTrivia])
@GenerateMocks([InputConverter])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initial state should be Empty', () {
    // assert
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const String tNumberString = '1';
    const int tNumberParsed = 1;
    const NumberTrivia tNumberTrivia =
        NumberTrivia(text: 'test trivia', number: tNumberParsed);
    test(
        'should call the inputConverter to validate and convert the string to an unsigned integer',
        () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenAnswer((_) => const Right(tNumberParsed));
      // act
      bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      // assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });
    test('should emit [Error] when the input is invalid', () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenAnswer((_) => Left(InvalidInputFailure()));

      // assert later
      final expected = [
        // Empty(),
        const Error(message: invalidInputFailureMessage)
      ];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
      // act
      bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
    });
  });
}
