import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        super(AuthInitial()) {
    on<AuthSignUp>(_signUp);
    on<AuthSignIn>(_signIn);
  }

  void _signUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _userSignUp.call(UserSignUpParams(
      name: event.name,
      email: event.email,
      password: event.password,
    ));
    result.fold(
      (l) => emit(AuthFailure(message: l.message)),
      (r) => emit(AuthSuccess(user: r)),
    );
  }

  void _signIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _userSignIn.call(UserSignInParams(
      email: event.email,
      password: event.password,
    ));
    result.fold(
      (l) => emit(AuthFailure(message: l.message)),
      (r) => emit(AuthSuccess(user: r)),
    );
  }
}
