package com.xef.backend.entity;

import com.xef.backend.entity.enums.UnidadMedida;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "ingredientes", indexes = {
        @Index(name = "idx_ingrediente_nombre", columnList = "nombre")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ingrediente {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 150)
    private String nombre;

    @Column(name = "calorias_por_100g", nullable = false)
    private Double caloriasPor100g;

    @Column(name = "proteinas_por_100g", nullable = false)
    private Double proteinasPor100g;

    @Column(name = "carbohidratos_por_100g", nullable = false)
    private Double carbohidratosPor100g;

    @Column(name = "grasas_por_100g", nullable = false)
    private Double grasasPor100g;

    @Enumerated(EnumType.STRING)
    @Column(name = "unidad_medida_default", length = 30)
    @Builder.Default
    private UnidadMedida unidadMedidaDefault = UnidadMedida.GRAMOS;

    @Column(length = 100)
    private String categoria;

    @Column(nullable = false)
    @Builder.Default
    private Boolean activo = true;
}
