part of 'locale_bloc.dart';

sealed class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object> get props => [];
}

final class Initialize extends LocaleEvent {
  final BuildContext context;

  const Initialize(this.context);

  @override
  List<Object> get props => [context];
}

final class ChangeLocaleEvent extends LocaleEvent {
  final Locale locale;

  const ChangeLocaleEvent(this.locale);

  @override
  List<Object> get props => [locale];
}

final class HandleLocaleError extends LocaleEvent {
  final Object error;

  const HandleLocaleError(this.error);

  @override
  List<Object> get props => [error];
}
