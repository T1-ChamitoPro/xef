Deno.serve(async (req: Request) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
      }
    })
  }

  try {
    const { dias, objetivo, estiloVida, tipoDieta, intolerancias } = await req.json()
    const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')

    const prompt = `
    Eres un nutricionista profesional. Genera exactamente 3 opciones de planes de alimentación/dietas distintas.

    Parámetros del usuario:
    - Días: ${dias.join(', ')}
    - Objetivo: ${objetivo}
    - Estilo de vida/Trabajo: ${estiloVida}
    - Tipo de dieta: ${tipoDieta}
    - Intolerancias/Alergias: ${intolerancias.length > 0 ? intolerancias.join(', ') : 'Ninguna'}

    Responde ÚNICAMENTE con un arreglo JSON válido (sin sintaxis markdown \`\`\`json) que contenga 3 objetos con esta estructura exacta:
    [
      {
        "titulo": "Nombre del plan (ej. Plan Balanceado Proteico)",
        "descripcion": "Explicación corta de la estrategia nutricional",
        "menu": {
          "${dias[0] || 'LUNES'}": {
            "desayuno": "2 huevos revueltos con espinacas, 1 rebanada de pan integral y café",
            "almuerzo": "150g de pechuga a la plancha, media taza de arroz integral, ensalada de pepino",
            "cena": "Filete de pescado al horno con hierbas y ajo, media taza de puré de papas, porción de brócoli al vapor"
          }
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
    const jsonDietas = JSON.parse(textResult)

    return new Response(JSON.stringify(jsonDietas), {
      headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
      status: 200,
    })
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : 'Error desconocido'
    return new Response(JSON.stringify({ error: errorMessage }), {
      headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
      status: 500,
    })
  }
})