package com.xef.backend.controller;

import com.xef.backend.dto.catalogo.EjercicioDTO;
import com.xef.backend.dto.response.ApiResponse;
import com.xef.backend.entity.enums.Disciplina;
import com.xef.backend.entity.enums.GrupoMuscular;
import com.xef.backend.entity.enums.NivelExperiencia;
import com.xef.backend.service.EjercicioService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ejercicios")
@RequiredArgsConstructor
public class EjercicioController {

    private final EjercicioService ejercicioService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<EjercicioDTO>>> listarEjercicios(
            @RequestParam(required = false) GrupoMuscular grupoMuscular,
            @RequestParam(required = false) Disciplina disciplina,
            @RequestParam(required = false) NivelExperiencia dificultad,
            @RequestParam(required = false) String search) {

        List<EjercicioDTO> ejercicios = ejercicioService.buscarConFiltros(grupoMuscular, disciplina, dificultad, search);
        return ResponseEntity.ok(ApiResponse.ok("Ejercicios obtenidos exitosamente", ejercicios));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<EjercicioDTO>> obtenerEjercicioPorId(@PathVariable Long id) {
        EjercicioDTO ejercicio = ejercicioService.obtenerPorId(id);
        return ResponseEntity.ok(ApiResponse.ok(ejercicio));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<EjercicioDTO>> crearEjercicio(@Valid @RequestBody EjercicioDTO dto) {
        EjercicioDTO creado = ejercicioService.crearEjercicio(dto);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok("Ejercicio creado exitosamente en el catálogo", creado));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<EjercicioDTO>> actualizarEjercicio(
            @PathVariable Long id,
            @Valid @RequestBody EjercicioDTO dto) {
        EjercicioDTO actualizado = ejercicioService.actualizarEjercicio(id, dto);
        return ResponseEntity.ok(ApiResponse.ok("Ejercicio actualizado exitosamente", actualizado));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> eliminarEjercicio(@PathVariable Long id) {
        ejercicioService.eliminarEjercicio(id);
        return ResponseEntity.ok(ApiResponse.ok("Ejercicio desactivado del catálogo exitosamente", null));
    }
}
