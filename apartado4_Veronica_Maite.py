import requests
import os
import socket


IP = "10.120.158.20"
PUERTO = "5000"

URL_TRAIN = f"http://{IP}:{PUERTO}/train"
URL_STATIC = f"http://{IP}:{PUERTO}/static/"

#carpeta de salida para guardar imagenes descargadas
salida = "imagenes_descargadas"
os.makedirs(salida, exist_ok=True)

#bucle de peticiones
for i in range(1, 10):
    train_size = i/10
    test_size = 1 - train_size

    data = {"dataset": "iris", "model": "RandomForest", "train_size": train_size, "test_size": test_size}
    print(f"\nEnviando petición con train={train_size} y test={test_size}")

    #petición POST 
    response = requests.post(URL_TRAIN, data=data)

    #contenido: response.content
    
    if response.status_code != 200:   #indicamos que ha habido un error 
        print(f"ERROR en petición en POST ({response.status_code})...")

    #nombre de la imagen generada
    result_name = f"irisTr{train_size}Tst{test_size}.png"

    url_imagen = URL_STATIC + result_name
    print(f"Descargando imagen: {url_imagen}")


    #petición GET para descargar la imagen
    img_response = requests.get(url_imagen)

    #contenido: img_response.content

    if img_response.status_code != 200:
        print(f"ERROR al descargar la imagen ({img_response.status_code})")

    #guardar imagen localmente
    ruta_local = os.path.join(salida, result_name)

    with open(ruta_local, "wb") as f:
        f.write(img_response.content)
    
    print(f"Imagen guardada: {ruta_local}")

print("\nProceso completado. Todas las imágenes han sido descargadas")

