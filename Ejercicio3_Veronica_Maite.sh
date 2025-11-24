#!/bin/ash
URL="https://drive.google.com/uc?export=download&id=1PHWBGuwDHw4ZEIlCbgMTiEUrG8FmlJK2"
PATH_MAIN_PYTHON="ProyectoFUSO/generate_maps.py"
PATH_GOWALLA_FILES="DatasetsGowalla/"
PATH_OUTPUT_GOWALLA_FILES="ProyectoFUSO/templates/html_files/"
ARCHIVO_ZIP="DatasetsGowalla.zip"

path_individual_map="ProyectoFUSO/generate_individual_maps.py"
ciudades="ElPaso Glasgow Manchester WashingtonDC"
ficheros="ElPasoGowalla.txt GlasgowGowalla.txt ManchesterGowalla.txt WashingtonDCGowalla.txt"

# Activamos el entorno virtual del apartado anterior:
source venv/bin/activate


echo "Descargando el fichero..."
wget --no-check-certificate -O $ARCHIVO_ZIP "$URL"

echo "Descomprimiendo fichero DatasetsGowalla.zip..."
unzip -qo $ARCHIVO_ZIP #Unzip en modo silencioso y sobreescribe los ficheros si ya existen

echo "" > ALL_LOCATIONS.txt #Creo el fichero, o en caso de que ya exista, lo limpio, inicializo
mkdir -p filtered_text #Creo el directorio sin que salte ningún error

echo "\nCreando ficheros..."
for fichero in ${PATH_GOWALLA_FILES}*; do

    nombre=$(basename "$fichero")

    if [[ " $ficheros " == *" $nombre "* ]]; then # Compruebo que es uno de los ficheros pedidos

        cut -d$'\t' -f 3,4,5 $fichero >> ALL_LOCATIONS.txt
        
        ciudad=${nombre%Gowalla.txt}

        cut -d$'\t' -f 1,2,5 $fichero > filtered_text/${ciudad}GowallaFiltered.txt

        echo "Estadísticas para $nombre"
        # Número de usuarios distintos: columna 1 del fichero sin cambiar
        usuarios_distintos=$(cut -d$'\t' -f 1 "$fichero" | sort -n | uniq | wc -l)
        lugares_distintos=$(cut -d$'\t' -f 5 "$fichero" | sort -n | uniq | wc -l)
        filas_unicas=$(sort "$fichero" | uniq | wc -l)
        filas_201007=$(cut -d$'\t' -f 2 "$fichero" | grep "2010-07" | wc -l)
        filas_201008=$(cut -d$'\t' -f 2 "$fichero" | grep "2010-08" | wc -l)

        echo "Número de usuarios distintos: $usuarios_distintos"
        echo "Número de localizaciones distintos: $lugares_distintos"
        echo "Número de filas completas: $filas_unicas"
        echo "Número de check-ins en 2010-07: $filas_201007"
        echo "Número de check-ins en 2010-08: $filas_201008"    

        python3 estadisticas.py "filtered_text/${ciudad}GowallaFiltered.txt"
    fi
done

echo "LLamamos a la funcon para generar mapas..."
for ciudad in $ciudades; do
    python3 $PATH_MAIN_PYTHON --input_file "${PATH_GOWALLA_FILES}${ciudad}Gowalla.txt" --city_name "$ciudad" --output_html "${PATH_OUTPUT_GOWALLA_FILES}${ciudad}GowallaMap.html"
done

echo "Generando mapas de usuarios individuales..."
## CIUDAD: ElPaso
    # Usuario: 4688
    python3 $path_individual_map --user_id "4688" --input_file "${PATH_GOWALLA_FILES}ElPasoGowalla.txt" --city_name ElPaso --output_html "${PATH_OUTPUT_GOWALLA_FILES}ElPasoGowallaMap_individual.html"

## CIUDAD: Glasgow
    # Usuario: 1519
    python3 $path_individual_map --user_id "1519" --input_file "${PATH_GOWALLA_FILES}GlasgowGowalla.txt" --city_name Glasgow --output_html "${PATH_OUTPUT_GOWALLA_FILES}GlasgowGowallaMap_individual.html"

## CIUDAD: Manchester
    # Usuario: 59977
    python3 $path_individual_map --user_id "59977" --input_file "${PATH_GOWALLA_FILES}ManchesterGowalla.txt" --city_name Manchester --output_html "${PATH_OUTPUT_GOWALLA_FILES}ManchesterGowallaMap_individual.html"

## CIUDAD: WashingtonDC
    # Usuario: 302
    python3 $path_individual_map --user_id "302" --input_file "${PATH_GOWALLA_FILES}WashingtonDCGowalla.txt" --city_name WashingtonDC --output_html "${PATH_OUTPUT_GOWALLA_FILES}WashingtonGowallaMap_individual.html"


## Tops
echo "Calculando los ficheros de los top 5 y creando mapas..."
for ciudad in $ciudades; do

    fichero_filtered="filtered_text/${ciudad}GowallaFiltered.txt"
    fichero_tops="filtered_text/${ciudad}Gowalla_top5.txt"

    python3 topn_selection_Veronica_Maite.py --input_file $fichero_filtered --top 5 --output_file $fichero_tops

    
    while read -r linea
    do
        python3 $path_individual_map --user_id ${linea} --input_file "${PATH_GOWALLA_FILES}${ciudad}Gowalla.txt" --city_name $ciudad --output_html "${PATH_OUTPUT_GOWALLA_FILES}${ciudad}_${linea}Map.html"
    done < "$fichero_tops"
done

echo "Inicializamos para poder acceder a la ruta Flask..."
python3 ProyectoFUSO/main.py

# Desactivamos el entorno virtual:
deactivate