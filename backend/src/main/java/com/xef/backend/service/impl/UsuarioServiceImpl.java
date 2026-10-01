package com.xef.backend.service.impl;

import com.xef.backend.dto.user.UpdateProfileRequest;
import com.xef.backend.dto.user.UserProfileResponse;
import com.xef.backend.entity.Usuario;
import com.xef.backend.exception.ResourceNotFoundException;
import com.xef.backend.repository.UsuarioRepository;
import com.xef.backend.service.UsuarioService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UsuarioServiceImpl implements UsuarioService {

    private final UsuarioRepository usuarioRepository;

    @Override
    @Transactional(readOnly = true)
    public UserProfileResponse obtenerPerfilPorEmail(String email) {
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado con correo: " + email));

        return UserProfileResponse.fromEntity(usuario);
    }

    @Override
    @Transactional
    public UserProfileResponse actualizarPerfil(String email, UpdateProfileRequest request) {
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado con correo: " + email));

        usuario.setNombre(request.getNombre());
        usuario.setApellido(request.getApellido());
        usuario.setSexo(request.getSexo());
        usuario.setEdad(request.getEdad());
        usuario.setAlturaCm(request.getAlturaCm());
        usuario.setPesoKg(request.getPesoKg());
        usuario.setNivelExperiencia(request.getNivelExperiencia());
        usuario.setObjetivoFisico(request.getObjetivoFisico());
        usuario.setEquipamientoDisponible(request.getEquipamientoDisponible());
        usuario.setDisponibilidadMinutosDia(request.getDisponibilidadMinutosDia());
        usuario.setRestriccionesAlimentarias(request.getRestriccionesAlimentarias());

        usuario.calcularImc();
        Usuario usuarioActualizado = usuarioRepository.save(usuario);

        return UserProfileResponse.fromEntity(usuarioActualizado);
    }
}
