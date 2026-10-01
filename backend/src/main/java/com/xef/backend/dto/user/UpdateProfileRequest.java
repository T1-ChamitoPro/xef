package com.xef.backend.dto.user;

import com.xef.backend.entity.enums.NivelExperiencia;
import com.xef.backend.entity.enums.ObjetivoFisico;
import com.xef.backend.entity.enums.Sexo;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UpdateProfileRequest {

    @NotBlank(message = "El nombre no puede estar vacío")
    @Size(min = 2, max = 100, message = "El nombre debe tener entre 2 y 100 caracteres")
    private String nombre;

    @NotBlank(message = "El apellido no puede estar vacío")
    @Size(min = 2, max = 100, message = "El apellido debe tener entre 2 y 100 caracteres")
    private String apellido;

    private Sexo sexo;

    @Min(value = 10, message = "La edad mínima permitida es 10 años")
    @Max(value = 120, message = "La edad máxima permitida es 120 años")
    private Integer edad;

    @DecimalMin(value = "50.0", message = "La altura mínima es de 50 cm")
    @DecimalMax(value = "250.0", message = "La altura máxima es de 250 cm")
    private Double alturaCm;

    @DecimalMin(value = "20.0", message = "El peso mínimo es de 20 kg")
    @DecimalMax(value = "350.0", message = "El peso máximo es de 350 kg")
    private Double pesoKg;

    private NivelExperiencia nivelExperiencia;

    private ObjetivoFisico objetivoFisico;

    private String equipamientoDisponible;

    private Integer disponibilidadMinutosDia;

    private String restriccionesAlimentarias;
}
