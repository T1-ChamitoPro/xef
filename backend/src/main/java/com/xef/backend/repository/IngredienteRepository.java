package com.xef.backend.repository;

import com.xef.backend.entity.Ingrediente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface IngredienteRepository extends JpaRepository<Ingrediente, Long> {

    List<Ingrediente> findByActivoTrue();

    Optional<Ingrediente> findByNombreIgnoreCase(String nombre);

    List<Ingrediente> findByNombreContainingIgnoreCaseAndActivoTrue(String nombre);

    List<Ingrediente> findByCategoriaIgnoreCaseAndActivoTrue(String categoria);

    boolean existsByNombreIgnoreCase(String nombre);
}
