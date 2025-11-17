%% Préliminaire 3
clc
close all
clear

% Récupération d'un signal
data = load('../Signaux_parole/fcno01fz.mat');
signal = data.fcno01fz;

% Paramètres
k0 = 3000;

% Création de h
h = zeros(1, k0 + 1);
h(1) = 1;
h(k0+1) = 1;

% Application du filtre
a = 1;
signal_filtre = filter(h, a, signal);

% Affichage des signaux
Fs = 8000;
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

% Signal filtré
figure(2); 
% Représentation temporelle
subplot(2, 1, 1);
plot(t, signal_filtre);
title(['Signal Filtré (k0 = ', num2str(k0), ')']);
xlabel('Temps (s)');
ylabel('Amplitude');
xlim([t(1),t(end)]);
% Spectrogramme
subplot(2, 1, 2);
spectrogram(signal_filtre, 256, 128, 256, Fs, 'yaxis');
title(['Spectrogramme (k0 = ', num2str(k0), ')']);

% écoute du son 
sound(signal, Fs);

pause(length(signal)/Fs + 1); % permet de mettre une pause entre les 2 sons

sound(signal_filtre, Fs);