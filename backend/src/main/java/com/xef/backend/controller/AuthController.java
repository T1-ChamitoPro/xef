package com.xef.backend.controller;

import com.xef.backend.dto.auth.*;
import com.xef.backend.dto.response.ApiResponse;
import com.xef.backend.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<ApiResponse<AuthResponse>> registrarUsuario(@Valid @RequestBody RegisterRequest request) {
        AuthResponse response = authService.registrarUsuario(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok("Usuario registrado exitosamente", response));
    }

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<AuthResponse>> login(@Valid @RequestBody LoginRequest request) {
        AuthResponse response = authService.login(request);
        return ResponseEntity.ok(ApiResponse.ok("Inicio de sesión exitoso", response));
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<ApiResponse<Map<String, String>>> solicitarRestablecimientoPassword(
            @Valid @RequestBody ForgotPasswordRequest request) {
        String token = authService.solicitarRestablecimientoPassword(request);
        return ResponseEntity.ok(ApiResponse.ok(
                "Instrucciones de recuperación generadas correctamente",
                Map.of(
                        "mensaje", "Se ha generado el token de recuperación.",
                        "token", token
                )
        ));
    }

    @PostMapping("/reset-password")
    public ResponseEntity<ApiResponse<String>> restablecerPassword(
            @Valid @RequestBody ResetPasswordRequest request) {
        authService.restablecerPassword(request);
        return ResponseEntity.ok(ApiResponse.ok("Contraseña restablecida correctamente. Ya puede iniciar sesión con su nueva clave.", null));
    }
}
