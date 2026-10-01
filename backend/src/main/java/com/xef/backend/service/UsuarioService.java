package com.xef.backend.service;

import com.xef.backend.dto.user.UpdateProfileRequest;
import com.xef.backend.dto.user.UserProfileResponse;

public interface UsuarioService {

    UserProfileResponse obtenerPerfilPorEmail(String email);

    UserProfileResponse actualizarPerfil(String email, UpdateProfileRequest request);
}
