import sys 
import os


def calculate_statistics(path_to_file:str):
    """
    Funcion que hace todos los calculos pedidos:
        -Numero de usuarios distintos
        -Numero de localizaciones distintos
        -Numero de filas completas
        -Numero de check-ins en 2010-07
        -Numero de check-ins en 2010-08
    Args:
        path_to_file(str): ruta para leer el fichero
    Returns:
        None
    """ 

    # Comprobamos que existe el fichero
    if not os.path.exists(path_to_file):
        print(f"El fichero {path_to_file} no existe")
        sys.exit(1)

    users=[]
    places=[]
    number_rows=0
    number_201007=0
    number_201008=0

    # Abrimos el fichero y lo leemos para hacer los caculos.
    with open(path_to_file, "r") as f:
        
        lines = f.readlines()
        for line in lines:
            number_rows+=1
            # Separamos las columnas por cada fila:
            columns = line.strip().split("\t")
            user_id, check_in, place_id = columns

            if user_id not in users:
                users.append(user_id)
            if place_id not in places:
                places.append(place_id)
            if "2010-07" in check_in:
                number_201007+=1
            if "2010-08" in check_in:
                number_201008+=1
    
    print("Estadisticas del script de python para comparar...")
    print(f"Numero de usuarios distintos: {len(users)}")
    print(f"Numero de localizaciones distintos: {len(places)}")
    print(f"Numero de filas completas: {number_rows}")
    print(f"Numero de check-ins en 2010-07: {number_201007}")
    print(f"Numero de check-ins en 2010-08: {number_201008}") 

def main():
    
    # Comprobamos que la cantidad de argumentos enviados es el correcto:
    args= sys.argv
    if len(args) != 2:
        print(f"Funcion mal llamada, vuelvalo a intentar")
        sys.exit(1)
    
    calculate_statistics(args[1]) # Mandamos a calcular las estadi­sticas:

if __name__=="__main__":

    main()