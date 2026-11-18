Cobertura WiFi en una zona de estudio

Proyecto de integrales dobles en coordenadas polares.  
Materia: Calculo III.  
Profesor: Olguin Roque Jairo  

Integrantes:  
Rodriguez Valdovinos Aurora  
Rosas Vazquez Eduardo  
Ruiz Estrada Josselyn Judith  
Servin Rivera Derek  
Sierra Soto Carla  
Solis Garcia Wendy  
Tahuilan Gonzalez Daniel Alejandro  

Problema:  
Una universidad quiere instalar una zona de estudio al aire libre con un solo router en el centro y necesita saber qué tan buena es la señal dentro de un radio de 10 m. Suponemos un espacio abierto, sin obstáculos, donde la intensidad solo depende de la distancia r al router: S(r) = 30 - 3r. Se calcula la señal total de la zona, la intensidad promedio y cuánta señal se concentra en los primeros 5 m.

Solución:  
Como la zona es circular, se usan coordenadas polares (r de 0 a 10, θ de 0 a 2π) y la integral doble queda:
Total = ∫ (θ: 0 a 2π) ∫ (r: 0 a 10) (30 - 3r) · r dr dθ = 1000π ≈ 3141.6
La intensidad promedio es el total entre el área del círculo: 1000π / 100π = 10. En los primeros 5 m se acumulan 500π ≈ 1570.8, es decir, el 50 % de la señal en solo el 25 % del área.

Material:  
Video de la animación: https://youtu.be/_8aghe7iYdg
Presentación en Canva: https://canva.link/2z3qv3qhevu738v

Código de MATLAB: en este repositorio. Para ver los resultados basta con abrirlo en MATLAB (o MATLAB Online) y ejecutarlo.
