import pandas as pd
import argparse

def create_top_file(filtered_file_path:str, num_top_users:int, output_file_path:str):
    """
    Funcion que coge un fichero inicial y un numero (n) y selecciona el 
    top de n personas con mas interacciones del fichero
    Args:
	filtered_path_file(str): ruta hacia el fichero filtrado
    	num_top_users(int): numero de usuarios que quiero filtrar
    """

    # Creo un df para poder manejar de manera mas facil los datos.
    # Dado que el fichero no tiene cabecera, utilizamos los argumentos de header y names para crearla manualmente.
    df = pd.read_csv(filtered_file_path, 
                        sep="\t", 
                        header=None, 
                        names=["user_id", "check_in", "place_id"])

    # Guardo una lista de los n usuarios con mas apariencias
    top_n_selection=df["user_id"].value_counts().head(num_top_users).index

    # Escribimos en el fichero el nombre de los usuarios:
    with open(output_file_path, "a") as f:
        for user in top_n_selection:
            f.write(f"{user}\n")


def main():
    parser=argparse.ArgumentParser(description="Selects the top n visitor in a city")

    # E.g. ElPasoGowallaFiltered.txt
    parser.add_argument("--input_file", required=True, type=str, help="Path to the input check-ins file.")

    # 5
    parser.add_argument("--top", required=True, type=int, help="Number to select the top users with more interactions")

    # Output
    parser.add_argument("--output_file", required=True, type=str, help="Path to save the output HTML file.")

    args=parser.parse_args()
    create_top_file(args.input_file, args.top, args.output_file)

if __name__=="__main__":

    main()