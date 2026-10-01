package com.xef.backend.repository;

import com.xef.backend.entity.Ejercicio;
import com.xef.backend.entity.enums.Disciplina;
import com.xef.backend.entity.enums.GrupoMuscular;
import com.xef.backend.entity.enums.NivelExperiencia;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EjercicioRepository extends JpaRepository<Ejercicio, Long>, JpaSpecificationExecutor<Ejercicio> {

    List<Ejercicio> findByActivoTrue();

    List<Ejercicio> findByGrupoMuscularAndActivoTrue(GrupoMuscular grupoMuscular);

    List<Ejercicio> findByDisciplinaAndActivoTrue(Disciplina disciplina);

    List<Ejercicio> findByDificultadAndActivoTrue(NivelExperiencia dificultad);

    @Query("SELECT e FROM Ejercicio e WHERE e.activo = true " +
            "AND (:grupoMuscular IS NULL OR e.grupoMuscular = :grupoMuscular) " +
            "AND (:disciplina IS NULL OR e.disciplina = :disciplina) " +
            "AND (:dificultad IS NULL OR e.dificultad = :dificultad) " +
            "AND (:termino IS NULL OR LOWER(e.nombre) LIKE LOWER(CONCAT('%', :termino, '%')) " +
            "     OR LOWER(e.descripcion) LIKE LOWER(CONCAT('%', :termino, '%')))")
    List<Ejercicio> buscarConFiltros(
            @Param("grupoMuscular") GrupoMuscular grupoMuscular,
            @Param("disciplina") Disciplina disciplina,
            @Param("dificultad") NivelExperiencia dificultad,
            @Param("termino") String termino
    );
}
