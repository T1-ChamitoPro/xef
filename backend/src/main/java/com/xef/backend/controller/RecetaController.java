package com.xef.backend.controller;

import com.xef.backend.dto.catalogo.RecetaDTO;
import com.xef.backend.dto.response.ApiResponse;
import com.xef.backend.entity.enums.TipoComida;
import com.xef.backend.service.RecetaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/recetas")
@RequiredArgsConstructor
public class RecetaController {

    private final RecetaService recetaService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<RecetaDTO>>> listarRecetas(
            @RequestParam(required = false) TipoComida tipoComida,
            @RequestParam(required = false) Double maxCalorias,
            @RequestParam(required = false) Double minProteinas,
            @RequestParam(required = false) String search) {

        List<RecetaDTO> recetas = recetaService.buscarConFiltros(tipoComida, maxCalorias, minProteinas, search);
        return ResponseEntity.ok(ApiResponse.ok("Recetas obtenidas exitosamente", recetas));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<RecetaDTO>> obtenerRecetaPorId(@PathVariable Long id) {
        RecetaDTO receta = recetaService.obtenerPorId(id);
        return ResponseEntity.ok(ApiResponse.ok(receta));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<RecetaDTO>> crearReceta(@Valid @RequestBody RecetaDTO dto) {
        RecetaDTO creada = recetaService.crearReceta(dto);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok("Receta creada exitosamente", creada));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<RecetaDTO>> actualizarReceta(
            @PathVariable Long id,
            @Valid @RequestBody RecetaDTO dto) {
        RecetaDTO actualizada = recetaService.actualizarReceta(id, dto);
        return ResponseEntity.ok(ApiResponse.ok("Receta actualizada exitosamente", actualizada));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> eliminarReceta(@PathVariable Long id) {
        recetaService.eliminarReceta(id);
        return ResponseEntity.ok(ApiResponse.ok("Receta desactivada exitosamente", null));
    }
}
