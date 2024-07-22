part of 'locale_bloc.dart';

sealed class LocaleState extends Equatable {
  const LocaleState();

  @override
  List<Object> get props => [];
}

final class LocaleLoading extends LocaleState {}

final class LocaleLoaded extends LocaleState {
  final Locale locale;

  const LocaleLoaded(this.locale);

  @override
  List<Object> get props => [locale];
}

final class LocaleErrorState extends LocaleState {
  final Object error;

  const LocaleErrorState(this.error);
  @override
  List<Object> get props => [error];
}
