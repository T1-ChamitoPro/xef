Deno.serve(async (req: Request) => {
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

    const randomSeed = Math.random().toString(36).substring(7)
    const tieneIntolerancias = intolerancias && Array.isArray(intolerancias) && intolerancias.length > 0

    const prompt = `
Eres un Nutricionista Clínico Certificado y Chef Nutricional de Alto Rendimiento.

Tu tarea es generar exactamente 3 propuestas de planes alimenticios COMPLETAMENTE DIVERSIFICADOS, prácticos y sabrosos basados en la siguiente información del usuario:

DATOS DEL USUARIO:
- Días a cubrir: ${JSON.stringify(dias)}
- Objetivo nutricional: ${objetivo || 'BIENESTAR GENERAL'}
- Estilo de vida: ${estiloVida || 'SEDENTARIO'}
- Tipo de dieta: ${tipoDieta || 'BALANCEADA'}
- INTOLERANCIAS Y ALERGIAS: ${JSON.stringify(intolerancias || [])}
- Variador aleatorio de propuesta: ${randomSeed}

REGLAS STRICTAS OBLIGATORIAS:
1. EXCLUSIÓN ABSOLUTA DE INTOLERANCIAS (REGLA DE ORO):
   ${tieneIntolerancias 
      ? `EL USUARIO ES INTOLERANTE O ALÉRGICO A: ${JSON.stringify(intolerancias)}. ESTÁ ABSOLUTAMENTE PROHIBIDO incluir estos ingredientes o derivados en cualquiera de las comidas (desayuno, almuerzo, cena). Sustitúyelos por alternativas nutritivas y equivalentes.`
      : 'Sin alergias ni intolerancias reportadas, usa alimentos variados y balanceados.'}

2. DIVERSIFICACIÓN Y NO REPETICIÓN:
   - Genera exactamente 3 opciones de dietas distintas entre sí (Opción 1: Menú Práctico y Rápido, Opción 2: Enfoque Gourmet/Nutritivo, Opción 3: Enfoque de Densidad de Nutrientes).
   - Varía los platos, fuentes de proteína, carbohidratos y grasas saludables en cada opción.

3. DÍAS Y FORMATO:
   - Incluye TODOS los días solicitados: ${JSON.stringify(dias)} (los nombres de las llaves de días dentro de "menu" deben estar estrictamente en MAYÚSCULAS).
   - Cada día debe tener obligatoriamente las tres comidas: "desayuno", "almuerzo" y "cena".

FORMATO DE SALIDA EXCLUSIVO (Devuelve únicamente un JSON válido, sin textos externos ni bloques de markdown \`\`\`json):
[
  {
    "titulo": "Título atractivo y descriptivo del Plan 1",
    "descripcion": "Breve resumen de cómo esta opción cumple el objetivo de ${objetivo} respetando las intolerancias indicadas.",
    "menu": {
      "${dias[0] || 'LUNES'}": {
        "desayuno": "Descripción completa de plato y porción aproximada",
        "almuerzo": "Descripción completa de plato y porción aproximada",
        "cena": "Descripción completa de plato y porción aproximada"
      }
    }
  }
]
`

    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash-lite:generateContent?key=${GEMINI_API_KEY}`,
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