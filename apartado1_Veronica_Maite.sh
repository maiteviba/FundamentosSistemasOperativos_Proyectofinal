#!/bin/ash

packages="python3 python3-dev git nano bash gcc g++ musl-dev linux-headers wget curl htop"

for package in $packages
do
    if ! apk list --installed | grep -q $package; then #Otra opción es "^$package" para qeu coincida exactamente todo el nombre del paquete, significa que comience exactamente así.
        apk add $package
    else
        echo "El paquete $package ya existe, por lo tanto no se instala"
    fi
done

if ! apk list --installed | grep -q sudo; then
    # En caso de que no esté descargada la libreria sudo, hemos de 
    # corregir primero el fichero /etc/apk/repositories, descomentando la línea que contiene community

    # Aprovechamos que ya tenemos la libreria nano descargada para leer el fichero y editarlo
    sed -i "s/^#\(.*community.*\)/\1/"  # -i flag para que el archivo se edite in place
                                                             # ^#\(.*community.*\) regex que significa: línea que empiece en # y a continuación entre paréntesis
                                                             # escapados, el grupo de lo que sea + community + lo que sea, y lo sustituimos por \1 que es el grupo uno -->
                                                             # es decir, lo que se enceuntra entre los paréntesis escapados. En el fichero /etc/apk/repositories
    #apk update # Actualizamos la lista de community
    apk add sudo
else
    echo "El paquete sudo ya existe, por lo tanto no se instala"
fi

apk add libc-dev