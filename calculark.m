clc;
close all;
clear;


% Datos
s_11 = 0.8734* exp(1i * 142.5*pi / 180);
s_21 = 1.097 * exp(1i * 45.4*pi / 180);
s_12 = 0.0961 * exp(1i * 47*pi / 180);
s_22 = 0.701 * exp(1i * 145.3*pi / 180);

Zo = 50;      % Impedancia característica
fp = 2.4e9;   % Frecuencia de operación 

er = 4.4;                 % Constante dieléctrica 
h = 1.546e-3;             % Altura del sustrato (m)
t = 29.5e-6;              % Espesor del cobre (m) 


% Cálculos iniciales
delta = s_11*s_22 - s_12*s_21;
k = (1 + abs(delta)^2 - abs(s_22)^2 - abs(s_11)^2) / (2 * abs(s_12*s_21));

C1 = s_11 - delta * conj(s_22);
B1 = 1 + abs(s_11)^2 - abs(s_22)^2 - abs(delta)^2;
C2 = s_22 - delta * conj(s_11);
B2 = 1 + abs(s_22)^2 - abs(s_11)^2 - abs(delta)^2;

% Cálculo de sigma_in y sigma_out 
gamma_in = (B1 - sqrt(B1^2 - 4*abs(C1)^2)) / (2 * abs(C1));
gamma_in_rect = gamma_in * cos(angle(C1)) + gamma_in * sin(angle(C1)) * 1i;

gamma_out = (B2 - sqrt(B2^2 - 4*abs(C2)^2)) / (2 * abs(C2));
gamma_out_rect = gamma_out * cos(angle(C2)) + gamma_out * sin(angle(C2)) * 1i;

% Cálculo de Z_in y Z_out en serie
Zin = Zo * ( (1 + gamma_in_rect) / (1 - gamma_in_rect) );
Zout = Zo * ( (1 + gamma_out_rect) / (1 - gamma_out_rect) );

Rin_serie = real(Zin);
Xin_serie = imag(Zin);

Rout_serie = real(Zout);
Xout_serie = imag(Zout);


%Cálculo de la Máxima Ganancia Disponible (MAG)
MAG_dB = 10 * log10((abs(s_21)/abs(s_12)) * (k - sqrt(k^2 - 1)));

% Paso de Z_in de serie a paralelo
Rin_paralelo = Rin_serie * (1 + (Xin_serie / Rin_serie)^2);
Xin_paralelo = Xin_serie * (1 + (Rin_serie / Xin_serie)^2);

% Cálculo de C_in (entrada)
Cin = 1 / (2 * pi * fp * Xin_paralelo);
Zo_in = sqrt(Rin_paralelo*Zo);

% Cálculos de salida
Zo_out = sqrt(Zo * Rout_serie);
Xout_paralelo = abs(Zo_out^2 / Xout_serie);  %revisar si va este valor absoluto

% Cálculo de C_out (salida)
Cout = 1 / (2 * pi * fp * Xout_paralelo);
disp(['Zin = ', num2str(Zin)]);
disp(['Zout = ', num2str(Zout)]);
fprintf('MAG = %.2f dB\n', MAG_dB);
fprintf('Rin (paralelo) = %.2f Ohms\n', Rin_paralelo);
fprintf('Xin (paralelo) = %.2f Ohms\n', Xin_paralelo);
fprintf('Cin = %.2e F\n', Cin);
fprintf('Zo_out = %.2f Ohms\n', Zo_out);
fprintf('Xout (paralelo) = %.2f Ohms\n', Xout_paralelo);
fprintf('Cout = %.2e F\n', Cout);


%% microtira de adaptador de lambda/4 

fprintf('------------------------------------------\n');
fprintf('Adaptador de entrada');

calcularMicrotiraLambda4(Zo_in, er, h, t, fp)


fprintf('------------------------------------------\n');
fprintf('Adaptador de salida');

calcularMicrotiraLambda4(Zo_out, er, h, t, fp)


%% microtira capacitores

fprintf('----------------------------------------------\n');
fprintf('Capacitor de entrada');

calcularMicrotiraCap(Zo, er, h, t, fp, Cin)


fprintf('----------------------------------------------\n');
fprintf('Capacitor de salida');

calcularMicrotiraCap(60, er, h, t, fp, Cout)




























