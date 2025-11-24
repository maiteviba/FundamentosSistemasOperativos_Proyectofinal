#!/bin/ash

repositorio_url_por_defecto="https://github.com/pablosanchezp/ProyectoFUSO.git"
repositorio_url="${1:-$repositorio_url_por_defecto}"

dir_por_defecto="$HOME"
dir="${2:-$dir_por_defecto}"

nombre_proyecto="ProyectoFUSO"
path_proyecto="${dir}/${nombre_proyecto}"

#comprobar que se ejecuta como root
if [ "$(id -u)" -eq 0 ]; then
    echo "ERROR: Este script no debe ejecutarse como root, usa el usuario alumnoimat."
    exit 1
fi

echo "Usando directorio de instalación: ${dir}"
mkdir -p "$dir" 
cd "$dir" || exit 1   #me situo en el directorio


# si ya existe el repositorio, lo borramos para empezar limpio
if [ -d "$path_proyecto" ]; then
    echo "Eliminando repositorio previo..."
    rm -rf "$path_proyecto"
fi

#git clone de ese repositorio
echo "Clonando repositorio desde $repositorio_url..."
git clone "$repositorio_url"

#entramos en el repositorio
#cd "$path_proyecto" || exit 1

# comprobamos que está requirements
if [ ! -f "requirements.txt" ]; then
    echo "ERROR: No se ha encontrado requirements.txt en el proyecto"
    exit 1
fi


#si ya existe venv, lo eliminamos
if [ -d "venv" ]; then
    echo "Existe un entorno virtual previo. Lo eliminamos..."
    rm -rf venv
fi


#crear entorno virtual 
echo "Creando entorno virtual de Python en $(pwd)/venv..."
python3 -m venv venv

#activar entorno e instalar paquetes de requirements.txt  (pip install requirements)
echo "Activando entorno virtual..."
source venv/bin/activate

echo "Instalando paquetes de requirements.txt..."
pip install --upgrade pip
pip install -r requirements.txt


#ejecutar main.py (python3 ProyectoFUSO/main.py)
echo "Ejecutando main.py..."
if [ ! -f "ProyectoFUSO/main.py" ]; then
    echo "ERROR: No se encontró main.py en $(pwd)."
    exit 1
fi


python3 ProyectoFUSO/main.py 

echo "Aplicación Flask lanzada correctamente."
echo "Puedes acceder desde tu navegador a http://10.122.144.87:5000/"


















