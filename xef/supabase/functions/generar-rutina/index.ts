Deno.serve(async (req: Request) => {
  // CORS
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
    const { dias, modalidad, objetivo } = body

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

    const prompt = `
Eres un entrenador personal profesional certificado.

Genera exactamente 2 opciones de rutinas de ejercicio distintas y realistas según estos datos:
- Días de entrenamiento: ${JSON.stringify(dias)}
- Modalidad: ${modalidad || 'gimnasio'}
- Objetivo: ${objetivo || 'salud general'}

Devuelve ÚNICAMENTE un array JSON válido (sin markdown ni texto extra) con este formato exacto:

[
  {
    "titulo": "Rutina Full Body Principiante",
    "descripcion": "Enfocada en construir base de fuerza y técnica con ejercicios compuestos.",
    "ejercicios": {
      "LUNES": [
        "Sentadilla con peso corporal 3x12",
        "Flexiones de pecho 3x10",
        "Remo con banda 3x12",
        "Plancha 3x30 segundos"
      ],
      "MIÉRCOLES": [
        "Peso muerto rumano con mancuernas 3x10",
        "Press militar con mancuernas 3x10",
        "Zancadas 3x10 por pierna",
        "Elevaciones laterales 3x12"
      ]
    }
  },
  {
    "titulo": "Rutina Hipertrofia Intermedia",
    "descripcion": "Enfocada en volumen muscular y progresión de cargas.",
    "ejercicios": {
      "LUNES": [
        "Sentadilla con barra 4x8",
        "Press banca 4x8",
        "Remo con barra 4x10",
        "Fondos en paralelas 3x10"
      ]
    }
  }
]

Reglas importantes:
- Genera exactamente 2 planes diferentes.
- Dentro de "ejercicios" incluye TODOS los días que te pasé (usa los nombres exactos en MAYÚSCULAS).
- Cada día debe ser un array de strings con el formato: "Nombre del ejercicio series x repeticiones".
- Adapta los ejercicios a la modalidad (${modalidad}) y al objetivo (${objetivo}).
- Sé realista con el volumen según el nivel implícito del objetivo.
- No agregues ningún texto fuera del JSON.
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
            temperature: 0.75,
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