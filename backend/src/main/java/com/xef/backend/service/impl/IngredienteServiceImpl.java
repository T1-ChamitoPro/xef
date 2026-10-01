package com.xef.backend.service.impl;

import com.xef.backend.dto.catalogo.IngredienteDTO;
import com.xef.backend.entity.Ingrediente;
import com.xef.backend.entity.enums.UnidadMedida;
import com.xef.backend.exception.BadRequestException;
import com.xef.backend.exception.ResourceNotFoundException;
import com.xef.backend.repository.IngredienteRepository;
import com.xef.backend.service.IngredienteService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class IngredienteServiceImpl implements IngredienteService {

    private final IngredienteRepository ingredienteRepository;

    @Override
    @Transactional(readOnly = true)
    public List<IngredienteDTO> obtenerTodos() {
        return ingredienteRepository.findByActivoTrue().stream()
                .map(IngredienteDTO::fromEntity)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public IngredienteDTO obtenerPorId(Long id) {
        Ingrediente ingrediente = ingredienteRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Ingrediente no encontrado con ID: " + id));

        return IngredienteDTO.fromEntity(ingrediente);
    }

    @Override
    @Transactional(readOnly = true)
    public List<IngredienteDTO> buscarPorNombre(String termino) {
        if (termino == null || termino.trim().isEmpty()) {
            return obtenerTodos();
        }
        return ingredienteRepository.findByNombreContainingIgnoreCaseAndActivoTrue(termino.trim()).stream()
                .map(IngredienteDTO::fromEntity)
                .toList();
    }

    @Override
    @Transactional
    public IngredienteDTO crearIngrediente(IngredienteDTO dto) {
        if (ingredienteRepository.existsByNombreIgnoreCase(dto.getNombre().trim())) {
            throw new BadRequestException("Ya existe un ingrediente registrado con el nombre: " + dto.getNombre());
        }

        Ingrediente ingrediente = Ingrediente.builder()
                .nombre(dto.getNombre().trim())
                .caloriasPor100g(dto.getCaloriasPor100g())
                .proteinasPor100g(dto.getProteinasPor100g())
                .carbohidratosPor100g(dto.getCarbohidratosPor100g())
                .grasasPor100g(dto.getGrasasPor100g())
                .unidadMedidaDefault(dto.getUnidadMedidaDefault() != null ? dto.getUnidadMedidaDefault() : UnidadMedida.GRAMOS)
                .categoria(dto.getCategoria())
                .activo(dto.getActivo() != null ? dto.getActivo() : true)
                .build();

        return IngredienteDTO.fromEntity(ingredienteRepository.save(ingrediente));
    }

    @Override
    @Transactional
    public IngredienteDTO actualizarIngrediente(Long id, IngredienteDTO dto) {
        Ingrediente ingrediente = ingredienteRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Ingrediente no encontrado con ID: " + id));

        ingrediente.setNombre(dto.getNombre().trim());
        ingrediente.setCaloriasPor100g(dto.getCaloriasPor100g());
        ingrediente.setProteinasPor100g(dto.getProteinasPor100g());
        ingrediente.setCarbohidratosPor100g(dto.getCarbohidratosPor100g());
        ingrediente.setGrasasPor100g(dto.getGrasasPor100g());
        if (dto.getUnidadMedidaDefault() != null) {
            ingrediente.setUnidadMedidaDefault(dto.getUnidadMedidaDefault());
        }
        ingrediente.setCategoria(dto.getCategoria());
        if (dto.getActivo() != null) {
            ingrediente.setActivo(dto.getActivo());
        }

        return IngredienteDTO.fromEntity(ingredienteRepository.save(ingrediente));
    }

    @Override
    @Transactional
    public void eliminarIngrediente(Long id) {
        Ingrediente ingrediente = ingredienteRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Ingrediente no encontrado con ID: " + id));

        // Soft delete
        ingrediente.setActivo(false);
        ingredienteRepository.save(ingrediente);
    }
}
