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
    const { busqueda } = await req.json()
    const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')

    const prompt = `
    Eres un chef profesional y experto en nutrición. 
    Busca o genera información completa sobre la receta o platillo referente a: "${busqueda}".

    Devuelve ÚNICAMENTE un objeto JSON válido (sin markdown \`\`\`json) con el siguiente formato exacto:
    {
      "nombre": "Nombre formal de la receta",
      "info_nutricional": {
        "resumen": "Resumen nutricional corto (ej. Aporta 394 calorías, 24g de proteínas, 47g de carbohidratos, 12g de grasas).",
        "calorias": 394,
        "proteinas_g": 24,
        "carbohidratos_g": 47,
        "grasas_g": 12
      },
      "ingredientes": [
        {"nombre": "Mazorcas precocidas", "cantidad": "2", "unidad": "unidades"},
        {"nombre": "Zanahorias", "cantidad": "1", "unidad": "pieza"},
        {"nombre": "Aceite de oliva extravirgen", "cantidad": "1", "unidad": "chorro"}
      ],
      "pasos": [
        "Desgranar las mazorcas",
        "Pelar y picar las zanahorias en cuadros",
        "Sofreír las verduras a fuego medio",
        "Agregar el caldo vegetal y cocinar por 15 minutos"
      ]
    }
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
    const jsonReceta = JSON.parse(textResult)

    return new Response(JSON.stringify(jsonReceta), {
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