package com.xef.backend.repository;

import com.xef.backend.entity.Receta;
import com.xef.backend.entity.enums.TipoComida;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RecetaRepository extends JpaRepository<Receta, Long> {

    List<Receta> findByActivoTrue();

    List<Receta> findByTipoComidaAndActivoTrue(TipoComida tipoComida);

    @Query("SELECT r FROM Receta r WHERE r.activo = true " +
            "AND (:tipoComida IS NULL OR r.tipoComida = :tipoComida) " +
            "AND (:maxCalorias IS NULL OR r.caloriasTotales <= :maxCalorias) " +
            "AND (:minProteinas IS NULL OR r.proteinasTotales >= :minProteinas) " +
            "AND (:termino IS NULL OR LOWER(r.nombre) LIKE LOWER(CONCAT('%', :termino, '%')) " +
            "     OR LOWER(r.descripcion) LIKE LOWER(CONCAT('%', :termino, '%')))")
    List<Receta> buscarConFiltros(
            @Param("tipoComida") TipoComida tipoComida,
            @Param("maxCalorias") Double maxCalorias,
            @Param("minProteinas") Double minProteinas,
            @Param("termino") String termino
    );
}
