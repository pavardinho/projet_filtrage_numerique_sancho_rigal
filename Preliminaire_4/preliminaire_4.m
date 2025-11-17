%% Préliminaire 4
clc 
close all
clear

% Paramètres
Fs = 8000;
duree = 1; % en seconde
N = duree * Fs;
f = 50; % en Hz

% Création du signal
t = (0:N-1) / Fs;
signal_synth = cos(2*pi*f*t);
signal_synth = signal_synth(:);

% Création de la trame
taille_trame = 256;
recouvrement = 128; % 50% de recouvrement dans ce cas

pas = taille_trame - recouvrement;

nb_echantillon = length(signal_synth);
nb_trame = ceil((nb_echantillon - taille_trame) / pas) + 1;

trames = zeros(taille_trame, nb_trame);

id_deb = 1;
for i = 1:nb_trame
    id_fin = id_deb + taille_trame - 1;
    % cas où la trame est trop courte : (on fait du 0 padding)
    if id_fin > nb_echantillon
        trame_actuelle = [signal_synth(id_deb : end) ; zeros(id_fin - nb_echantillon, 1)];
    
    % cas où c'est bon
    else 
        trame_actuelle = [signal_synth(id_deb : id_fin)];
    end

    % on remplit la matrice avec la trame
    trames(:, i) = trame_actuelle;
    id_deb = id_deb + pas;
end

% fenetrage des trames
fenetre = hann(taille_trame, 'periodic');

trames_fenetrees = zeros(size(trames));
for i = 1:nb_trame
    trames_fenetrees(:, i) = trames(:, i).* fenetre ; % on applique le fenêtrage à chaque trame
end

% Reconstruction du signal
signal_reconstruit = zeros((nb_trame - 1)*pas + taille_trame, 1);

id_deb1 = 1;
for i = 1:nb_trame
    id_fin1 = id_deb1 + taille_trame - 1;

    signal_reconstruit(id_deb1:id_fin1) = signal_reconstruit(id_deb1:id_fin1) + trames_fenetrees(:, i);

    id_deb1 = id_deb1 + pas;
end

disp('Signal reconstruit.');


figure(1);
% affichage supperposition des courbes
subplot(2, 1, 1);
plot(t, signal_synth, 'b', 'DisplayName', 'Original');
hold on;
plot(t, signal_reconstruit(1:N), 'r--', 'DisplayName', 'Reconstruit');
hold off;
title('Comparaison des signaux obtenus');
legend;
xlim([0, 0.1]);

% affichage de l'erreur entre les 2 courbes
subplot(2, 1, 2);
difference = signal_synth - signal_reconstruit(1:N);
plot(t, difference);
title('Erreur entre les 2 signaux');
xlabel('Temps (s)');
ylabel('Amplitude de l''erreur');
xlim([0, 0.1]);