function modulation = modulateur(information_binaire, F0, F1, psi_0, psi_1)
    %% 3 - Modulation
    
    % Initialisation

    % Création de la figure
    figure('Name', 'Modulation', 'NumberTitle','off', 'position', get(0,'ScreenSize'));
    tiledlayout(2,3);

    % Variables nécessaires
    N = 300;
    Fe = 48000;
    nb_bits = length(information_binaire)/N;
    Ts = 1/N; % Temps d'un bit
    Ns = Ts*Fe; % Nombre d'echantillons pour un bit
    temps = linspace(0,1, nb_bits * Fe); % Temps nécessaire pour tous les bits 

    
    %% 3.1 - Génération et observation du signal NRZ
    % 3.1.1 - Génération du signal NRZ
    NRZ = kron(information_binaire, ones(1,Ns));

    % 3.1.2 - Calcul de la DSP théorique et estimée du signal NRZ
    DSP_NRZ = pwelch(NRZ,[],[],[],Fe,'twosided');
    frequences = linspace(0,Fe,size(DSP_NRZ,1));
    DSP_NRZ_Theorique = (1/4)*Ts*(sinc(pi*frequences*Ts)).^2 + (1/4)*dirac(frequences);
    
    % 3.1.3 - Affichage du signal NRZ, et de sa DSP théorique et estimée
    
    % Affichage du signal NRZ
    nexttile
    plot(temps, NRZ)
    title("Signal NRZ")
    xlabel("Temps (s)")
    ylabel("Amplitude")
    
    % Affichage de la DSP théorique et estimée du signal NRZ
    nexttile
    plot(DSP_NRZ, 'o-'), hold on
    plot(DSP_NRZ_Theorique)
    title("DSP du signal NRZ")
    xlabel("Fréquence")
    ylabel("Amplitude")
    legend("Densité spectrale de puissance estimée","Densité spectrale de puissance théorique")
    hold off
    
    % Affichage de de la DSP théorique et estimée du signal NRZ en échelle logarithmique
    nexttile
    semilogy(DSP_NRZ), hold on
    semilogy(DSP_NRZ_Theorique)
    title("DSP du signal NRZ (échelle logarithmique)")
    xlabel("Fréquence")
    ylabel("Amplitude")
    legend("Densité spectrale de puissance estimée","Densité spectrale de puissance théorique")
    hold off
    
    %% 3.2 - Génération du signal modulé en fréquence
    % 3.2.1 - Génération du signal modulé en fréquence

    % Génération du signal modulé en fréquence
    modulation = (1 - NRZ) .* cos(2*pi*F0*temps + psi_0) + NRZ .* cos(2*pi*F1*temps + psi_1);
    
    % 3.2.2 - Calcul de la DSP estimée (la DSP théorique est disponible dans le rapport)
    DSP_modulation = pwelch(modulation,[],[],[],Fe,'twosided');
    
    % 3.2.3 - Affichage du signal modulé en fréquence et de sa DSP estimée
    
    % Affichage du signal modulé en fréquence
    nexttile
    plot(temps, modulation)
    title("Signal modulé")
    xlabel("Temps (s)")
    ylabel("Amplitude")
    
    % Affichage de la DSP estimée du signal modulé en fréquence
    nexttile
    plot(frequences, DSP_modulation, 'o-')
    title("DSP du signal modulé")
    xlabel("Fréquence")
    ylabel("Amplitude")
    legend("Densité spectrale de puissance estimée")


end

