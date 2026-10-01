package com.xef.backend.entity;

import com.xef.backend.entity.enums.TipoComida;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "recetas", indexes = {
        @Index(name = "idx_receta_nombre", columnList = "nombre"),
        @Index(name = "idx_receta_tipo_comida", columnList = "tipo_comida")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Receta {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 150)
    private String nombre;

    @Column(length = 1000)
    private String descripcion;

    @Enumerated(EnumType.STRING)
    @Column(name = "tipo_comida", nullable = false, length = 40)
    private TipoComida tipoComida;

    @Column(name = "tiempo_preparacion_minutos")
    private Integer tiempoPreparacionMinutos;

    @Column(nullable = false)
    @Builder.Default
    private Integer porciones = 1;

    @Column(columnDefinition = "TEXT")
    private String instrucciones;

    @Column(name = "imagen_url", length = 500)
    private String imagenUrl;

    @Column(name = "calorias_totales")
    private Double caloriasTotales;

    @Column(name = "proteinas_totales")
    private Double proteinasTotales;

    @Column(name = "carbohidratos_totales")
    private Double carbohidratosTotales;

    @Column(name = "grasas_totales")
    private Double grasasTotales;

    @OneToMany(mappedBy = "receta", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<RecetaIngrediente> ingredientes = new ArrayList<>();

    @Column(nullable = false)
    @Builder.Default
    private Boolean activo = true;

    @Column(name = "fecha_creacion", updatable = false)
    private LocalDateTime fechaCreacion;

    @PrePersist
    public void prePersist() {
        this.fechaCreacion = LocalDateTime.now();
    }

    public void agregarIngrediente(RecetaIngrediente item) {
        ingredientes.add(item);
        item.setReceta(this);
    }

    public void recalcularMacrosDesdeIngredientes() {
        if (ingredientes == null || ingredientes.isEmpty()) {
            return;
        }

        double cals = 0.0;
        double prot = 0.0;
        double carb = 0.0;
        double gras = 0.0;

        for (RecetaIngrediente ri : ingredientes) {
            if (ri.getIngrediente() != null && ri.getCantidad() != null) {
                double factor = ri.getCantidad() / 100.0;
                cals += (ri.getIngrediente().getCaloriasPor100g() != null ? ri.getIngrediente().getCaloriasPor100g() : 0.0) * factor;
                prot += (ri.getIngrediente().getProteinasPor100g() != null ? ri.getIngrediente().getProteinasPor100g() : 0.0) * factor;
                carb += (ri.getIngrediente().getCarbohidratosPor100g() != null ? ri.getIngrediente().getCarbohidratosPor100g() : 0.0) * factor;
                gras += (ri.getIngrediente().getGrasasPor100g() != null ? ri.getIngrediente().getGrasasPor100g() : 0.0) * factor;
            }
        }

        this.caloriasTotales = Math.round(cals * 100.0) / 100.0;
        this.proteinasTotales = Math.round(prot * 100.0) / 100.0;
        this.carbohidratosTotales = Math.round(carb * 100.0) / 100.0;
        this.grasasTotales = Math.round(gras * 100.0) / 100.0;
    }
}
