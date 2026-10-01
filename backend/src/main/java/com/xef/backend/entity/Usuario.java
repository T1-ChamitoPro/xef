package com.xef.backend.entity;

import com.xef.backend.entity.enums.NivelExperiencia;
import com.xef.backend.entity.enums.ObjetivoFisico;
import com.xef.backend.entity.enums.Rol;
import com.xef.backend.entity.enums.Sexo;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "usuarios", indexes = {
        @Index(name = "idx_usuario_email", columnList = "email", unique = true)
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(nullable = false, length = 100)
    private String apellido;

    @Column(nullable = false, unique = true, length = 150)
    private String email;

    @Column(nullable = false)
    private String password;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    @Builder.Default
    private Rol rol = Rol.ROLE_USER;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private Sexo sexo;

    private Integer edad;

    @Column(name = "altura_cm")
    private Double alturaCm;

    @Column(name = "peso_kg")
    private Double pesoKg;

    @Column(name = "imc")
    private Double imc;

    @Enumerated(EnumType.STRING)
    @Column(name = "nivel_experiencia", length = 30)
    private NivelExperiencia nivelExperiencia;

    @Enumerated(EnumType.STRING)
    @Column(name = "objetivo_fisico", length = 40)
    private ObjetivoFisico objetivoFisico;

    @Column(name = "equipamiento_disponible", length = 500)
    private String equipamientoDisponible;

    @Column(name = "disponibilidad_minutos_dia")
    private Integer disponibilidadMinutosDia;

    @Column(name = "restricciones_alimentarias", length = 500)
    private String restriccionesAlimentarias;

    @Column(nullable = false)
    @Builder.Default
    @Transient
    private Boolean activo = true;

    @Column(name = "fecha_creacion", updatable = false)
    private LocalDateTime fechaCreacion;

    @Column(name = "fecha_actualizacion")
    private LocalDateTime fechaActualizacion;

    @PrePersist
    public void prePersist() {
        this.fechaCreacion = LocalDateTime.now();
        this.fechaActualizacion = LocalDateTime.now();
        calcularImc();
    }

    @PreUpdate
    public void preUpdate() {
        this.fechaActualizacion = LocalDateTime.now();
        calcularImc();
    }

    public void calcularImc() {
        if (this.pesoKg != null && this.alturaCm != null && this.alturaCm > 0) {
            double alturaMetros = this.alturaCm / 100.0;
            double imcCalculado = this.pesoKg / (alturaMetros * alturaMetros);
            this.imc = Math.round(imcCalculado * 100.0) / 100.0; // Redondeo a 2 decimales
        }
    }
}
