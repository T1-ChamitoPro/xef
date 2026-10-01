# Documento de Especificación de Requerimientos Funcionales y Estructura del Sistema (Proyecto XEF)

---

## 1. Requerimientos Funcionales (MÁXIMA PRIORIDAD)

El núcleo del sistema **XEF** se estructura en 5 módulos funcionales clave, priorizando la lógica de interacción del usuario, las capacidades del motor de Inteligencia Artificial, la integridad de los registros diarios y la presentación gráfica de métricas.

---

### Módulo 1: Gestión de Usuarios, Autenticación y Perfil

| ID | Requerimiento Funcional | Descripción | Impacto / Dominio |
| :--- | :--- | :--- | :--- |
| **RF-01** | **Registro de Usuarios** | El sistema debe permitir el registro de nuevos usuarios mediante la captura de credenciales básicas (*nombre, apellido, correo electrónico y contraseña*) y parámetros antropométricos iniciales (*sexo, edad, altura en cm y peso en kg*). | Gestión de Accesos / Datos de Entrada |
| **RF-02** | **Autenticación e Inicio de Sesión** | El sistema debe validar las credenciales de acceso (*correo electrónico y contraseña*) para permitir el ingreso de usuarios previamente registrados. | Seguridad / Control de Acceso |
| **RF-03** | **Edición de Perfil y Preferencias** | El sistema debe permitir al usuario consultar y actualizar sus datos personales, medidas antropométricas, objetivos de acondicionamiento físico, equipamiento disponible, disponibilidad horaria y restricciones alimentarias. | Personalización / Perfil de Usuario |
| **RF-04** | **Gestión de Sesión y Seguridad** | El sistema debe permitir al usuario cerrar sesión de forma segura y solicitar el restablecimiento de contraseña mediante el envío de un enlace o código de verificación. | Seguridad / Autenticación |

---

### Módulo 2: Inteligencia Artificial (Rutinas y Nutrición)

| ID | Requerimiento Funcional | Descripción | Impacto / Dominio |
| :--- | :--- | :--- | :--- |
| **RF-05** | **Generación Personalizada de Rutinas con IA** | El sistema debe generar una rutina de entrenamiento adaptativa procesando edad, sexo, peso, altura, objetivos, nivel de experiencia, equipamiento disponible y tiempo disponible del usuario. | Motor IA / Entrenamiento |
| **RF-06** | **Generación Personalizada de Planes Nutricionales con IA** | El sistema debe generar un plan de alimentación ajustado calculando el requerimiento calórico e ingesta de macronutrientes (*proteínas, carbohidratos, grasas*) según métricas, objetivos y alergias/restricciones. | Motor IA / Nutrición |
| **RF-07** | **Aceptación y Asignación de Propuestas de IA** | El sistema debe permitir al usuario visualizar la propuesta de la IA para **aceptarla, regenerarla o modificarla** antes de integrarla oficialmente en su calendario personal. | Flujo de Decisiones / Experiencia de Usuario |

---

### Módulo 3: Catálogos y Bancos de Información

| ID | Requerimiento Funcional | Descripción | Impacto / Dominio |
| :--- | :--- | :--- | :--- |
| **RF-08** | **Gestión del Banco de Ejercicios** | El sistema debe proporcionar un catálogo estructurado de ejercicios categorizados por disciplina, grupo muscular y dificultad, incluyendo guías e instrucciones explícitas. | Catálogos / Contenido Técnico |
| **RF-09** | **Gestión del Banco de Recetas** | El sistema debe proporcionar un banco de recetas indexadas por tipo de comida, detallando ingredientes, procedimiento, desglose calórico y desglose de macronutrientes. | Catálogos / Contenido Nutricional |

---

### Módulo 4: Seguimiento, Monitoreo y Registro Diario

| ID | Requerimiento Funcional | Descripción | Impacto / Dominio |
| :--- | :--- | :--- | :--- |
| **RF-10** | **Seguimiento y Cumplimiento de Entrenamientos** | El sistema debe permitir al usuario consultar su programación diaria y marcar los ejercicios o series ejecutadas como completados. | Seguimiento / Registros |
| **RF-11** | **Registro de Consumo Nutricional** | El sistema debe permitir al usuario registrar los alimentos ingeridos seleccionándolos de su dieta programada o agregando ítems individuales (*recetas/snacks*) del catálogo. | Registros / Nutrición |
| **RF-12** | **Cálculo Nutricional Consolidado** | El sistema debe calcular y acumular automáticamente la ingesta total de calorías, macronutrientes y micronutrientes consumidos a lo largo del día. | Lógica de Negocio / Procesamiento |
| **RF-13** | **Monitoreo de Actividad Física y Gasto Calórico** | El sistema debe permitir el registro de la actividad física diaria (*pasos, distancia y tiempo*) y estimar las calorías totales quemadas. | Seguimiento / Fisiología |

---

### Módulo 5: Dashboard y Visualización de Métricas

| ID | Requerimiento Funcional | Descripción | Impacto / Dominio |
| :--- | :--- | :--- | :--- |
| **RF-14** | **Panel Principal Centralizado (Dashboard)** | El sistema debe presentar un panel interactivo que consolide la información en tiempo real del progreso del usuario. | Visualización / Frontend |
| **RF-15** | **Despliegue de Métricas Antropométricas e IMC** | El sistema debe calcular automáticamente el $IMC$ ($\text{peso} / \text{altura}^2$) y mostrar su valor actualizado junto con un indicador del estado de salud según rangos estándar. | Cálculo Automático / Métricas |
| **RF-16** | **Visualización de Programación Diaria** | El sistema debe desplegar en el Dashboard la rutina de ejercicios y el plan de alimentación agendados específicamente para el día en curso. | Dashboard / Planificación |
| **RF-17** | **Resumen Gráfico de Progreso** | El sistema debe mostrar gráficamente la comparativa entre consumo real vs. meta diaria, así como el progreso acumulado de actividad física. | Gráficos / Reporte de Rendimiento |

---

## 2. Introducción y Propósito

El sistema **XEF** es una plataforma integral orientada al seguimiento del acondicionamiento físico, nutrición y bienestar personal asistida por Inteligencia Artificial. Su propósito primordial es guiar el desarrollo técnico asegurando que las funcionalidades implementadas satisfagan los requerimientos de salud, precisión nutricional y rendimiento deportivo de los usuarios finales.

---

## 3. Diagnóstico y Correcciones de Arquitectura Aplicadas

De la revisión y evolución del sistema, se han aplicado las siguientes mejoras técnicas a nivel de arquitectura de software:

1. **Desacoplamiento del Dashboard:** Separación de la lógica de registro/cálculo en Backend respecto al despliegue gráfico en Frontend para mayor mantenibilidad.
2. **Soporte Completo de Macronutrientes:** Inclusión explícita de proteínas, carbohidratos y grasas junto a calorías e ingesta hídrica/micronutrientes.
3. **Control de Flujo de IA:** Implementación de un estado intermedio donde el usuario aprueba, rechaza, modifica o regenera las sugerencias de rutinas o dietas antes de guardarlas en el calendario.
4. **Integridad de Perfil:** Captura rigurosa de restricciones alimentarias, alergias, disponibilidad y equipamiento físico para asegurar *prompts* de IA óptimos.
5. **Seguridad y Sesiones:** Manejo estructurado de autenticación, revocación de tokens de sesión y recuperación de credenciales mediante correo de verificación.

---

## 4. Trazabilidad con el Modelo de Datos (Diagramas ER y Clases)

Los Requerimientos Funcionales se alinean directamente con los modelos técnicos definidos para el proyecto:

```
+-----------------------------------------------------------------------------------+
|                                 USUARIO (RF-01, RF-02, RF-03, RF-04)               |
|                                 - imc: Float, infoAlimenticiaDia, infoFisicaDia   |
+-----------------------------------------------------------------------------------+
             | (1)                               | (1)                         | (1)
             |                                   |                             |
             v (0..1)                            v (0..1)                      v (0..*)
+-------------------------+         +--------------------------+    +-----------------------+
|  DIETA (RF-06, RF-07)   |         | RUTINA (RF-05, RF-07)   |    | HISTORIAL (RF-12,13)  |
|  - infoNutricional      |         | - infoFisica             |    | - infoNutricionalRes  |
+-------------------------+         +--------------------------+    | - infoFisicaResumen   |
  | (1..*)               | (0..*)     | (1..*)                      +-----------------------+
  v                      v            v
+----------------+  +---------+  +-------------------------------+
| DietaReceta    |  | Snack   |  | RutinaEjercicio (RF-08, RF-10)|
| - momentoDia   |  +---------+  | - series, reps, tiempoSeg     |
+----------------+               +-------------------------------+
  | (1)                             | (1)
  v                                 v
+----------------+               +-------------------------------+
| Receta (RF-09) |               | Ejercicio (RF-08)             |
+----------------+               +-------------------------------+
  | (1..*)
  v
+-----------------------+
| RecetaIngrediente     | ---> Ingrediente
+-----------------------+
```

### Resumen de Entidades Principales:
* **`Usuario`**: Almacena datos antropométricos y métricas consolidadas (`imc`, `infoAlimenticiaDia`, `infoFisicaDia`).
* **`Rutina` / `RutinaEjercicio` / `Ejercicio`**: Estructuran la planificación de entrenamiento y catálogo de ejercicios (**RF-05, RF-08, RF-10**).
* **`Dieta` / `DietaReceta` / `Receta` / `Ingrediente` / `Snack`**: Sostienen los planes de nutrición, macronutrientes y catálogo (**RF-06, RF-09, RF-11**).
* **`Historial`**: Guarda resúmenes diarios pasados para graficar progresos (**RF-12, RF-13, RF-17**).

---

## 5. Próximos Pasos Recomendados

1. **Diagrama de Casos de Uso (UML):** Mapear interacciones entre los actores principales (Usuario, Motor IA, Sistema de Autenticación).
2. **Historias de Usuario & Criterios de Aceptación:** Desglosar los 17 RFs en tareas ágiles (Sprints) con formato *Dado que / Cuando / Entonces*.
3. **Diseño y Normalización de BD:** Implementar la base de datos relacional (ej. PostgreSQL con columnas `jsonb` para métricas flexibles) basándose en el Diagrama ER.
4. **Prototipado UI/UX (Dashboard RF-14):** Wireframes y prototipos interactivos en Figma orientados al diseño *Mobile-First*.