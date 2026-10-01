package com.xef.backend.dto.catalogo;

import com.xef.backend.entity.RecetaIngrediente;
import com.xef.backend.entity.enums.UnidadMedida;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecetaIngredienteDTO {

    private Long id;

    @NotNull(message = "El id del ingrediente es obligatorio")
    private Long ingredienteId;

    private String ingredienteNombre;

    @NotNull(message = "La cantidad es obligatoria")
    private Double cantidad;

    @NotNull(message = "La unidad de medida es obligatoria")
    private UnidadMedida unidadMedida;

    private Double caloriasAporte;
    private Double proteinasAporte;
    private Double carbohidratosAporte;
    private Double grasasAporte;

    public static RecetaIngredienteDTO fromEntity(RecetaIngrediente ri) {
        double factor = ri.getCantidad() != null ? ri.getCantidad() / 100.0 : 0.0;
        var ing = ri.getIngrediente();

        return RecetaIngredienteDTO.builder()
                .id(ri.getId())
                .ingredienteId(ing != null ? ing.getId() : null)
                .ingredienteNombre(ing != null ? ing.getNombre() : null)
                .cantidad(ri.getCantidad())
                .unidadMedida(ri.getUnidadMedida())
                .caloriasAporte(ing != null && ing.getCaloriasPor100g() != null ? Math.round(ing.getCaloriasPor100g() * factor * 100.0) / 100.0 : 0.0)
                .proteinasAporte(ing != null && ing.getProteinasPor100g() != null ? Math.round(ing.getProteinasPor100g() * factor * 100.0) / 100.0 : 0.0)
                .carbohidratosAporte(ing != null && ing.getCarbohidratosPor100g() != null ? Math.round(ing.getCarbohidratosPor100g() * factor * 100.0) / 100.0 : 0.0)
                .grasasAporte(ing != null && ing.getGrasasPor100g() != null ? Math.round(ing.getGrasasPor100g() * factor * 100.0) / 100.0 : 0.0)
                .build();
    }
}
