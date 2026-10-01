package com.xef.backend.dto.catalogo;

import com.xef.backend.entity.Ejercicio;
import com.xef.backend.entity.enums.Disciplina;
import com.xef.backend.entity.enums.GrupoMuscular;
import com.xef.backend.entity.enums.NivelExperiencia;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EjercicioDTO {

    private Long id;

    @NotBlank(message = "El nombre del ejercicio es obligatorio")
    private String nombre;

    private String descripcion;

    @NotNull(message = "El grupo muscular es obligatorio")
    private GrupoMuscular grupoMuscular;

    @NotNull(message = "La disciplina es obligatoria")
    private Disciplina disciplina;

    @NotNull(message = "La dificultad es obligatoria")
    private NivelExperiencia dificultad;

    private String equipamientoRequerido;
    private String guiaInstrucciones;
    private String multimediaUrl;
    private Double caloriasPorMinuto;
    private Boolean activo;

    public static EjercicioDTO fromEntity(Ejercicio e) {
        return EjercicioDTO.builder()
                .id(e.getId())
                .nombre(e.getNombre())
                .descripcion(e.getDescripcion())
                .grupoMuscular(e.getGrupoMuscular())
                .disciplina(e.getDisciplina())
                .dificultad(e.getDificultad())
                .equipamientoRequerido(e.getEquipamientoRequerido())
                .guiaInstrucciones(e.getGuiaInstrucciones())
                .multimediaUrl(e.getMultimediaUrl())
                .caloriasPorMinuto(e.getCaloriasPorMinuto())
                .activo(e.getActivo())
                .build();
    }
}
