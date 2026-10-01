package com.xef.backend.service.impl;

import com.xef.backend.dto.catalogo.EjercicioDTO;
import com.xef.backend.entity.Ejercicio;
import com.xef.backend.entity.enums.Disciplina;
import com.xef.backend.entity.enums.GrupoMuscular;
import com.xef.backend.entity.enums.NivelExperiencia;
import com.xef.backend.exception.ResourceNotFoundException;
import com.xef.backend.repository.EjercicioRepository;
import com.xef.backend.service.EjercicioService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class EjercicioServiceImpl implements EjercicioService {

    private final EjercicioRepository ejercicioRepository;

    @Override
    @Transactional(readOnly = true)
    public List<EjercicioDTO> obtenerTodos() {
        return ejercicioRepository.findByActivoTrue().stream()
                .map(EjercicioDTO::fromEntity)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public EjercicioDTO obtenerPorId(Long id) {
        Ejercicio ejercicio = ejercicioRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Ejercicio no encontrado con ID: " + id));

        return EjercicioDTO.fromEntity(ejercicio);
    }

    @Override
    @Transactional(readOnly = true)
    public List<EjercicioDTO> buscarConFiltros(GrupoMuscular grupoMuscular, Disciplina disciplina, NivelExperiencia dificultad, String termino) {
        String cleanTerm = (termino != null && !termino.trim().isEmpty()) ? termino.trim() : null;
        return ejercicioRepository.buscarConFiltros(grupoMuscular, disciplina, dificultad, cleanTerm).stream()
                .map(EjercicioDTO::fromEntity)
                .toList();
    }

    @Override
    @Transactional
    public EjercicioDTO crearEjercicio(EjercicioDTO dto) {
        Ejercicio ejercicio = Ejercicio.builder()
                .nombre(dto.getNombre())
                .descripcion(dto.getDescripcion())
                .grupoMuscular(dto.getGrupoMuscular())
                .disciplina(dto.getDisciplina())
                .dificultad(dto.getDificultad())
                .equipamientoRequerido(dto.getEquipamientoRequerido())
                .guiaInstrucciones(dto.getGuiaInstrucciones())
                .multimediaUrl(dto.getMultimediaUrl())
                .caloriasPorMinuto(dto.getCaloriasPorMinuto())
                .activo(dto.getActivo() != null ? dto.getActivo() : true)
                .build();

        return EjercicioDTO.fromEntity(ejercicioRepository.save(ejercicio));
    }

    @Override
    @Transactional
    public EjercicioDTO actualizarEjercicio(Long id, EjercicioDTO dto) {
        Ejercicio ejercicio = ejercicioRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Ejercicio no encontrado con ID: " + id));

        ejercicio.setNombre(dto.getNombre());
        ejercicio.setDescripcion(dto.getDescripcion());
        ejercicio.setGrupoMuscular(dto.getGrupoMuscular());
        ejercicio.setDisciplina(dto.getDisciplina());
        ejercicio.setDificultad(dto.getDificultad());
        ejercicio.setEquipamientoRequerido(dto.getEquipamientoRequerido());
        ejercicio.setGuiaInstrucciones(dto.getGuiaInstrucciones());
        ejercicio.setMultimediaUrl(dto.getMultimediaUrl());
        ejercicio.setCaloriasPorMinuto(dto.getCaloriasPorMinuto());
        if (dto.getActivo() != null) {
            ejercicio.setActivo(dto.getActivo());
        }

        return EjercicioDTO.fromEntity(ejercicioRepository.save(ejercicio));
    }

    @Override
    @Transactional
    public void eliminarEjercicio(Long id) {
        Ejercicio ejercicio = ejercicioRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Ejercicio no encontrado con ID: " + id));

        // Soft delete
        ejercicio.setActivo(false);
        ejercicioRepository.save(ejercicio);
    }
}
