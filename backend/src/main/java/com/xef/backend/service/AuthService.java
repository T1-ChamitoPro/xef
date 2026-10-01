package com.xef.backend.service;

import com.xef.backend.dto.auth.*;

public interface AuthService {

    AuthResponse registrarUsuario(RegisterRequest request);

    AuthResponse login(LoginRequest request);

    String solicitarRestablecimientoPassword(ForgotPasswordRequest request);

    void restablecerPassword(ResetPasswordRequest request);
}
