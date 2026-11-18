% =====================================================================
% SIMULACIÓN: SEÑAL WIFI EN UNA ZONA DE ESTUDIO CIRCULAR
% =====================================================================
% Problema: un router está en el centro de una zona circular de radio
% 10 m. La intensidad de la señal a una distancia r del router es
%       S(r) = 30 - 3r
% Se piden tres cosas:
%   Problema 1: la señal total acumulada en la zona.
%   Problema 2: la intensidad promedio de la zona.
%   Problema 3: la señal acumulada en los primeros 5 m y su porcentaje.
%
% El script resuelve los tres problemas con la integral doble en
% polares y comprueba los resultados con dos simulaciones:
%   - Suma de trocitos de la zona.
%   - Monte Carlo (puntos al azar dentro de la zona).
% Al final muestra una gráfica por cada problema.
% No requiere toolboxes adicionales.
% =====================================================================

clc; clear; close all;
rng(1);                       % semilla fija para que los resultados se repitan

%% DATOS DEL PROBLEMA
S    = @(r) 30 - 3*r;         % intensidad de la señal a distancia r
R    = 10;                    % radio de toda la zona (m)
R5   = 5;                     % radio de la zona cercana (m)
area = pi * R^2;              % área de la zona completa (m^2)

%% SOLUCIÓN EXACTA (integral doble en polares)
% El área de un trocito en polares es r*dr*dtheta, por eso se integra S(r)*r.
% integral2 recibe la función como f(theta, r), en ese orden.
f = @(theta, r) S(r) .* r;

total      = integral2(f, 0, 2*pi, 0, R);    % Problema 1: señal total
promedio   = total / area;                   % Problema 2: total entre el área
total5     = integral2(f, 0, 2*pi, 0, R5);   % Problema 3: señal en los primeros 5 m
porc_senal = total5 / total * 100;           % porcentaje de la señal total
porc_area  = (R5 / R)^2 * 100;               % porcentaje del área total

%% SIMULACIÓN 1: SUMA DE TROCITOS
% Se divide la zona en trocitos de rosca; cada uno aporta señal x área.
% Se suman todos (problema 1) y solo los que están dentro de 5 m (problema 3).
nr = 64;  nt = 256;           % divisiones en r y en theta
dr = R / nr;  dt = 2*pi / nt;
suma_total = 0;  suma_5 = 0;
for i = 1:nr
    rc = (i - 0.5) * dr;                  % distancia al centro del trocito
    for j = 1:nt
        aporte = S(rc) * rc * dr * dt;    % señal x área del trocito
        suma_total = suma_total + aporte;
        if rc < R5
            suma_5 = suma_5 + aporte;
        end
    end
end

%% SIMULACIÓN 2: MONTE CARLO
% Se lanzan N puntos al azar dentro del círculo (como personas repartidas
% por la zona) y se mide la señal en cada uno.
% Se usa r = R*sqrt(rand) para que los puntos queden parejos en el área.
N  = 200000;
rp = R * sqrt(rand(N, 1));
mc_promedio = mean(S(rp));                           % promedio de la señal
mc_total    = mc_promedio * area;                    % total = promedio x área
mc_total5   = mean(S(rp) .* (rp < R5)) * area;       % solo puntos a menos de 5 m

%% RESULTADOS EN PANTALLA
fprintf('                       Exacto     Trocitos   Monte Carlo\n');
fprintf('1) Señal total:        %8.1f   %8.1f   %8.1f\n', total, suma_total, mc_total);
fprintf('2) Promedio:           %8.2f   %8.2f   %8.2f\n', promedio, suma_total/area, mc_promedio);
fprintf('3) Señal en 5 m:       %8.1f   %8.1f   %8.1f\n', total5, suma_5, mc_total5);
fprintf('   Porcentaje:         %7.1f%%   %7.1f%%   %7.1f%%\n', porc_senal, suma_5/suma_total*100, mc_total5/mc_total*100);

%% GRÁFICAS: UN CÍRCULO POR CADA PROBLEMA
% Cada círculo es la zona de estudio vista desde arriba, con el router al centro.
% Colores: rojo = señal fuerte, azul = señal débil.
figure('Color','w','Position',[50 100 1350 480]);
th = linspace(0, 2*pi, 300);
[Rg, Tg] = meshgrid(linspace(0, R, 80), linspace(0, 2*pi, 200));
Xg = Rg .* cos(Tg);
Yg = Rg .* sin(Tg);

% ---- Problema 1: señal total de toda la zona ----
subplot(1,3,1);
pcolor(Xg, Yg, S(Rg)); shading interp; hold on;
colormap(jet); caxis([0 30]);
cb = colorbar; cb.Label.String = 'Intensidad de la señal';
plot(R*cos(th), R*sin(th), 'k--', 'LineWidth', 2);          % límite de la zona
plot([0 R], [0 0], 'k', 'LineWidth', 2.5);                  % radio
text(R/2, 1.1, 'Radio = 10 m', 'HorizontalAlignment', 'center', ...
    'FontWeight', 'bold', 'BackgroundColor', 'w');
plot(0, 0, 'k^', 'MarkerSize', 10, 'MarkerFaceColor', 'w'); % router
text(0, -3, sprintf('Señal total\n%.1f', total), 'HorizontalAlignment', 'center', ...
    'FontSize', 15, 'FontWeight', 'bold', 'BackgroundColor', 'w');
axis equal; axis([-11 11 -11 11]); axis off;
title(sprintf('Problema 1: señal total\n(toda la zona de 10 m)'), 'FontSize', 13);

% ---- Problema 2: intensidad promedio ----
% El círculo punteado marca la distancia donde la señal vale justo el promedio:
% adentro la señal es mayor al promedio y afuera es menor.
subplot(1,3,2);
pcolor(Xg, Yg, S(Rg)); shading interp; hold on;
colormap(jet); caxis([0 30]);
cb = colorbar; cb.Label.String = 'Intensidad de la señal';
r_prom = (30 - promedio) / 3;                                % donde S(r) = promedio
plot(R*cos(th), R*sin(th), 'k--', 'LineWidth', 2);
plot(r_prom*cos(th), r_prom*sin(th), 'w', 'LineWidth', 3.5);
plot(0, 0, 'k^', 'MarkerSize', 10, 'MarkerFaceColor', 'w');
text(0, -2.5, sprintf('Promedio\n%.0f', promedio), 'HorizontalAlignment', 'center', ...
    'FontSize', 15, 'FontWeight', 'bold', 'BackgroundColor', 'w');
text(0, r_prom + 1.2, sprintf('Aquí la señal vale %.0f (r = %.1f m)', promedio, r_prom), ...
    'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'BackgroundColor', 'w');
axis equal; axis([-11 11 -11 11]); axis off;
title(sprintf('Problema 2: intensidad promedio\n(nivel típico de la zona)'), 'FontSize', 13);

% ---- Problema 3: primeros 5 m ----
subplot(1,3,3);
fill(R*cos(th),  R*sin(th),  [0.75 0.75 0.75], 'EdgeColor', 'k', 'LineStyle', '--', 'LineWidth', 2); hold on;
fill(R5*cos(th), R5*sin(th), [0.85 0.2 0.2],   'EdgeColor', 'k', 'LineWidth', 2);
plot(0, 0, 'k^', 'MarkerSize', 10, 'MarkerFaceColor', 'w');
text(0, -1.2, sprintf('Primeros 5 m\n%.1f\n(%.0f %% de la señal)', total5, porc_senal), ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'Color', 'w', ...
    'FontSize', 13, 'FontWeight', 'bold');
text(0, -7.5, sprintf('De 5 a 10 m\n%.1f\n(%.0f %% de la señal)', total - total5, 100 - porc_senal), ...
    'HorizontalAlignment', 'center', 'FontSize', 13, 'FontWeight', 'bold');
axis equal; axis([-11 11 -11 11]); axis off;
title(sprintf('Problema 3: primeros 5 m\n(%.0f %% del terreno, %.0f %% de la señal)', porc_area, porc_senal), 'FontSize', 13);