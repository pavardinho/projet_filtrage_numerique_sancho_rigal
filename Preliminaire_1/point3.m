clc
clear
close all

%% POINT 3

M = 1000; % nombre de réalisations

N = 100;
sigma = 10;

platitude = zeros(1, M);

for m = 1:M
    bbgc = sigma * randn(1, N);

    % % Periodogramme
    % len = N;
    % spectre_puissance = abs(fftshift(fft(bbgc))).^2/N;

    % Welch
    overlap = 0.5;
    K = 4;
    L = floor(N/(1+(K-1)*(1-overlap)));
    len = L;
    w = hann(L);
    U = sum(w.^2)/L;
    perio = [];
    for i=1:K
        s = 1 + (i-1)*floor(L*(1-overlap));
        e = s + L - 1;
        x = bbgc(s : e).*w';
        perio(i,:) = abs(fftshift(fft(x))).^2/(L*U);
    end
    spectre_puissance = mean(perio, 1);

    % DSP
    % len = N;
    % cor_theo = zeros(1, N);
    % cor_theo(round(length(N)/2)) = sigma^2;
    % spectre_puissance = abs(fftshift(fft(cor_theo)));

    moy_arith = mean(spectre_puissance);
    moy_geo = prod(spectre_puissance)^(1/len);

    platitude(m) = moy_geo / moy_arith;
end

platitude_moyenne = mean(platitude);
platitude_ecart_type = std(platitude);


fprintf('Platitude moyenne : %.4f\n', platitude_moyenne);
fprintf('Ecart type de la platitude : %.4f\n', platitude_ecart_type);
