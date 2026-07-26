--promedio por región
SELECT
    "Region",
    AVG("Demanda_MW") AS demanda_promedio
FROM energy_demand_eda
GROUP BY "Region";

--demanda promedio por hora
SELECT
    "Hora",
    AVG("Demanda_MW") AS demanda_promedio
FROM energy_demand_eda
GROUP BY "Hora"
ORDER BY "Hora";

--demanda promedio por día
SELECT
    "Nombre_Día",
    AVG("Demanda_MW") AS demanda_promedio
FROM energy_demand_eda
GROUP BY "Nombre_Día";

--demanda promedio entre semana y finde
SELECT
    "Region",
    "Fin_de_Semana",
    AVG("Demanda_MW") AS demanda_promedio
FROM energy_demand_eda
GROUP BY
    "Region",
    "Fin_de_Semana"
ORDER BY
    "Region",
    "Fin_de_Semana";

	--demanda promedio por dia de la semana
	SELECT
    "Region",
    "Nombre_Día",
    AVG("Demanda_MW") AS demanda_promedio
FROM energy_demand_eda
GROUP BY
    "Region",
    "Nombre_Día"
ORDER BY
    "Region",
    demanda_promedio DESC;

	--demanda promedio por mes y region
	SELECT
    "Region",
    "Mes",
    AVG("Demanda_MW") AS demanda_promedio
FROM energy_demand_eda
GROUP BY
    "Region",
    "Mes"
ORDER BY
    "Region",
    "Mes";

--demanda promedio por año y region
SELECT
    "Region",
    "Año",
    AVG("Demanda_MW") AS demanda_promedio
FROM energy_demand_eda
GROUP BY
    "Region",
    "Año"
ORDER BY
    "Region",
    "Año";

	--demanda maxima por region
	SELECT
    "Region",
    MAX("Demanda_MW") AS demanda_maxima
FROM energy_demand_eda
GROUP BY
    "Region"
ORDER BY
    demanda_maxima DESC;

	--demanda minima por region
	SELECT
    "Region",
    MIN("Demanda_MW") AS demanda_minima
FROM energy_demand_eda
GROUP BY
    "Region"
ORDER BY
    demanda_minima DESC;

	-- Fecha y hora de la demanda máxima por región
	SELECT
    "Region",
    "Datetime_Local",
    "Demanda_MW"
FROM energy_demand_eda
WHERE ("Region", "Demanda_MW") IN (
    SELECT
        "Region",
        MAX("Demanda_MW")
    FROM energy_demand_eda
    GROUP BY "Region"
)
ORDER BY
    "Region";

--identificar cuándo ocurrió la demanda máxima
SELECT
    "Region",
    "Datetime_Local",
    "Demanda_MW"
FROM energy_demand_eda
WHERE ("Region", "Demanda_MW") IN (
    SELECT
        "Region",
        MAX("Demanda_MW")
    FROM energy_demand_eda
    GROUP BY "Region"
)
ORDER BY
    "Region";
	
--identificar cuándo ocurrió la demanda mínima
SELECT
    "Region",
    "Datetime_Local",
    "Demanda_MW"
FROM energy_demand_eda
WHERE ("Region", "Demanda_MW") IN (
    SELECT
        "Region",
        MIN("Demanda_MW")
    FROM energy_demand_eda
    GROUP BY "Region"
)
ORDER BY
    "Region";
	
--analizar variabilidad de la demanda
SELECT
    "Region",
    AVG("Demanda_MW") AS demanda_promedio,
    STDDEV("Demanda_MW") AS desviacion_estandar,
    MIN("Demanda_MW") AS demanda_minima,
    MAX("Demanda_MW") AS demanda_maxima
FROM energy_demand_eda
GROUP BY
    "Region"
ORDER BY
    desviacion_estandar DESC;
	
--analizar tendencias temporales
SELECT
    "Region",
    "Año",
    AVG("Demanda_MW") AS demanda_promedio
FROM energy_demand_eda
GROUP BY
    "Region",
    "Año"
ORDER BY
    "Region",
    "Año";

-- analizar cambio interanual de la demanda
WITH demanda_anual AS (
    SELECT
        "Region",
        "Año",
        AVG("Demanda_MW") AS demanda_promedio
    FROM energy_demand_eda
    GROUP BY
        "Region",
        "Año"
)

SELECT
    "Region",
    "Año",
    demanda_promedio,
    LAG(demanda_promedio) OVER (
        PARTITION BY "Region"
        ORDER BY "Año"
    ) AS demanda_año_anterior,
    demanda_promedio
    - LAG(demanda_promedio) OVER (
        PARTITION BY "Region"
        ORDER BY "Año"
    ) AS cambio_absoluto
FROM demanda_anual
ORDER BY
    "Region",
    "Año";
