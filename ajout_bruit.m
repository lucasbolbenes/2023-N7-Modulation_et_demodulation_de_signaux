function modulation_bruitee = ajout_bruit(modulation, SNR_dB)
    % Initialisation 
    Fe = 48000;
    taille_echant = length(modulation);

    %% 4 - Canal de transmission à bruit additif, blanc Gaussien
    % Génération du bruit blanc gaussien
    SNR_dB = 50;
    puissance_modulation = mean(abs(modulation).^2);
    puissance_bruit = puissance_modulation * 10 ^ (-SNR_dB / 10);
    bruit = sqrt(puissance_bruit) * randn(1, taille_echant); 
    length(bruit)

    % Ajout du bruit blanc au signal modulé en fréquence
    modulation_bruitee = modulation + bruit;
    
    % Affichage du signal modulé en fréquence avant et après l'ajout du bruit
    figure('Name', 'Génération du signal modulé', 'NumberTitle','off', 'position', get(0,'ScreenSize'));
    tiledlayout(1,2);

    temps = linspace(0,(taille_echant/Fe),taille_echant); % Temps nécessaire pour tous les bits 
    
    nexttile
    plot(temps, modulation)
    title("Modulation")
    xlabel("Temps (s)")
    ylabel("Amplitude")

    nexttile
    plot(temps, modulation_bruitee)
    title("Modulation + Bruit")
    xlabel("Temps (s)")
    ylabel("Amplitude")
end

