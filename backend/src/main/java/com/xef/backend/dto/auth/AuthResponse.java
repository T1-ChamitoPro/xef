package com.xef.backend.dto.auth;

import com.xef.backend.entity.enums.Rol;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AuthResponse {

    private String token;
    @Builder.Default
    private String tipo = "Bearer";
    private Long id;
    private String email;
    private String nombre;
    private String apellido;
    private Rol rol;
    private Double imc;
}
