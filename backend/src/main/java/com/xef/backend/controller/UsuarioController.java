package com.xef.backend.controller;

import com.xef.backend.dto.response.ApiResponse;
import com.xef.backend.dto.user.UpdateProfileRequest;
import com.xef.backend.dto.user.UserProfileResponse;
import com.xef.backend.service.UsuarioService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/usuarios")
@RequiredArgsConstructor
public class UsuarioController {

    private final UsuarioService usuarioService;

    @GetMapping("/perfil")
    public ResponseEntity<ApiResponse<UserProfileResponse>> obtenerPerfil(Authentication authentication) {
        String email = authentication.getName();
        UserProfileResponse perfil = usuarioService.obtenerPerfilPorEmail(email);
        return ResponseEntity.ok(ApiResponse.ok("Perfil obtenido exitosamente", perfil));
    }

    @PutMapping("/perfil")
    public ResponseEntity<ApiResponse<UserProfileResponse>> actualizarPerfil(
            Authentication authentication,
            @Valid @RequestBody UpdateProfileRequest request) {
        String email = authentication.getName();
        UserProfileResponse perfilActualizado = usuarioService.actualizarPerfil(email, request);
        return ResponseEntity.ok(ApiResponse.ok("Perfil y métricas actualizadas correctamente", perfilActualizado));
    }
}
