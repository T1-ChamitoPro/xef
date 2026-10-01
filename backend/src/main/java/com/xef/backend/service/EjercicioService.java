package com.xef.backend.service;

import com.xef.backend.dto.catalogo.EjercicioDTO;
import com.xef.backend.entity.enums.Disciplina;
import com.xef.backend.entity.enums.GrupoMuscular;
import com.xef.backend.entity.enums.NivelExperiencia;

import java.util.List;

public interface EjercicioService {

    List<EjercicioDTO> obtenerTodos();

    EjercicioDTO obtenerPorId(Long id);

    List<EjercicioDTO> buscarConFiltros(GrupoMuscular grupoMuscular, Disciplina disciplina, NivelExperiencia dificultad, String termino);

    EjercicioDTO crearEjercicio(EjercicioDTO dto);

    EjercicioDTO actualizarEjercicio(Long id, EjercicioDTO dto);

    void eliminarEjercicio(Long id);
}
