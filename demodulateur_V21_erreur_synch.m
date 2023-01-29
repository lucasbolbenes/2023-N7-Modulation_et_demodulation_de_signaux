function information_binaire_demodule = demodulateur_V21_erreur_synch(modulation_bruitee)
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
    temps = linspace(0, nb_bits,taille_echant); % Temps nécessaire pour tous les bits 
    
   %% 6.3
    % puisqu'on sait qu'il est impossible de synchroniser les phases ont en creer deux
    % nouvelles pour l'oscillateur de réception
    theta_0 = rand*2*pi;
    theta_1 = rand*2*pi;

    % multiplication dans chaque branche au cos propre à la branche
    signal_FSK_0 = modulation_bruitee .* cos(2*pi*F0*temps + theta_0);
    signal_FSK_1 = modulation_bruitee .* sin(2*pi*F0*temps + theta_0);
    signal_FSK_2 = modulation_bruitee .* cos(2*pi*F1*temps + theta_1);
    signal_FSK_3 = modulation_bruitee .* sin(2*pi*F0*temps + theta_1);
    
    % créer des matrices de N lignes avec Ns données sur chaque ligne pour pouvoir
    % integrer sur des intervalles de Ns
    signal_FSK_0 = (reshape(signal_FSK_0, Ns, N * nb_bits))';
    signal_FSK_1 = (reshape(signal_FSK_1, Ns, N * nb_bits))';
    signal_FSK_2 = (reshape(signal_FSK_2, Ns, N * nb_bits))';
    signal_FSK_3 = (reshape(signal_FSK_3, Ns, N * nb_bits))';
    

    % Intégration sur chacune des deux branches avec la méthode des rectangles et un pas constant (Te)
    integrale_signal_FSK_0 = (sum(signal_FSK_0,2) * Te).^2;
    integrale_signal_FSK_1 = (sum(signal_FSK_1,2) * Te).^2;
    integrale_signal_FSK_2 = (sum(signal_FSK_2,2) * Te).^2;
    integrale_signal_FSK_3 = (sum(signal_FSK_3,2) * Te).^2;
    
    % différences des résultats des branches 0 et 1 et des branches 2 et 3
    integrale_signal_FSK_01 = integrale_signal_FSK_0 + integrale_signal_FSK_1;
    integrale_signal_FSK_23 = integrale_signal_FSK_2 + integrale_signal_FSK_3;
    
    % difference des résultats précédent utile dans la comparaison à 0
    difference_integrales_FSK = integrale_signal_FSK_23 - integrale_signal_FSK_01;
    
    % déduction de l'information binaire démodulée
    information_binaire_demodule = difference_integrales_FSK > 0;

end

