package com.xef.backend.service.impl;

import com.xef.backend.dto.catalogo.RecetaDTO;
import com.xef.backend.dto.catalogo.RecetaIngredienteDTO;
import com.xef.backend.entity.Ingrediente;
import com.xef.backend.entity.Receta;
import com.xef.backend.entity.RecetaIngrediente;
import com.xef.backend.entity.enums.TipoComida;
import com.xef.backend.exception.ResourceNotFoundException;
import com.xef.backend.repository.IngredienteRepository;
import com.xef.backend.repository.RecetaRepository;
import com.xef.backend.service.RecetaService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class RecetaServiceImpl implements RecetaService {

    private final RecetaRepository recetaRepository;
    private final IngredienteRepository ingredienteRepository;

    @Override
    @Transactional(readOnly = true)
    public List<RecetaDTO> obtenerTodas() {
        return recetaRepository.findByActivoTrue().stream()
                .map(RecetaDTO::fromEntity)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public RecetaDTO obtenerPorId(Long id) {
        Receta receta = recetaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Receta no encontrada con ID: " + id));

        return RecetaDTO.fromEntity(receta);
    }

    @Override
    @Transactional(readOnly = true)
    public List<RecetaDTO> buscarConFiltros(TipoComida tipoComida, Double maxCalorias, Double minProteinas, String termino) {
        String cleanTerm = (termino != null && !termino.trim().isEmpty()) ? termino.trim() : null;
        return recetaRepository.buscarConFiltros(tipoComida, maxCalorias, minProteinas, cleanTerm).stream()
                .map(RecetaDTO::fromEntity)
                .toList();
    }

    @Override
    @Transactional
    public RecetaDTO crearReceta(RecetaDTO dto) {
        Receta receta = Receta.builder()
                .nombre(dto.getNombre())
                .descripcion(dto.getDescripcion())
                .tipoComida(dto.getTipoComida())
                .tiempoPreparacionMinutos(dto.getTiempoPreparacionMinutos())
                .porciones(dto.getPorciones() != null ? dto.getPorciones() : 1)
                .instrucciones(dto.getInstrucciones())
                .imagenUrl(dto.getImagenUrl())
                .caloriasTotales(dto.getCaloriasTotales())
                .proteinasTotales(dto.getProteinasTotales())
                .carbohidratosTotales(dto.getCarbohidratosTotales())
                .grasasTotales(dto.getGrasasTotales())
                .activo(dto.getActivo() != null ? dto.getActivo() : true)
                .ingredientes(new ArrayList<>())
                .build();

        if (dto.getIngredientes() != null && !dto.getIngredientes().isEmpty()) {
            for (RecetaIngredienteDTO ingDTO : dto.getIngredientes()) {
                Ingrediente ingrediente = ingredienteRepository.findById(ingDTO.getIngredienteId())
                        .orElseThrow(() -> new ResourceNotFoundException("Ingrediente no encontrado con ID: " + ingDTO.getIngredienteId()));

                RecetaIngrediente ri = RecetaIngrediente.builder()
                        .receta(receta)
                        .ingrediente(ingrediente)
                        .cantidad(ingDTO.getCantidad())
                        .unidadMedida(ingDTO.getUnidadMedida() != null ? ingDTO.getUnidadMedida() : ingrediente.getUnidadMedidaDefault())
                        .build();

                receta.agregarIngrediente(ri);
            }
            receta.recalcularMacrosDesdeIngredientes();
        }

        return RecetaDTO.fromEntity(recetaRepository.save(receta));
    }

    @Override
    @Transactional
    public RecetaDTO actualizarReceta(Long id, RecetaDTO dto) {
        Receta receta = recetaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Receta no encontrada con ID: " + id));

        receta.setNombre(dto.getNombre());
        receta.setDescripcion(dto.getDescripcion());
        receta.setTipoComida(dto.getTipoComida());
        receta.setTiempoPreparacionMinutos(dto.getTiempoPreparacionMinutos());
        receta.setPorciones(dto.getPorciones() != null ? dto.getPorciones() : 1);
        receta.setInstrucciones(dto.getInstrucciones());
        receta.setImagenUrl(dto.getImagenUrl());
        if (dto.getActivo() != null) {
            receta.setActivo(dto.getActivo());
        }

        if (dto.getIngredientes() != null) {
            receta.getIngredientes().clear();
            for (RecetaIngredienteDTO ingDTO : dto.getIngredientes()) {
                Ingrediente ingrediente = ingredienteRepository.findById(ingDTO.getIngredienteId())
                        .orElseThrow(() -> new ResourceNotFoundException("Ingrediente no encontrado con ID: " + ingDTO.getIngredienteId()));

                RecetaIngrediente ri = RecetaIngrediente.builder()
                        .receta(receta)
                        .ingrediente(ingrediente)
                        .cantidad(ingDTO.getCantidad())
                        .unidadMedida(ingDTO.getUnidadMedida() != null ? ingDTO.getUnidadMedida() : ingrediente.getUnidadMedidaDefault())
                        .build();

                receta.agregarIngrediente(ri);
            }
            receta.recalcularMacrosDesdeIngredientes();
        } else if (dto.getCaloriasTotales() != null) {
            receta.setCaloriasTotales(dto.getCaloriasTotales());
            receta.setProteinasTotales(dto.getProteinasTotales());
            receta.setCarbohidratosTotales(dto.getCarbohidratosTotales());
            receta.setGrasasTotales(dto.getGrasasTotales());
        }

        return RecetaDTO.fromEntity(recetaRepository.save(receta));
    }

    @Override
    @Transactional
    public void eliminarReceta(Long id) {
        Receta receta = recetaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Receta no encontrada con ID: " + id));

        // Soft delete
        receta.setActivo(false);
        recetaRepository.save(receta);
    }
}
