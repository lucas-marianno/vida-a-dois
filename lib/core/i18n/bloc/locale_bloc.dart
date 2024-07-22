import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/core/util/logger/logger.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  late Locale _locale;

  LocaleBloc() : super(LocaleLoading()) {
    on<Initialize>(_onInitialize);
    on<ChangeLocaleEvent>(_onChangeLocaleEvent);
  }
  _onInitialize(Initialize event, Emitter<LocaleState> emit) {
    Log.initializing(LocaleBloc);
    emit(LocaleLoading());
    _locale = L10n.locale;
    add(ChangeLocaleEvent(_locale));
  }

  _onChangeLocaleEvent(ChangeLocaleEvent event, Emitter<LocaleState> emit) {
    Log.trace("$LocaleBloc $ChangeLocaleEvent \n $event");

    if (!L10n.all.contains(event.locale)) {
      Log.trace("Unimplemented locale: ${event.locale}");
      return;
    }

    _locale = event.locale;
    emit(LocaleLoaded(_locale));

    Log.info(
      "$LocaleBloc $ChangeLocaleEvent $LocaleLoaded\n"
      "Locale changed to: ${event.locale}",
    );
  }
}
