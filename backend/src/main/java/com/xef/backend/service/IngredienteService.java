package com.xef.backend.service;

import com.xef.backend.dto.catalogo.IngredienteDTO;

import java.util.List;

public interface IngredienteService {

    List<IngredienteDTO> obtenerTodos();

    IngredienteDTO obtenerPorId(Long id);

    List<IngredienteDTO> buscarPorNombre(String termino);

    IngredienteDTO crearIngrediente(IngredienteDTO dto);

    IngredienteDTO actualizarIngrediente(Long id, IngredienteDTO dto);

    void eliminarIngrediente(Long id);
}
