package com.xef.backend.service;

import com.xef.backend.dto.catalogo.RecetaDTO;
import com.xef.backend.entity.enums.TipoComida;

import java.util.List;

public interface RecetaService {

    List<RecetaDTO> obtenerTodas();

    RecetaDTO obtenerPorId(Long id);

    List<RecetaDTO> buscarConFiltros(TipoComida tipoComida, Double maxCalorias, Double minProteinas, String termino);

    RecetaDTO crearReceta(RecetaDTO dto);

    RecetaDTO actualizarReceta(Long id, RecetaDTO dto);

    void eliminarReceta(Long id);
}
