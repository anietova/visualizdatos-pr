# Práctica de visualización de datos: accidentes aéreos

Este repositorio contiene los componentes de la práctica de **visualización de datos** del master universitario de la UOC de ciencia de datos.

En esta versión, se acometen las tareas para la parte 1 de la práctica:

* Elección del dataset: en este caso no es un dataset como tal sino que se conforma a partir del archivo **avall.mdb** obtenido de [NTSB](https://data.ntsb.gov/avdata). Contiene datos desde 2008 hasta 2025.

* Análisis: análisis modelo de datos NTSB para conformar dataset y definición de las variables de estudio para el proyecto de visualización.

* Generación dataset Parte I: sin aumento de datos ni características.

## Estructura del Proyecto

```
/
│
├── data/               # Datos de entrada (mdb) salida (.db, .csv) Se deja sólo dataset salida
├── profiling/          # profiling dataset
│
├── 00-ExtractAccess&Load.ipynb    # carga de datos mdb => .db
├── 01a-EDA.ipynb                  # Profilings datos origen y análisis. 
├── 01a-EDA.sql                    # Consultas SQL análisis 
├── 02-GenerateDatasetp1.ipynb     # Extracción dataset parte 1 de la práctica a csv
├── 03-Profiling.ipynb             # Profiling yadata dataset final extraído 
│
├── requirements.txt    # librerías fuera de la base python
└── LICENSE             # Licencia del proyecto
```

## Instalación y Requisitos

Para ejecutar los notebooks, se recomienda utilizar **Python 3.10**. Las dependencias necesarias están listadas en `requirements.txt`.

### Instalación
Después de realizar el clone de repositorio se recomienda crear un entorno con las librerías necesarias.

```bash
python -m venv prp1
prp1\Scripts\activate
pip install -r requirements.txt
```

## Licencia
Este proyecto está bajo la licencia MIT. Consulta el archivo `LICENSE` para más detalles.