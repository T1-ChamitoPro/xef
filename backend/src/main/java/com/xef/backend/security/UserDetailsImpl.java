package com.xef.backend.security;

import com.xef.backend.entity.Usuario;
import com.xef.backend.entity.enums.Rol;
import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

@AllArgsConstructor
@Getter
public class UserDetailsImpl implements UserDetails {

    private Long id;
    private String email;
    private String password;
    private String nombre;
    private String apellido;
    private Rol rol;
    private Boolean activo;
    private Collection<? extends GrantedAuthority> authorities;

    public static UserDetailsImpl build(Usuario usuario) {
        List<GrantedAuthority> authorities = List.of(
                new SimpleGrantedAuthority(usuario.getRol().name())
        );

        return new UserDetailsImpl(
                usuario.getId(),
                usuario.getEmail(),
                usuario.getPassword(),
                usuario.getNombre(),
                usuario.getApellido(),
                usuario.getRol(),
                usuario.getActivo(),
                authorities
        );
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return Boolean.TRUE.equals(activo);
    }
}
