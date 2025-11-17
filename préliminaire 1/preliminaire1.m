clc
clear
close all

%% POINT 1

N = 100;

sigma = 10;
bbgc = sigma * randn(1, N);

[cor_biased, lags_biased] = xcorr(bbgc, 'biased');
[cor_unbiased, lags_unbiased] = xcorr(bbgc, 'unbiased');

cor_theo = zeros(1, length(cor_biased));
cor_theo(round(length(cor_biased)/2)) = sigma^2;

figure;
hold on
plot(lags_biased, cor_theo, '--');
plot(lags_biased, cor_biased);
plot(lags_unbiased, cor_unbiased);
legend('autocorrélation théorique', 'estimateur biaisé', 'estimateur non biaisé');
hold off

Sx = fftshift(fft(cor_theo));
N_Sx = length(Sx);
f = -1/2:1/N_Sx:1/2-1/N_Sx;

periodogramme = abs(fftshift(fft(bbgc))).^2/N;
f_perio = -0.5:1/N:0.5-1/N;

figure;
hold on
plot(f, abs(Sx));
plot(f_perio, periodogramme);
legend('DSP', 'Spectre de puissance')
hold off

%% POINT 2

% Daniell
M = 11;
daniell = conv(periodogramme, ones(1,M)/M, 'same');

% Bartlett
K = 5;
L = N/K;
perio = [];
for i=1:K
    perio(i,:) = abs(fftshift(fft(bbgc(1+L*(i-1) : L*i)))).^2/L;
end
bartlett = mean(perio, 1);
f_bartlett = -0.5 : 1/L : 0.5 - 1/L;

% Welch
overlap = 0.5;
K = 4;
L = floor(N/(1+(K-1)*(1-overlap)));
w = hann(L);
U = sum(w.^2)/L;
perio = [];
for i=1:K
    s = 1 + (i-1)*floor(L*(1-overlap));
    e = s + L - 1;
    x = bbgc(s : e).*w';
    perio(i,:) = abs(fftshift(fft(x))).^2/(L*U);
end
welch = mean(perio, 1);
f_welch = -0.5 : 1/L : 0.5 - 1/L;

% Corrélogramme
correlogramme = real(fftshift(fft(cor_biased)));

figure;
hold on
plot(f_perio, periodogramme)
plot(f_perio, daniell);
plot(f_bartlett, bartlett);
plot(f_welch, welch);
plot(f, correlogramme);
legend('Periodogramme', 'Daniel', 'Bartlett', 'Welch', 'Corrélogramme');
hold off