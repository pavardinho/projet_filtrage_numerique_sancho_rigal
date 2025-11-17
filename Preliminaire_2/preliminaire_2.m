%% Préliminaire 2
clc
clear
close all

% Récupération d'un signal
data = load('../Signaux_parole/fcno03fz.mat');
signal = data.fcno03fz;

% Paramètes
RSB_dB = 25;
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
title('Signal de Parole');
xlabel('Temps (s)');
ylabel('Amplitude');
xlim([t(1),t(end)]);
% Spectrogramme
subplot(2, 1, 2);
spectrogram(signal, 256, 128, 256, Fs, 'yaxis');
title('Spectrogramme');

% Signal bruité
figure(2); 
% Représentation temporelle
subplot(2, 1, 1);
plot(t, signal_bruite);
title(['Signal Bruité (RSB = ', num2str(RSB_dB), ' dB)']);
xlabel('Temps (s)');
ylabel('Amplitude');
xlim([t(1),t(end)]);
% Spectrogramme
subplot(2, 1, 2);
spectrogram(signal_bruite, 256, 128, 256, Fs, 'yaxis');
title(['Spectrogramme (RSB = ', num2str(RSB_dB), ' dB)']);

% écoute du son pour voir la diff
sound(signal, Fs);

pause(length(signal)/Fs + 1); % permet de mettre une pause entre les 2 sons

sound(signal_bruite, Fs);