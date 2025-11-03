%% Préliminaire 2
clc
clear
close all

% Récupération d'un signal
data = load('./Signaux_parole/fcno01fz.mat');
signal = data.fcno01fz;

% Paramètes
RSB_dB = 10;
Fs = 8000;

% Bruitage du signal
signal_bruite = bruitage(signal, RSB_dB);

% Affichage des signaux
N = length(signal);
t = (0 : N-1) / Fs;

% Signal de base
figure(1);
% Représentation temporelle
subplot(2, 1, 1); 
plot(t, signal); 
title('Signal de Parole Original - Temporel');
xlabel('Temps (s)');
ylabel('Amplitude');
% Spectrogramme
subplot(2, 1, 2);
spectrogram(signal, 256, 128, 256, Fs, 'yaxis');
title('Signal de Parole Original - Spectrogramme');

% Signal bruité
figure(2); 
% Représentation temporelle
subplot(2, 1, 1);
plot(t, signal_bruite);
title(['Signal Bruité (RSB = ', num2str(RSB_dB), ' dB) - Temporel']);
xlabel('Temps (s)');
ylabel('Amplitude');
% Spectrogramme
subplot(2, 1, 2);
spectrogram(signal_bruite, 256, 128, 256, Fs, 'yaxis'); % <-- Et ici
title(['Signal Bruité (RSB = ', num2str(RSB_dB), ' dB) - Spectrogramme']);

