package com.xef.backend.dto.catalogo;

import com.xef.backend.entity.Ingrediente;
import com.xef.backend.entity.enums.UnidadMedida;
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
public class IngredienteDTO {

    private Long id;

    @NotBlank(message = "El nombre del ingrediente es obligatorio")
    private String nombre;

    @NotNull(message = "Las calorías por 100g son obligatorias")
    private Double caloriasPor100g;

    @NotNull(message = "Las proteínas por 100g son obligatorias")
    private Double proteinasPor100g;

    @NotNull(message = "Los carbohidratos por 100g son obligatorios")
    private Double carbohidratosPor100g;

    @NotNull(message = "Las grasas por 100g son obligatorias")
    private Double grasasPor100g;

    private UnidadMedida unidadMedidaDefault;
    private String categoria;
    private Boolean activo;

    public static IngredienteDTO fromEntity(Ingrediente i) {
        return IngredienteDTO.builder()
                .id(i.getId())
                .nombre(i.getNombre())
                .caloriasPor100g(i.getCaloriasPor100g())
                .proteinasPor100g(i.getProteinasPor100g())
                .carbohidratosPor100g(i.getCarbohidratosPor100g())
                .grasasPor100g(i.getGrasasPor100g())
                .unidadMedidaDefault(i.getUnidadMedidaDefault())
                .categoria(i.getCategoria())
                .activo(i.getActivo())
                .build();
    }
}
