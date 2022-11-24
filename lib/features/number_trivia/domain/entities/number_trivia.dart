import 'package:equatable/equatable.dart';

// Step 1
class NumberTrivia extends Equatable {
  final String text;
  final int number;

  const NumberTrivia({required this.text, required this.number}) : super();

  @override
  List<Object?> get props => [text, number];
}
