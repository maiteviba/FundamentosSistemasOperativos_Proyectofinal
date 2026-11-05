# Proyecto Final:

## Fundamentos de Sistemas Operativos

Este repositorio contiene el código desarrollado por Verónica y Maite para el proyecto final de la asignatura de Fundamentos de Sistemas Operativos de 2º iMAT.

El proyecto se realiza sobre Alpine Linux y consiste en:

1. Preparar el sistema instalando los paquetes necesarios
2. Desplegar una aplicación web en Flask
3. Descargar y procesar un dataset de check-ins de Gowalla, calcular estadísticas y generar mapas por ciudad
4. Hacer peticiones a la API de la aplicación para entrenar un modelo con distintos tamaños de train y test
5. Comparar el tiempo de ejecución secuencial y en paralelo


## Estructura del proyecto

- `apartado1_Veronica_Maite.sh`: instalación de los paquetes necesarios
- `apartado_despliegue_Veronica_Maite.sh`: despliegue de la aplicación
- `Ejercicio3_Veronica_Maite.sh`: descarga y procesado del dataset
- `estadisticas.py`: estadísticas del dataset
- `topn_selection_Veronica_Maite.py`: selección de los usuarios con más interacciones
- `apartado4_Veronica_Maite.py`: peticiones a la API de la aplicación
- `compare_execution.py`: comparación entre ejecución secuencial y paralela
- `requirements.txt`: librerías necesarias


## Requisitos

Los scripts están pensados para ejecutarse en Alpine Linux. Para la parte de Python es necesario tener instalado Python 3 y las librerías indicadas en `requirements.txt`.
