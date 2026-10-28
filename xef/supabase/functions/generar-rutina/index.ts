Deno.serve(async (req: Request) => {
  // CORS Headers
  if (req.method === 'OPTIONS') {
    return new Response('ok', {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
      },
    })
  }

  try {
    const body = await req.json()
    const { dias, modalidad, objetivo, nivel, grupos_musculares, observaciones } = body

    if (!dias || !Array.isArray(dias) || dias.length === 0) {
      return new Response(JSON.stringify({ error: 'Falta el parámetro "dias"' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
      })
    }

    const RUTINA_API_KEY = Deno.env.get('RUTINA_API_KEY')
    if (!RUTINA_API_KEY) {
      throw new Error('RUTINA_API_KEY no está configurada en los secrets de Supabase')
    }

    // Inyección de aleatoriedad para evitar resultados idénticos en llamadas seguidas
    const randomSeed = Math.random().toString(36).substring(7)
    const tieneObservaciones = observaciones && observaciones.trim().length > 0

    const prompt = `
      Eres un Entrenador Personal de Élite y Especialista en Biomecánica y Rehabilitación Deportiva.

      Tu tarea es generar exactamente 3 propuestas de rutinas de ejercicio COMPLETAMENTE DIVERSIFICADAS y realistas según la siguiente información:

      DATOS DE ENTRADA:
      - Días solicitados: ${JSON.stringify(dias)}
      - Modalidad: ${modalidad || 'Gimnasio Tradicional'}
      - Objetivo: ${objetivo || 'Hipertrofia Muscular'}
      - Nivel de experiencia: ${nivel || 'Intermedio'}
      - Grupos musculares a priorizar: ${JSON.stringify(grupos_musculares || [])}
      - OBSERVACIONES Y LESIONES (CRÍTICO): "${observaciones || 'Ninguna'}"
      - Variador aleatorio de sesión: ${randomSeed}

      REGLAS STRICTAS OBLIGATORIAS:
      1. OBSERVACIONES E INCAPACIDADES (REGLA DE ORO):
         ${tieneObservaciones 
            ? `EL USUARIO HA INDICADO: "${observaciones}". Si menciona una lesión, molestia, falta de equipo o limitación (ej: dolor de rodilla, sin pesas, hernia, sin impacto), ESTÁ ABSOLUTAMENTE PROHIBIDO incluir ejercicios que estresen esa zona o requieran ese equipo. Sustitúyelos obligatoriamente por alternativas seguras.`
            : 'Sin limitaciones reportadas, aplica ejercicios estándares para la modalidad.'}

      2. DIVERSIFICACIÓN Y NO REPETICIÓN:
         - Genera exactamente 3 opciones distintas (Opción 1: Enfoque Clásico/Fuerza, Opción 2: Variación Dinámica/Volumen, Opción 3: Enfoque Funcional/Rango Completo).
         - Utiliza diferentes combinaciones de ejercicios, ángulos de trabajo y esquemas de series/repeticiones entre las opciones.

      3. GRUPOS MUSCULARES Y DÍAS:
         - Asegúrate de dar mayor volumen de trabajo a los grupos: ${JSON.stringify(grupos_musculares || [])}.
         - Genera la lista de ejercicios para CADA UNO de los días enviados: ${JSON.stringify(dias)} (nombres de días estrictamente en MAYÚSCULAS).

      FORMATO DE SALIDA EXCLUSIVO (Devuelve únicamente un JSON válido, sin bloques de markdown):
      [
        {
          "titulo": "Título técnico y atractivo de la opción",
          "descripcion": "Breve explicación de cómo se adaptan los ejercicios para cumplir los objetivos y respetar las limitaciones/lesiones expresadas.",
          "ejercicios": {
            "${dias[0] || 'LUNES'}": [
              "Nombre del ejercicio 4 x 10-12 reps",
              "Nombre del segundo ejercicio 3 x 12 reps"
            ]
          }
        }
      ]
    `

    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash-lite:generateContent?key=${RUTINA_API_KEY}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          contents: [{ parts: [{ text: prompt }] }],
          generationConfig: {
            responseMimeType: 'application/json',
            temperature: 0.9,
            topP: 0.95,
          },
        }),
      }
    )

    const data = await response.json()

    if (!response.ok || data.error) {
      console.error('Error de Gemini:', JSON.stringify(data, null, 2))
      throw new Error(data.error?.message || `Error de Gemini (${response.status})`)
    }

    const textResult = data?.candidates?.[0]?.content?.parts?.[0]?.text
    if (!textResult) {
      console.error('Respuesta inesperada de Gemini:', JSON.stringify(data, null, 2))
      throw new Error('Gemini no devolvió contenido válido')
    }

    const rutinas = JSON.parse(textResult)
    const resultado = Array.isArray(rutinas) ? rutinas : [rutinas]

    return new Response(JSON.stringify(resultado), {
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      },
      status: 200,
    })
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : 'Error desconocido'
    console.error('Error en la función:', errorMessage)

    return new Response(JSON.stringify({ error: errorMessage }), {
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      },
      status: 500,
    })
  }
})