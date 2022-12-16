import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/core/usecases/usecase.dart';
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

    void setUpInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenAnswer((_) => const Right(tNumberParsed));
    test(
        'should call the inputConverter to validate and convert the string to an unsigned integer',
        () async {
      // arrange
      setUpInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
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
    test('should get data from the GetConcreteNumberUsecase', () async {
      // arrange
      setUpInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      // act
      bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));

      // assert
      verify(mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      setUpInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      // assert later
      final expected = [Loading(), const Loaded(trivia: tNumberTrivia)];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
      // act
      bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      setUpInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert later
      final expected = [Loading(), const Error(message: serverFailureMessage)];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
      // act
      bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      setUpInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert later
      final expected = [Loading(), const Error(message: cacheFailureMessage)];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
      // act
      bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
    });
  });
  group('GetTriviaForRandomNumber', () {
    const NumberTrivia tNumberTrivia =
        NumberTrivia(text: 'test trivia', number: 1);

    test('should get data from the GetRandomNumberUsecase', () async {
      // arrange
      when(mockGetRandomNumberTrivia(const NoParams()))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));

      // assert
      verify(mockGetRandomNumberTrivia(const NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      // assert later
      final expected = [Loading(), const Loaded(trivia: tNumberTrivia)];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert later
      final expected = [Loading(), const Error(message: serverFailureMessage)];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForRandomNumber());
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert later
      final expected = [Loading(), const Error(message: cacheFailureMessage)];
      expectLater(bloc.stream.asBroadcastStream(), emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
