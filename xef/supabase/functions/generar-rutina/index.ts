const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')

Deno.serve(async (req: Request) => {
  // Manejo de CORS para llamadas desde Flutter
  if (req.method === 'OPTIONS') {
    return new Response('ok', {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
      }
    })
  }

  try {
    const { dias, modalidad, objetivo } = await req.json()

    const prompt = `
    Eres un entrenador personal profesional. Genera exactamente 3 opciones de rutinas de ejercicio distintas y personalizadas.
    
    Parámetros del usuario:
    - Días de entrenamiento: ${dias.join(', ')}
    - Modalidad: ${modalidad}
    - Objetivo: ${objetivo}

    Responde ÚNICAMENTE con un arreglo JSON válido (sin sintaxis de markdown como \`\`\`json) que contenga 3 objetos con este formato:
    [
      {
        "titulo": "Nombre corto de la rutina",
        "descripcion": "Breve explicación de la estrategia del entrenamiento",
        "ejercicios": {
          "${dias[0] || 'LUNES'}": ["Ejercicio 1 (series x reps)", "Ejercicio 2", "Ejercicio 3"]
        }
      }
    ]
    `

    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          contents: [{ parts: [{ text: prompt }] }],
          generationConfig: { responseMimeType: "application/json" }
        })
      }
    )

    const data = await response.json()
    const textResult = data.candidates[0].content.parts[0].text
    const jsonRutinas = JSON.parse(textResult)

    return new Response(JSON.stringify(jsonRutinas), {
      headers: { 
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*' 
      },
      status: 200,
    })
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : 'Error desconocido';
    return new Response(JSON.stringify({ error: errorMessage }), {
      headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
      status: 500,
    })
  }
})