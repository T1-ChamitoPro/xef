package com.xef.backend.config;

import com.xef.backend.entity.Ejercicio;
import com.xef.backend.entity.Ingrediente;
import com.xef.backend.entity.Receta;
import com.xef.backend.entity.RecetaIngrediente;
import com.xef.backend.entity.enums.*;
import com.xef.backend.repository.EjercicioRepository;
import com.xef.backend.repository.IngredienteRepository;
import com.xef.backend.repository.RecetaRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

    private final EjercicioRepository ejercicioRepository;
    private final IngredienteRepository ingredienteRepository;
    private final RecetaRepository recetaRepository;

    @Override
    public void run(String... args) {
        try {
            seedEjercicios();
            seedIngredientesYRecetas();
        } catch (Exception e) {
            log.warn("No se pudo ejecutar el sembrado inicial de datos (puede que la BD ya esté inicializada): {}", e.getMessage());
        }
    }

    private void seedEjercicios() {
        if (ejercicioRepository.count() > 0) {
            return;
        }

        log.info("Sembrando catálogo inicial de ejercicios...");

        List<Ejercicio> ejercicios = List.of(
                Ejercicio.builder()
                        .nombre("Press de Banca con Barra")
                        .descripcion("Ejercicio compuesto básico para el desarrollo del pectoral mayor, deltoides anterior y tríceps.")
                        .grupoMuscular(GrupoMuscular.PECHO)
                        .disciplina(Disciplina.FUERZA)
                        .dificultad(NivelExperiencia.INTERMEDIO)
                        .equipamientoRequerido("Barra olímpica y banco plano")
                        .guiaInstrucciones("1. Acuéstate en el banco con los pies firmes en el suelo.\n2. Agarra la barra ligeramente más ancho que el ancho de los hombros.\n3. Baja la barra controladamente hasta el centro del pecho.\n4. Empuja hacia arriba con fuerza sin bloquear bruscamente los codos.")
                        .caloriasPorMinuto(7.5)
                        .activo(true)
                        .build(),

                Ejercicio.builder()
                        .nombre("Sentadilla con Barra Trasera")
                        .descripcion("Ejercicio rey del tren inferior enfocado en cuádriceps, glúteos, femorales y core.")
                        .grupoMuscular(GrupoMuscular.PIERNAS)
                        .disciplina(Disciplina.FUERZA)
                        .dificultad(NivelExperiencia.INTERMEDIO)
                        .equipamientoRequerido("Barra olímpica y rack de sentadillas")
                        .guiaInstrucciones("1. Coloca la barra sobre los trapecios superiores.\n2. Separa los pies al ancho de los hombros, puntas ligeramente hacia afuera.\n3. Desciende flexionando rodillas y caderas manteniendo el pecho erguido.\n4. Rompe el paralelo y sube empujando con toda la planta del pie.")
                        .caloriasPorMinuto(9.0)
                        .activo(true)
                        .build(),

                Ejercicio.builder()
                        .nombre("Dominadas Pronas (Pull-ups)")
                        .descripcion("Ejercicio de calistenia y fuerza fundamental para el dorsal ancho, bíceps y espalda media.")
                        .grupoMuscular(GrupoMuscular.ESPALDA)
                        .disciplina(Disciplina.CALISTENIA)
                        .dificultad(NivelExperiencia.AVANZADO)
                        .equipamientoRequerido("Barra de dominadas")
                        .guiaInstrucciones("1. Agarre en pronación un poco más amplio que los hombros.\n2. Inicia retrayendo las escápulas y tira con los codos hacia abajo y atrás.\n3. Pasa la barbilla por encima de la barra.\n4. Baja de forma controlada hasta la extensión completa de brazos.")
                        .caloriasPorMinuto(8.0)
                        .activo(true)
                        .build(),

                Ejercicio.builder()
                        .nombre("Plancha Abdominal Estática")
                        .descripcion("Ejercicio isométrico para fortalecimiento del core profundo y estabilidad lumbar.")
                        .grupoMuscular(GrupoMuscular.CORE)
                        .disciplina(Disciplina.CALISTENIA)
                        .dificultad(NivelExperiencia.PRINCIPIANTE)
                        .equipamientoRequerido("Esterilla / Colchoneta")
                        .guiaInstrucciones("1. Apóyate sobre los antebrazos y las puntas de los pies.\n2. Mantén el cuerpo en línea recta desde la cabeza hasta los talones.\n3. Contrae glúteos y abdomen, evitando que la cadera se hunda.")
                        .caloriasPorMinuto(4.5)
                        .activo(true)
                        .build(),

                Ejercicio.builder()
                        .nombre("Burpees")
                        .descripcion("Ejercicio dinámico de cuerpo completo de alta intensidad cardiovascular.")
                        .grupoMuscular(GrupoMuscular.CUERPO_COMPLETO)
                        .disciplina(Disciplina.HIIT)
                        .dificultad(NivelExperiencia.INTERMEDIO)
                        .equipamientoRequerido("Ninguno (Peso corporal)")
                        .guiaInstrucciones("1. De pie, haz una sentadilla y pon las manos en el suelo.\n2. Salta los pies atrás a posición de flexión y realiza una flexión.\n3. Regresa los pies hacia adelante y salta verticalmente extendiendo los brazos.")
                        .caloriasPorMinuto(11.0)
                        .activo(true)
                        .build()
        );

        ejercicioRepository.saveAll(ejercicios);
        log.info("Catálogo de ejercicios sembrado con éxito ({} items).", ejercicios.size());
    }

    private void seedIngredientesYRecetas() {
        if (ingredienteRepository.count() > 0) {
            return;
        }

        log.info("Sembrando catálogo de ingredientes y recetas...");

        Ingrediente avena = ingredienteRepository.save(Ingrediente.builder()
                .nombre("Avena en hojuelas")
                .caloriasPor100g(389.0)
                .proteinasPor100g(16.9)
                .carbohidratosPor100g(66.3)
                .grasasPor100g(6.9)
                .unidadMedidaDefault(UnidadMedida.GRAMOS)
                .categoria("Cereales")
                .build());

        Ingrediente proteinaWhey = ingredienteRepository.save(Ingrediente.builder()
                .nombre("Proteína Whey en Polvo")
                .caloriasPor100g(400.0)
                .proteinasPor100g(80.0)
                .carbohidratosPor100g(6.0)
                .grasasPor100g(4.0)
                .unidadMedidaDefault(UnidadMedida.GRAMOS)
                .categoria("Suplementos")
                .build());

        Ingrediente platano = ingredienteRepository.save(Ingrediente.builder()
                .nombre("Plátano / Banano")
                .caloriasPor100g(89.0)
                .proteinasPor100g(1.1)
                .carbohidratosPor100g(22.8)
                .grasasPor100g(0.3)
                .unidadMedidaDefault(UnidadMedida.GRAMOS)
                .categoria("Frutas")
                .build());

        Ingrediente pechugaPollo = ingredienteRepository.save(Ingrediente.builder()
                .nombre("Pechuga de Pollo")
                .caloriasPor100g(165.0)
                .proteinasPor100g(31.0)
                .carbohidratosPor100g(0.0)
                .grasasPor100g(3.6)
                .unidadMedidaDefault(UnidadMedida.GRAMOS)
                .categoria("Carnes magras")
                .build());

        Ingrediente arrozIntegral = ingredienteRepository.save(Ingrediente.builder()
                .nombre("Arroz Integral cocido")
                .caloriasPor100g(111.0)
                .proteinasPor100g(2.6)
                .carbohidratosPor100g(23.0)
                .grasasPor100g(0.9)
                .unidadMedidaDefault(UnidadMedida.GRAMOS)
                .categoria("Cereales")
                .build());

        Ingrediente aceiteOliva = ingredienteRepository.save(Ingrediente.builder()
                .nombre("Aceite de Oliva Extra Virgen")
                .caloriasPor100g(884.0)
                .proteinasPor100g(0.0)
                .carbohidratosPor100g(0.0)
                .grasasPor100g(100.0)
                .unidadMedidaDefault(UnidadMedida.MILILITROS)
                .categoria("Grasas saludables")
                .build());

        // Receta 1: Bowl de Avena Proteico
        Receta bowlAvena = Receta.builder()
                .nombre("Bowl de Avena Proteico con Plátano")
                .descripcion("Desayuno balanceado de alto valor biológico y carbohidratos de absorción lenta.")
                .tipoComida(TipoComida.DESAYUNO)
                .tiempoPreparacionMinutos(10)
                .porciones(1)
                .instrucciones("1. Cocinar la avena con agua o leche deslactosada a fuego medio durante 5 minutos.\n2. Retirar del fuego y mezclar con el scoop de proteína en polvo hasta integrar.\n3. Servir y decorar con rodajas de plátano.")
                .activo(true)
                .build();

        bowlAvena.agregarIngrediente(RecetaIngrediente.builder().ingrediente(avena).cantidad(60.0).unidadMedida(UnidadMedida.GRAMOS).build());
        bowlAvena.agregarIngrediente(RecetaIngrediente.builder().ingrediente(proteinaWhey).cantidad(30.0).unidadMedida(UnidadMedida.GRAMOS).build());
        bowlAvena.agregarIngrediente(RecetaIngrediente.builder().ingrediente(platano).cantidad(80.0).unidadMedida(UnidadMedida.GRAMOS).build());
        bowlAvena.recalcularMacrosDesdeIngredientes();
        recetaRepository.save(bowlAvena);

        // Receta 2: Pechuga a la plancha con arroz integral
        Receta pechugaAlmuerzo = Receta.builder()
                .nombre("Pechuga de Pollo a la Plancha con Arroz Integral")
                .descripcion("Almuerzo fit magro rico en proteínas y carbohidratos complejos.")
                .tipoComida(TipoComida.ALMUERZO)
                .tiempoPreparacionMinutos(20)
                .porciones(1)
                .instrucciones("1. Sazonar la pechuga de pollo con sal, pimienta, ajo y finas hierbas.\n2. Calentar la sartén con el aceite de oliva y sellar la pechuga a fuego medio-alto 5-6 min por lado.\n3. Servir junto con la porción de arroz integral caliente.")
                .activo(true)
                .build();

        pechugaAlmuerzo.agregarIngrediente(RecetaIngrediente.builder().ingrediente(pechugaPollo).cantidad(180.0).unidadMedida(UnidadMedida.GRAMOS).build());
        pechugaAlmuerzo.agregarIngrediente(RecetaIngrediente.builder().ingrediente(arrozIntegral).cantidad(150.0).unidadMedida(UnidadMedida.GRAMOS).build());
        pechugaAlmuerzo.agregarIngrediente(RecetaIngrediente.builder().ingrediente(aceiteOliva).cantidad(10.0).unidadMedida(UnidadMedida.MILILITROS).build());
        pechugaAlmuerzo.recalcularMacrosDesdeIngredientes();
        recetaRepository.save(pechugaAlmuerzo);

        log.info("Catálogo de recetas sembrado con éxito.");
    }
}
