import 'package:clean_architecture_tdd/core/error/exceptions.dart';
import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/core/network/network_info.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks([NumberTriviaRemoteDatasource])
@GenerateMocks([NumberTriviaLocalDatasource])
@GenerateNiceMocks([MockSpec<NetworkInfo>()])
void main() {
  late NumberTriviaRepositoryImpl repository;
  late NumberTriviaRemoteDatasource mockNumberTriviaRemoteDatasource;
  late NumberTriviaLocalDatasource mockNumberTriviaLocalDatasource;
  late NetworkInfo mockNetworkInfo;
  setUp(() {
    mockNumberTriviaRemoteDatasource = MockNumberTriviaRemoteDatasource();
    mockNumberTriviaLocalDatasource = MockNumberTriviaLocalDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
        remoteDatasource: mockNumberTriviaRemoteDatasource,
        localDatasource: mockNumberTriviaLocalDatasource,
        networkInfo: mockNetworkInfo);
  });
  void runTestsOnline(Function body) {
    group('if the device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('if the device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('get concrete number trivia', (() {
    const int tNumber = 1;
    const NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'Test Trivia');
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockNumberTriviaRemoteDatasource.getConcreteNumberTrivia(tNumber))
          .thenAnswer((_) async => tNumberTriviaModel);
      // act
      repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote datasource is successful',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDatasource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(const Right(tNumberTriviaModel)));
        verify(
            mockNumberTriviaRemoteDatasource.getConcreteNumberTrivia(tNumber));
      });

      test('should cache data when the call to remote datasource is successful',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDatasource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(
            mockNumberTriviaRemoteDatasource.getConcreteNumberTrivia(tNumber));
        verify(mockNumberTriviaLocalDatasource
            .cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should throw server failure when the call to remote datasource is unsuccessful',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDatasource.getConcreteNumberTrivia(tNumber))
            .thenThrow(ServerException());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(Left(ServerFailure())));
        verifyZeroInteractions(mockNumberTriviaLocalDatasource);
      });
    });
    runTestsOffline(() {
      test(
          'should return last locally cached data when the cache data is present',
          () async {
        // arrange
        when(mockNumberTriviaLocalDatasource.getLastNumberTrivia())
            .thenAnswer((realInvocation) async => tNumberTriviaModel);
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(const Right(tNumberTriviaModel)));
        verify(mockNumberTriviaLocalDatasource.getLastNumberTrivia());
        verifyZeroInteractions(mockNumberTriviaRemoteDatasource);
      });
      test('should return cache failure when there is no cached data present',
          () async {
        // arrange
        when(mockNumberTriviaLocalDatasource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockNumberTriviaLocalDatasource.getLastNumberTrivia());
        verifyZeroInteractions(mockNumberTriviaRemoteDatasource);
        expect(result, equals(Left(CacheFailure())));
      });
    });
  }));
  group('get random number trivia', (() {
    const int tNumber = 1;
    const NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'Test Trivia');
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      // act
      repository.getRandomNumberTrivia();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote datasource is successful',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        expect(result, equals(const Right(tNumberTriviaModel)));
        verify(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia());
      });

      test('should cache data when the call to remote datasource is successful',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repository.getRandomNumberTrivia();
        // assert
        verify(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia());
        verify(mockNumberTriviaLocalDatasource
            .cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should throw server failure when the call to remote datasource is unsuccessful',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        expect(result, equals(Left(ServerFailure())));
        verifyZeroInteractions(mockNumberTriviaLocalDatasource);
      });
    });
    runTestsOffline(() {
      test(
          'should return last locally cached data when the cache data is present',
          () async {
        // arrange
        when(mockNumberTriviaLocalDatasource.getLastNumberTrivia())
            .thenAnswer((realInvocation) async => tNumberTriviaModel);
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        expect(result, equals(const Right(tNumberTriviaModel)));
        verify(mockNumberTriviaLocalDatasource.getLastNumberTrivia());
        verifyZeroInteractions(mockNumberTriviaRemoteDatasource);
      });
      test('should return cache failure when there is no cached data present',
          () async {
        // arrange
        when(mockNumberTriviaLocalDatasource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verify(mockNumberTriviaLocalDatasource.getLastNumberTrivia());
        verifyZeroInteractions(mockNumberTriviaRemoteDatasource);
        expect(result, equals(Left(CacheFailure())));
      });
    });
  }));
}
