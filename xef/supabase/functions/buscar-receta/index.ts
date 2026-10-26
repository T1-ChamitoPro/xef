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
    const { busqueda } = await req.json()

    if (!busqueda || typeof busqueda !== 'string' || busqueda.trim().length < 2) {
      return new Response(JSON.stringify({ error: 'Escribe al menos 2 caracteres para buscar' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
      })
    }

    const GEMINI_API_KEY = Deno.env.get('BUSCAR_RECETA_API_KEY')
    if (!GEMINI_API_KEY) {
      throw new Error('BUSCAR_RECETA_API_KEY no está configurada en los secrets')
    }

    const prompt = `
Eres un chef profesional, educador culinario y experto en nutrición.

El usuario busca: "${busqueda.trim()}"

Genera un máximo de 6 recetas **diferentes, variadas y minuciosamente explicadas** relacionadas con esa búsqueda.

REGLAS DE PREPARACIÓN PASO A PASO:
1. NO te limites a un número fijo de pasos genéricos (como 5). Genera la cantidad real de pasos que la receta requiera para ser explicada perfectamente (pueden ser 6, 8, 10 o más).
2. Cada paso dentro del arreglo "pasos" debe ser ULTRA ESPECÍFICO, DIDÁCTICO Y GUIADO para que el usuario NO tenga dudas:
   - Especifica la técnica exacta de corte o preparación previa (ej. "Seca la proteína con papel absorbente", "Corta en dados de 2 cm", "Corta en julianas finas").
   - Detalla la temperatura o intensidad del fuego (ej. "fuego medio-alto", "fuego bajo a borbotones lentos", "horno precalentado a 180°C").
   - Define tiempos exactos por cada lado o fase (ej. "Cocina durante 4 minutos exactos sin moverlo", "Saltea por 3 minutos").
   - Añade pistas visuales, táctiles o aromáticas de listo (ej. "Hasta que los bordes se vean opacos y dorados", "Hasta que la cebolla esté acitronada y transparente").
   - Indica el uso de utensilios específicos (ej. "Pincela con una brocha de silicona", "Remueve constantemente con una cuchara de madera").
   - Incluye el reposo final previo al servido cuando aplique.

OTRAS INSTRUCCIONES:
- Ofrece variedad de técnicas de cocción, acompañamientos y estilos culinarios.
- "cantidad" debe ser un número.
- "tiempo_preparacion_min" debe ser un número entero.
- En lo posible, no usar lenguaje tecnico ni tan profesional o academico
- Usar lenguaje neutro, y soloquial para que lo entienda cualquier persona

Devuelve ÚNICAMENTE un array JSON válido (sin etiquetas markdown \`\`\`json) con este formato exacto:

[
  {
    "nombre": "Nombre atractivo y explicativo de la receta",
    "descripcion": "Descripción breve y apetitosa de 1-2 líneas",
    "tiempo_preparacion_min": 25,
    "dificultad": "Fácil",
    "resumen_nutricional": "Aporta 420 calorías, 38g de proteínas, 32g de carbohidratos y 14g de grasas.",
    "info_nutricional": {
      "calorias": 420,
      "proteinas_g": 38,
      "carbohidratos_g": 32,
      "grasas_g": 14
    },
    "etiquetas": ["Alto en proteína", "Rápido", "Saludable"],
    "ingredientes": [
      { "nombre": "Pechuga de pollo", "cantidad": 200, "unidad": "g" },
      { "nombre": "Quinoa", "cantidad": 80, "unidad": "g" }
    ],
    "pasos": [
      "Coloca la pechuga de pollo sobre una tabla limpia y seca la superficie con papel absorbente. Corta en filetes parejos de 1.5 cm de grosor.",
      "Sazona cada filete con 1/2 cucharadita de sal, pimienta negra molida y el jugo de medio limón. Deja marinar a temperatura ambiente por 5 minutos.",
      "Calienta una sartén antiadherente a fuego medio-alto con 1 cucharada de aceite de oliva durante 90 segundos hasta que el aceite brille sin humear.",
      "Coloca los filetes en la sartén caliente. Cocina sin moverlos durante 4 minutos hasta que la base esté dorada y los bordes se tornen blancos opacos.",
      "Dale la vuelta a los filetes con pinzas de cocina y cocina el otro lado durante 3 a 4 minutos adicionales hasta que alcancen una textura firme al tacto.",
      "Retira los filetes a un plato limpio, cúbrelos holgadamente con papel de aluminio y déjalos reposar durante 3 minutos antes de servir para reabsorber los jugos."
    ]
  }
]

Devuelve solo el JSON, sin texto previo ni posterior.
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
            temperature: 0.85,
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
      throw new Error('Gemini no devolvió contenido válido')
    }

    const recetas = JSON.parse(textResult)
    const resultado = Array.isArray(recetas) ? recetas.slice(0, 6) : [recetas]

    return new Response(JSON.stringify(resultado), {
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      },
      status: 200,
    })
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : 'Error desconocido'
    console.error('Error en buscar-receta:', errorMessage)

    return new Response(JSON.stringify({ error: errorMessage }), {
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      },
      status: 500,
    })
  }
})