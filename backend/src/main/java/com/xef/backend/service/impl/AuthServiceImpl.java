package com.xef.backend.service.impl;

import com.xef.backend.dto.auth.*;
import com.xef.backend.entity.PasswordResetToken;
import com.xef.backend.entity.Usuario;
import com.xef.backend.entity.enums.Rol;
import com.xef.backend.exception.BadRequestException;
import com.xef.backend.exception.EmailAlreadyExistsException;
import com.xef.backend.exception.ResourceNotFoundException;
import com.xef.backend.repository.PasswordResetTokenRepository;
import com.xef.backend.repository.UsuarioRepository;
import com.xef.backend.security.JwtUtils;
import com.xef.backend.security.UserDetailsImpl;
import com.xef.backend.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UsuarioRepository usuarioRepository;
    private final PasswordResetTokenRepository passwordResetTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final JwtUtils jwtUtils;

    @Value("${xef.jwt.reset-password-expiration-ms:3600000}")
    private long resetPasswordExpirationMs;

    @Override
    @Transactional
    public AuthResponse registrarUsuario(RegisterRequest request) {
        if (usuarioRepository.existsByEmail(request.getEmail())) {
            throw new EmailAlreadyExistsException("Ya existe una cuenta registrada con el correo: " + request.getEmail());
        }

        Usuario usuario = Usuario.builder()
                .nombre(request.getNombre())
                .apellido(request.getApellido())
                .email(request.getEmail().toLowerCase().trim())
                .password(passwordEncoder.encode(request.getPassword()))
                .rol(Rol.ROLE_USER)
                .sexo(request.getSexo())
                .edad(request.getEdad())
                .alturaCm(request.getAlturaCm())
                .pesoKg(request.getPesoKg())
                .nivelExperiencia(request.getNivelExperiencia())
                .objetivoFisico(request.getObjetivoFisico())
                .equipamientoDisponible(request.getEquipamientoDisponible())
                .disponibilidadMinutosDia(request.getDisponibilidadMinutosDia())
                .restriccionesAlimentarias(request.getRestriccionesAlimentarias())
                .activo(true)
                .build();

        usuario = usuarioRepository.save(usuario);

        String jwtToken = jwtUtils.generateTokenFromEmail(
                usuario.getEmail(),
                usuario.getId(),
                usuario.getRol().name()
        );

        return AuthResponse.builder()
                .token(jwtToken)
                .tipo("Bearer")
                .id(usuario.getId())
                .email(usuario.getEmail())
                .nombre(usuario.getNombre())
                .apellido(usuario.getApellido())
                .rol(usuario.getRol())
                .imc(usuario.getImc())
                .build();
    }

    @Override
    public AuthResponse login(LoginRequest request) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getEmail().toLowerCase().trim(),
                        request.getPassword()
                )
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        String jwtToken = jwtUtils.generateJwtToken(authentication);

        Usuario usuario = usuarioRepository.findById(userDetails.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado"));

        return AuthResponse.builder()
                .token(jwtToken)
                .tipo("Bearer")
                .id(usuario.getId())
                .email(usuario.getEmail())
                .nombre(usuario.getNombre())
                .apellido(usuario.getApellido())
                .rol(usuario.getRol())
                .imc(usuario.getImc())
                .build();
    }

    @Override
    @Transactional
    public String solicitarRestablecimientoPassword(ForgotPasswordRequest request) {
        Usuario usuario = usuarioRepository.findByEmail(request.getEmail().toLowerCase().trim())
                .orElseThrow(() -> new ResourceNotFoundException("No se encontró ningún usuario con el correo proporcionado"));

        // Invalidar tokens previos no usados
        passwordResetTokenRepository.findByUsuarioAndUsadoFalse(usuario).ifPresent(prevToken -> {
            prevToken.setUsado(true);
            passwordResetTokenRepository.save(prevToken);
        });

        String token = UUID.randomUUID().toString();
        LocalDateTime fechaExpiracion = LocalDateTime.now().plusSeconds(resetPasswordExpirationMs / 1000);

        PasswordResetToken resetToken = PasswordResetToken.builder()
                .token(token)
                .usuario(usuario)
                .fechaExpiracion(fechaExpiracion)
                .usado(false)
                .build();

        passwordResetTokenRepository.save(resetToken);

        // En un entorno de producción se enviaría por email; retornamos el token para consumo o notificación
        return token;
    }

    @Override
    @Transactional
    public void restablecerPassword(ResetPasswordRequest request) {
        PasswordResetToken resetToken = passwordResetTokenRepository.findByToken(request.getToken())
                .orElseThrow(() -> new ResourceNotFoundException("El token de restablecimiento no existe o es inválido"));

        if (Boolean.TRUE.equals(resetToken.getUsado())) {
            throw new BadRequestException("Este token de restablecimiento ya ha sido utilizado");
        }

        if (resetToken.estaExpirado()) {
            throw new BadRequestException("El token de restablecimiento ha expirado. Por favor solicite uno nuevo.");
        }

        Usuario usuario = resetToken.getUsuario();
        usuario.setPassword(passwordEncoder.encode(request.getNewPassword()));
        usuarioRepository.save(usuario);

        resetToken.setUsado(true);
        passwordResetTokenRepository.save(resetToken);
    }
}
