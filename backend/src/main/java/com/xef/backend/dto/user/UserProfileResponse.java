package com.xef.backend.dto.user;

import com.xef.backend.entity.Usuario;
import com.xef.backend.entity.enums.NivelExperiencia;
import com.xef.backend.entity.enums.ObjetivoFisico;
import com.xef.backend.entity.enums.Rol;
import com.xef.backend.entity.enums.Sexo;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserProfileResponse {

    private Long id;
    private String nombre;
    private String apellido;
    private String email;
    private Rol rol;
    private Sexo sexo;
    private Integer edad;
    private Double alturaCm;
    private Double pesoKg;
    private Double imc;
    private String clasificacionImc;
    private NivelExperiencia nivelExperiencia;
    private ObjetivoFisico objetivoFisico;
    private String equipamientoDisponible;
    private Integer disponibilidadMinutosDia;
    private String restriccionesAlimentarias;
    private LocalDateTime fechaCreacion;
    private LocalDateTime fechaActualizacion;

    public static UserProfileResponse fromEntity(Usuario u) {
        String clasificacion = "";
        if (u.getImc() != null) {
            double imc = u.getImc();
            if (imc < 18.5) {
                clasificacion = "Bajo peso";
            } else if (imc < 25.0) {
                clasificacion = "Peso normal";
            } else if (imc < 30.0) {
                clasificacion = "Sobrepeso";
            } else {
                clasificacion = "Obesidad";
            }
        }

        return UserProfileResponse.builder()
                .id(u.getId())
                .nombre(u.getNombre())
                .apellido(u.getApellido())
                .email(u.getEmail())
                .rol(u.getRol())
                .sexo(u.getSexo())
                .edad(u.getEdad())
                .alturaCm(u.getAlturaCm())
                .pesoKg(u.getPesoKg())
                .imc(u.getImc())
                .clasificacionImc(clasificacion)
                .nivelExperiencia(u.getNivelExperiencia())
                .objetivoFisico(u.getObjetivoFisico())
                .equipamientoDisponible(u.getEquipamientoDisponible())
                .disponibilidadMinutosDia(u.getDisponibilidadMinutosDia())
                .restriccionesAlimentarias(u.getRestriccionesAlimentarias())
                .fechaCreacion(u.getFechaCreacion())
                .fechaActualizacion(u.getFechaActualizacion())
                .build();
    }
}
