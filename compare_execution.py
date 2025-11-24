import time
import numpy as np
from multiprocessing import Process
from typing import Tuple


def multiplica_matrices(A: np.ndarray, B: np.ndarray) -> np.ndarray:
    '''
    multiplica dos matrices A y B utilizando una versión optimizada del algoritmo de multiplicación de matrices

    Args:
        A (np.ndarray): matriz de dimensiones m x n
        B (np.ndarray): matriz de dimensiones n x p

    Returns:
        C (np.ndarray): matriz resultante de la multiplicación de A y B de dimensiones m x p
    '''
    m = A.shape[0]    # número de filas de A
    p = B.shape[1]    # número de columnas de B
    n = A.shape[1]    # número de columnas de A (igual a filas de B)
    
    C = np.zeros((m, p))     #creo matriz de ceros de dimensiones mxp
    
    for i in range(m):
        ci = C[i]
        for k in range(n):
            bk = B[k]
            aik = A[i,k]
            for j in range(p):
                ci[j] += aik*bk[j]
    return C


def genera_matriz_aleatoria(filas:int, columnas:int) ->np.ndarray:
    '''
    genera matriz aleatorio de dimensiones filas x columnas con valores entre 0 y 1
    '''
    return np.random.random((filas, columnas))

def tarea(lista_tamanos):
    for n in lista_tamanos:
        A = genera_matriz_aleatoria(n, n)
        B = genera_matriz_aleatoria(n, n)
        C = multiplica_matrices(A, B)


def compare_execution()->Tuple[float, float]:
    """
    Compare execution time of sequential vs parallel processing for training models on a synthetic dataset.
    Returns:
        Tuple[float, float]: A tuple containing the execution times for sequential and parallel processing.
    """
    sequential_time =0
    parallel_time =0
    matrix_sizes =[310, 210, 400, 160]

    ##CODE FOR STUDENTS

    #Secuencial: un solo bucle multiplica todas las matrices, sin distribuir la tarea
    t0 = time.time()

    for n in matrix_sizes:
        A = genera_matriz_aleatoria(n, n)
        B = genera_matriz_aleatoria(n, n)
        C = multiplica_matrices(A, B)

    sequential_time += time.time() - t0

    #Paralelo: un proceso multiplica la matriz grande y otro proceso multiplica las pequeñas, para maximiza rl speedup
    t0 = time.time()

    p1 = Process(target=tarea, args=([400],))
    p2 = Process(target=tarea, args=([310, 210, 160],))

    p1.start()
    p2.start()
    p1.join()
    p2.join()

    parallel_time += time.time() - t0

    ##END CODE FOR STUDENTS

    return sequential_time, parallel_time

