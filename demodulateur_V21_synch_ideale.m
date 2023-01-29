function information_binaire_demodule = demodulateur_V21_synch_ideale(modulation_bruitee, psi_0, psi_1)
    % Initialisation

    % Variables nécessaires
    N = 300;
    Fe = 48000;
    taille_echant = length(modulation_bruitee);
    nb_bits = taille_echant/Fe;

    F0 = 1180;
    F1 = 980;

    Te = 1/Fe; % Période d'échantillonage
    Ts = 1/N; % Temps d'un bit
    Ns = Ts*Fe; % Nombre d'echantillons pour un bit
    temps = linspace(0,(taille_echant/Fe),taille_echant); % Temps nécessaire pour tous les bits 
    
    %% 6.1.2
    %multiplacation par le cos dans la 1ere branche 
    signal_0 = modulation_bruitee .* cos(2*pi*F0*temps + psi_0);
    %multiplacation par le cos dans la 2eme branche
    signal_1 = modulation_bruitee .* cos(2*pi*F1*temps + psi_1);
    
    %creer des matrices de N lignes avec Ns données sur chaque ligne pour pouvoir
    %integrer sur des intervalles de Ns
    signal_0 = (reshape(signal_0, Ns, N * nb_bits))';
    signal_1 = (reshape(signal_1, Ns, N * nb_bits))';
    
    %Integration sur chacune des deux branches avec la methode des rectangles et un pas constant (Te)
    integrale_signal_0 = sum(signal_0,2) * Te;
    integrale_signal_1 = sum(signal_1,2) * Te;
    
    %difference des résultats des deux branches a comparer à O
    difference_integrales = integrale_signal_1 - integrale_signal_0;
    
    %déduction du message binaire reçu
    information_binaire_demodule = difference_integrales > 0;
  
end

