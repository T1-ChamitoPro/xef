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
    const { dias, objetivo, estiloVida, tipoDieta, intolerancias } = body

    if (!dias || !Array.isArray(dias) || dias.length === 0) {
      return new Response(JSON.stringify({ error: 'Falta el parámetro "dias"' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
      })
    }

    const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')
    if (!GEMINI_API_KEY) {
      throw new Error('GEMINI_API_KEY no está configurada en los secrets de Supabase')
    }

    const prompt = `
Eres un nutricionista profesional certificado con amplia experiencia en planes alimenticios personalizados.

Genera exactamente 2 opciones de dietas distintas y realistas según estos datos del usuario:
- Días a cubrir: ${JSON.stringify(dias)}
- Objetivo nutricional: ${objetivo || 'BIENESTAR GENERAL'}
- Estilo de vida: ${estiloVida || 'SEDENTARIO'}
- Tipo de dieta: ${tipoDieta || 'BALANCEADA'}
- Intolerancias / Alergias (NO incluir estos alimentos): ${JSON.stringify(intolerancias || [])}

Devuelve ÚNICAMENTE un array JSON válido (sin markdown ni texto extra) con este formato exacto:

[
  {
    "titulo": "Plan Déficit Calórico Balanceado",
    "descripcion": "Enfocado en pérdida de grasa con comidas fáciles de preparar y alta saciedad.",
    "menu": {
      "LUNES": {
        "desayuno": "Avena con plátano y canela + café negro",
        "almuerzo": "Pechuga de pollo a la plancha 150g + arroz integral + ensalada de tomate y pepino",
        "cena": "Salmón al horno + brócoli al vapor + puré de calabaza"
      },
      "MIÉRCOLES": {
        "desayuno": "...",
        "almuerzo": "...",
        "cena": "..."
      }
    }
  },
  {
    "titulo": "Plan Alto en Proteína",
    "descripcion": "Diseñado para preservar masa muscular durante el déficit calórico.",
    "menu": {
      "LUNES": {
        "desayuno": "...",
        "almuerzo": "...",
        "cena": "..."
      }
    }
  }
]

Reglas importantes:
- Genera exactamente 2 planes diferentes.
- Dentro de "menu" incluye TODOS los días que te pasé (usa los nombres exactos en MAYÚSCULAS).
- Cada día debe tener exactamente las claves: "desayuno", "almuerzo" y "cena".
- Adapta las porciones y alimentos al objetivo (${objetivo}), estilo de vida (${estiloVida}) y tipo de dieta (${tipoDieta}).
- Respeta estrictamente las intolerancias/alergias: no uses ninguno de estos alimentos: ${JSON.stringify(intolerancias || [])}.
- Sé realista, práctico y variado.
- No agregues ningún texto fuera del JSON.
`

    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${GEMINI_API_KEY}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          contents: [{ parts: [{ text: prompt }] }],
          generationConfig: {
            responseMimeType: 'application/json',
            temperature: 0.7,
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

    const dietas = JSON.parse(textResult)
    const resultado = Array.isArray(dietas) ? dietas : [dietas]

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