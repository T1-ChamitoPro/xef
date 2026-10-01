package com.xef.backend.dto.catalogo;

import com.xef.backend.entity.Receta;
import com.xef.backend.entity.enums.TipoComida;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecetaDTO {

    private Long id;

    @NotBlank(message = "El nombre de la receta es obligatorio")
    private String nombre;

    private String descripcion;

    @NotNull(message = "El tipo de comida es obligatorio")
    private TipoComida tipoComida;

    private Integer tiempoPreparacionMinutos;

    @Min(value = 1, message = "Las porciones deben ser al menos 1")
    @Builder.Default
    private Integer porciones = 1;

    private String instrucciones;
    private String imagenUrl;

    private Double caloriasTotales;
    private Double proteinasTotales;
    private Double carbohidratosTotales;
    private Double grasasTotales;

    @Valid
    @Builder.Default
    private List<RecetaIngredienteDTO> ingredientes = new ArrayList<>();

    private Boolean activo;

    public static RecetaDTO fromEntity(Receta r) {
        List<RecetaIngredienteDTO> ingDTOs = new ArrayList<>();
        if (r.getIngredientes() != null) {
            ingDTOs = r.getIngredientes().stream()
                    .map(RecetaIngredienteDTO::fromEntity)
                    .toList();
        }

        return RecetaDTO.builder()
                .id(r.getId())
                .nombre(r.getNombre())
                .descripcion(r.getDescripcion())
                .tipoComida(r.getTipoComida())
                .tiempoPreparacionMinutos(r.getTiempoPreparacionMinutos())
                .porciones(r.getPorciones())
                .instrucciones(r.getInstrucciones())
                .imagenUrl(r.getImagenUrl())
                .caloriasTotales(r.getCaloriasTotales())
                .proteinasTotales(r.getProteinasTotales())
                .carbohidratosTotales(r.getCarbohidratosTotales())
                .grasasTotales(r.getGrasasTotales())
                .ingredientes(ingDTOs)
                .activo(r.getActivo())
                .build();
    }
}
