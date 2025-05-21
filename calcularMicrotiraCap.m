function calcularMicrotiraCap(Z, er, h, t, fp, C)


    % Cálculo de A(Zin) y B(Zin)
    A = (Z / 60) * sqrt((er+1)/2) + ((er-1)/(er+1)) * (0.23 + 0.11/er);
    B = (377*pi) / (2*Z*sqrt(er));

    % Cálculo de W/H
    W_H = (2/pi) * ( (B - 1) - log(2*B - 1) + ( (er-1)/(2*er) ) * ( log(B-1) + 0.39 - 0.61/er ) );

    % Ancho W
    W = h * W_H;

    % Corrección de ancho efectivo 
    We = W + (t/pi)*(1 + log(2*h/t));

    % Cálculo de epsilon efectivo
    er_eff = (er + 1)/2 + (er - 1)/2 * (1 / sqrt(1 + 12*h/We));

    % Impedancia característica corregida
    Zo_e = (120*pi) / (sqrt(er_eff) * (W/h + 1.393 + 0.667*log(W/h + 1.444)));

    % Longitud de onda en el sustrato
    lambda = 300 / (fp * 1e-6);  % Convertimos fp a MHz
    lambda_p = lambda / sqrt(er_eff);

    % Calculo de beta
    beta = (2*pi) / lambda_p;

    % Cálculo de reactancia capacitiva
    Xc = 1 / (2*pi*fp*C); 

    % Cálculo del largo eléctrico para el capacitor
    d = atan(Zo_e/Xc) / beta;  

    % Ángulo eléctrico
    angulo_electrico = beta * d * (180/pi);  

    % Mostrar resultados
    fprintf('\nResultados del diseño de microtira capacitiva:\n');
    fprintf('----------------------------------------------\n');
    fprintf('A(Zin) = %.4f\n', A);
    fprintf('B(Zin) = %.4f\n', B);
    fprintf('Ancho W = %.4f mm\n', W*1e3);
    fprintf('Ancho efectivo We = %.4f mm\n', We*1e3);
    fprintf('Epsilon efectivo = %.4f\n', er_eff);
    fprintf('Impedancia corregida Zo_e = %.2f Ohms\n', Zo_e);
    fprintf('Longitud de microtira (capacitor) = %.4f mm\n', d*1e3);
    fprintf('Ángulo eléctrico = %.2f grados\n', angulo_electrico);
end
