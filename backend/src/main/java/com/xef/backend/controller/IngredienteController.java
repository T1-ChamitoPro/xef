package com.xef.backend.controller;

import com.xef.backend.dto.catalogo.IngredienteDTO;
import com.xef.backend.dto.response.ApiResponse;
import com.xef.backend.service.IngredienteService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ingredientes")
@RequiredArgsConstructor
public class IngredienteController {

    private final IngredienteService ingredienteService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<IngredienteDTO>>> listarIngredientes(
            @RequestParam(required = false) String search) {

        List<IngredienteDTO> ingredientes = ingredienteService.buscarPorNombre(search);
        return ResponseEntity.ok(ApiResponse.ok("Ingredientes obtenidos exitosamente", ingredientes));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<IngredienteDTO>> obtenerIngredientePorId(@PathVariable Long id) {
        IngredienteDTO ingrediente = ingredienteService.obtenerPorId(id);
        return ResponseEntity.ok(ApiResponse.ok(ingrediente));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<IngredienteDTO>> crearIngrediente(@Valid @RequestBody IngredienteDTO dto) {
        IngredienteDTO creado = ingredienteService.crearIngrediente(dto);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok("Ingrediente creado exitosamente", creado));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<IngredienteDTO>> actualizarIngrediente(
            @PathVariable Long id,
            @Valid @RequestBody IngredienteDTO dto) {
        IngredienteDTO actualizado = ingredienteService.actualizarIngrediente(id, dto);
        return ResponseEntity.ok(ApiResponse.ok("Ingrediente actualizado exitosamente", actualizado));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> eliminarIngrediente(@PathVariable Long id) {
        ingredienteService.eliminarIngrediente(id);
        return ResponseEntity.ok(ApiResponse.ok("Ingrediente desactivado exitosamente", null));
    }
}
