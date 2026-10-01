package com.xef.backend.repository;

import com.xef.backend.entity.PasswordResetToken;
import com.xef.backend.entity.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PasswordResetTokenRepository extends JpaRepository<PasswordResetToken, Long> {

    Optional<PasswordResetToken> findByToken(String token);

    Optional<PasswordResetToken> findByUsuarioAndUsadoFalse(Usuario usuario);

    void deleteByUsuario(Usuario usuario);
}
