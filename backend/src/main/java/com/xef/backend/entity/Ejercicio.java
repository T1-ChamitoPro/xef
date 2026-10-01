package com.xef.backend.entity;

import com.xef.backend.entity.enums.Disciplina;
import com.xef.backend.entity.enums.GrupoMuscular;
import com.xef.backend.entity.enums.NivelExperiencia;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "ejercicios", indexes = {
        @Index(name = "idx_ejercicio_nombre", columnList = "nombre"),
        @Index(name = "idx_ejercicio_grupo_muscular", columnList = "grupo_muscular"),
        @Index(name = "idx_ejercicio_disciplina", columnList = "disciplina")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ejercicio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 150)
    private String nombre;

    @Column(length = 1000)
    private String descripcion;

    @Enumerated(EnumType.STRING)
    @Column(name = "grupo_muscular", nullable = false, length = 50)
    private GrupoMuscular grupoMuscular;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 50)
    private Disciplina disciplina;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private NivelExperiencia dificultad;

    @Column(name = "equipamiento_requerido", length = 200)
    private String equipamientoRequerido;

    @Column(name = "guia_instrucciones", length = 2000)
    private String guiaInstrucciones;

    @Column(name = "multimedia_url", length = 500)
    private String multimediaUrl;

    @Column(name = "calorias_por_minuto")
    private Double caloriasPorMinuto;

    @Column(nullable = false)
    @Builder.Default
    private Boolean activo = true;

    @Column(name = "fecha_creacion", updatable = false)
    private LocalDateTime fechaCreacion;

    @PrePersist
    public void prePersist() {
        this.fechaCreacion = LocalDateTime.now();
    }
}
