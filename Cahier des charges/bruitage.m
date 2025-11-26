%% Fonction qui va bruiter un signal
function [signal_bruite] = bruitage(signal, RSB_db)
    
    signal = signal(:); % check si vecteur collone
    
    E_signal = 0;
    % calcule l'énergie du signal
    for i = 1:length(signal)
        E_signal = E_signal + signal(i)^2;
    end
    
    % Calcule l'énergie que le bruit doit avoir
    E_bruit = E_signal / (10^(RSB_db/10));
    
    % Génère un bruit de la taille du signal
    bruit_init = randn(size(signal));
    
    E_bruit_init = 0;
    % Calcule l'énergie de ce bruit de base
    for i = 1:length(bruit_init)
        E_bruit_init = E_bruit_init + bruit_init(i)^2;
    end
    
    % calcul du facteur d'échelle
    facteur_ech = sqrt(E_bruit / E_bruit_init);

    bruit_final = facteur_ech * bruit_init;
    
    % bruite le signal
    signal_bruite = signal + bruit_final;
    
end