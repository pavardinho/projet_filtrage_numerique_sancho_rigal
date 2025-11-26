clc
clear
close all

% Récupération d'un signal
data = load('../Signaux_parole/fcno03fz.mat');
signal = data.fcno03fz;

% Paramètes
RSB_dB = 25;
Fs = 8000;
N = length(signal);

taille_trame = 10000;
recouvrement = 0.5;

pas = taille_trame*(1-recouvrement);
nb_trame = ceil((N - taille_trame) / pas) + 1;

% Bruitage du signal
signal_bruite = bruitage(signal, RSB_dB);

fenetre = hann(taille_trame, 'periodic');
trames = zeros(taille_trame, nb_trame);
trames_rehaussees = zeros(taille_trame, nb_trame);
id_deb = 1;
for i = 1:nb_trame
    id_fin = id_deb + taille_trame - 1;
    % cas où la trame est trop courte : (on fait du 0 padding)
    if id_fin > N
        trame_actuelle = [signal_bruite(id_deb : end) ; zeros(id_fin - N, 1)];
    
    % cas où c'est bon
    else 
        trame_actuelle = [signal_bruite(id_deb : id_fin)];
    end
    trames(:, i) = trame_actuelle.* fenetre ; % on applique le fenêtrage à chaque trame

    % Méthode 2.5 ici
    Y = fft(trames(:,i));
    Py = abs(Y).^2;
    K = 10^(RSB_dB/10);
    Puissance_signal = mean(signal_bruite.^2);
    sigma_bruit_est = Puissance_signal / (K + 1);

    Ps_estime = Py - sigma_bruit_est;
    Ps_estime(Ps_estime < 0) = 0;

    trames_rehaussees(:,i) = ifft(sqrt(Ps_estime) .* exp(1j*angle(Y)));

    id_deb = id_deb + pas;
end

% Reconstruction du signal
signal_reconstruit = zeros((nb_trame - 1)*pas + taille_trame, 1);

id_deb1 = 1;
for i = 1:nb_trame
    id_fin1 = id_deb1 + taille_trame - 1;

    signal_reconstruit(id_deb1:id_fin1) = real(signal_reconstruit(id_deb1:id_fin1) + trames_rehaussees(:, i));

    id_deb1 = id_deb1 + pas;
end

N = length(signal);
t = (0:N-1)/Fs; 

signal_reconstruit_coupe = signal_reconstruit(1:N);

figure;
subplot(3,1,1);
plot(t, signal);
title('Signal de base');
xlabel('Temps (s)');
ylabel('Amplitude');

subplot(3,1,2);
plot(t, signal_bruite(1:N));
title('Signal bruité');
xlabel('Temps (s)');
ylabel('Amplitude');

subplot(3,1,3);
plot(t, signal_reconstruit_coupe);
title('Signal rehaussé');
xlabel('Temps (s)');
ylabel('Amplitude');

sgtitle('Comparaison des signaux');
