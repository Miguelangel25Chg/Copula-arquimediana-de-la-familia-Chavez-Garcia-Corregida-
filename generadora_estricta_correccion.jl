using Plots

# 1. Generador Estricto Chávez 
# phi(t) = exp((1-t)/sqrt(t)) - 1
phi_chavez(t) = t <= 0.0 ? 1e15 : exp((1 - t) / sqrt(t)) - 1 [cite: 9, 10, 23, 29]

# 2. Inversa Analítica Chávez (Página 3 de tu PDF)
# Derivada de la ecuación cuadrática t^2 - (2 + ln^2(z+1))t + 1 = 0
function inv_phi_chavez(z)
    if z <= 0.0 return 1.0 end
    
    L = log(z + 1)^2
    termino_b = 2 + L
    
    # Usamos la raíz con signo negativo para que el resultado t esté en (0,1)
    # t = ( -b - sqrt(b^2 - 4ac) ) / 2a
    t = (termino_b - sqrt(termino_b^2 - 4)) / 2 [cite: 48, 51, 52, 57, 58]
    return t
end

# 3. Construcción de la Cópula C(u,v) = phi_inv( phi(u) + phi(v) )
C_chavez(u, v) = inv_phi_chavez(phi_chavez(u) + phi_chavez(v)) [cite: 3, 53, 55]

# 4. Mallado para graficación
u = v = range(0.01, 0.99, length=100)
z_vals = [C_chavez(ui, vi) for ui in u, vi in v]

# 5. Generación de los visuales para Arturo
# Aquí se verá la convexidad
p1 = contour(u, v, z_vals, 
    levels=15, 
    title="Curvas de Nivel: Familia Chávez (Estricta)", 
    fill=true, 
    color=:viridis, 
    xlabel="u", ylabel="v",
    aspect_ratio=:equal)

p2 = surface(u, v, z_vals, 
    title="Superficie Convexa C(u,v)", 
    camera=(35, 45), 
    color=:viridis,
    xlabel="u", ylabel="v", zlabel="C(u,v)")

plot(p1, p2, layout=(1,2), size=(1000, 450))