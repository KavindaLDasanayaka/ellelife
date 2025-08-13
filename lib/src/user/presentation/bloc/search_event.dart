part of 'search_bloc.dart';

sealed class SearchEvent {}

final class SerachUserEvent extends SearchEvent {
  final String queary;

  SerachUserEvent({required this.queary});
}
