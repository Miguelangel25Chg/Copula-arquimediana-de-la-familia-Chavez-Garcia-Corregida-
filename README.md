# Cópula Arquimediana de la Familia Chávez-García (Versión Estricta)

Este repositorio presenta el desarrollo de una nueva familia de cópulas basada en el **Generador Estricto Chávez**.

## 1. Fundamentación Matemática
[cite_start]De acuerdo con la propuesta técnica original, se define el generador mediante una estructura exponencial-radical que asegura la convexidad y el comportamiento estricto[cite: 9]:

### Generador Estricto
$$\varphi(t) = \exp\left( \frac{1-t}{\sqrt{t}} \right) - 1$$

* [cite_start]**Comportamiento en el límite:** $\lim_{t \to 0} \varphi(t) = +\infty$[cite: 11, 29].
* [cite_start]**Dominio:** $t \in (0,1]$[cite: 26, 32].
* [cite_start]**Monotonía:** Se demuestra que $\dot{\varphi}(t) < 0$, asegurando que es estrictamente decreciente[cite: 36, 38].

### Inversa Analítica
[cite_start]Resolviendo la ecuación cuadrática $t^{2} - (2 + \ln^{2}(z+1))t + 1 = 0$ [cite: 48][cite_start], obtenemos la inversa exacta utilizada para la construcción de la cópula[cite: 52]:

$$\varphi^{-1}(z) = \frac{2 + \ln^{2}(z+1) - \sqrt{(2 + \ln^{2}(z+1))^{2} - 4}}{2}$$

## 2. Implementación en Julia
El siguiente código genera la superficie de la cópula y sus curvas de nivel.

```julia
using Plots

# Generador Estricto Chávez (Pág. 1 del Manuscrito)
phi_chavez(t) = t <= 0.0 ? 1e15 : exp((1 - t) / sqrt(t)) - 1

# Inversa Analítica (Pág. 3 del Manuscrito)
function inv_phi_chavez(z)
    if z <= 0.0 return 1.0 end
    L = log(z + 1)^2
    b = 2 + L
    # Solución de la ecuación cuadrática t^2 - (2+L)t + 1 = 0
    return (b - sqrt(b^2 - 4)) / 2
end

# Construcción de la Cópula C(u,v)
C_chavez(u, v) = inv_phi_chavez(phi_chavez(u) + phi_chavez(v))

# Visualización
u = v = range(0.01, 0.99, length=100)
z_vals = [C_chavez(ui, vi) for ui in u, vi in v]

p1 = contour(u, v, z_vals, levels=15, title="Curvas de Nivel Convexas", fill=true, color=:viridis)
p2 = surface(u, v, z_vals, title="Superficie Cópula Chávez", camera=(35, 45), color=:viridis)
plot(p1, p2, layout=(1,2), size=(1000, 450))(1000, 450))
