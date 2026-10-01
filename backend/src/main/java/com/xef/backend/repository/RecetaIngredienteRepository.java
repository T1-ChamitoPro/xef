package com.xef.backend.repository;

import com.xef.backend.entity.RecetaIngrediente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RecetaIngredienteRepository extends JpaRepository<RecetaIngrediente, Long> {

    List<RecetaIngrediente> findByRecetaId(Long recetaId);
}
