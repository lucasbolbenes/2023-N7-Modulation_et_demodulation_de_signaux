function information_binaire_demodule = demodulateur_filtrage(modulation_bruitee, ordre, Fc)
    %% 5 - Démodulation par filtrage

    % Initialisation

    % Variables nécessaires
  
    N = 300;
    Fe = 48000;
    taille_echant = length(modulation_bruitee);
    nb_bits = taille_echant/Fe;
    Ts = 1/N; % Temps d'un bit
    Ns = Ts*Fe; % Nombre d'echantillons pour un bit
    temps = linspace(0, nb_bits,taille_echant); % Temps nécessaire pour tous les bits 
    


    % Création de la figure
    figure('Name', 'Demodulateur Filtrage', 'NumberTitle','off', 'position', get(0,'ScreenSize'));
    tiledlayout(3,4);

    frequences = 0:(Fe/2);

    % Affichage du signal modulé bruité avant traitement
    nexttile(1)
    plot(temps,modulation_bruitee)
    title("Signal d'origine, précédemment modulé puis bruité")
    xlabel("Temps (s)")
    ylabel("Amplitude")

    % Affichage de la FFT du signal modulé bruité avant traitement
    FFT_modulation_bruitee = fft(modulation_bruitee);

    affichage_FFT_modulation_bruitee = abs(FFT_modulation_bruitee/Fe);
    affichage_FFT_modulation_bruitee = affichage_FFT_modulation_bruitee(1:Fe/2+1);
        
    nexttile(2)
    plot(frequences,affichage_FFT_modulation_bruitee) 
    title("FFT du signal d'origine")
    xlabel("Fréquence")
    ylabel("Amplitude")

    %% 5.1 - Filtre passe bas
    % Réponse impulsionnelle du filtre passe bas parfait (fonction porte)
    h_passebas = 2 * (Fc / Fe) * sinc(2 * (Fc / Fe) * (-(ordre-1)/2:1:(ordre-1)/2));

    % Réponse en fréquence du filtre passe bas
    H_passebas = fft(h_passebas, Fe);

    % Filtrage
    modulation_passe_bas = filter(h_passebas,1,modulation_bruitee);
    FFT_modulation_passe_bas = fft(modulation_passe_bas);
    
    % Correction de l'erreur dûe au retard : on enlève les (ordre - 1)/2
    % premiers echantillons, et on rajoute le même nombre d'échantillon nul à
    % la fin pour garder la cohérence dimensionnelle

    nombre_echantilons_retard = (ordre - 1)/2;
    modulation_passe_bas = modulation_passe_bas(nombre_echantilons_retard+1:size(modulation_passe_bas,2));
    modulation_passe_bas = [modulation_passe_bas, zeros(1, nombre_echantilons_retard)];
    
    % Affichage du signal filtré par le filtre passe bas
    nexttile(5)
    plot(temps,modulation_passe_bas)
    title("Signal filtré par le filtre passe bas")
    xlabel("Temps (s)")
    ylabel("Amplitude")

    % Affichage de la FFT du signal modulé filtré par un filtre passe bas
    affichage_FFT_modulation_passe_bas = abs(FFT_modulation_passe_bas/Fe);
    affichage_FFT_modulation_passe_bas = affichage_FFT_modulation_passe_bas(1:Fe/2+1);
    
    nexttile(6)
    plot(frequences, affichage_FFT_modulation_passe_bas)
    title("FFT du signal modulé filtré par un filtre passe bas")
    xlabel("Fréquence")
    ylabel("Amplitude")

    % Affichage de la réponse impulsionnelle
    nexttile(7)
    plot(h_passebas)
    title("Réponse impulsionnelle du filtre passe bas")
    xlabel("Temps")
    ylabel("Amplitude")

    % Affichage de la réponse en fréquence
    affichage_H_passebas = abs(H_passebas/Fe);
    affichage_H_passebas = affichage_H_passebas(1:Fe/2+1);

    nexttile(8)
    plot(frequences,affichage_H_passebas)
    title("Réponse en fréquence du filtre passe bas (Hbas)")
    xlabel("Fréquence")
    ylabel("Amplitude")

    % FFT du signal d'origine et réponse en fréquences du filtre passe bas
    nexttile(3)
    semilogy(frequences,affichage_FFT_modulation_bruitee), hold on
    semilogy(frequences,affichage_H_passebas)
    title("FFT du signal d'origine et Hbas (échelle logarithmique)")
    xlabel("Fréquence")
    ylabel("Amplitude")
    legend("FFT du signal d'origine","Réponse en fréquence du filtre passe bas")
    hold off
    
    %% 5.2 - Filtre passe haut
    % 5.2.1 
    % Réponse impulsionnelle du filtre passe haut
    dir = zeros(1,ordre);
    dir((ordre-1)/2)=1;
    h_passehaut = dir - h_passebas;
    % Réponse en fréquence du filtre passe haut
    H_passehaut = fft(h_passehaut, Fe);

    % Filtrage
    modulation_passe_haut = filter(h_passehaut,1,modulation_bruitee);
    FFT_modulation_passe_haut = fft(modulation_passe_haut);
    
    % Affichage du signal filtré par le filtre passe haut
    nexttile(9)
    plot(temps,modulation_passe_haut)
    title("Signal modulé filtré par un filtre passe haut")
    xlabel("Temps (s)")
    ylabel("Amplitude")
    
    affichage_FFT_modulation_passe_haut = abs(FFT_modulation_passe_haut/Fe);
    affichage_FFT_modulation_passe_haut = affichage_FFT_modulation_passe_haut(1:Fe/2+1);

    % Affichage de la FFT du signal modulé filtré par un filtre passe haut
    nexttile(10)
    plot(frequences, affichage_FFT_modulation_passe_haut)
    title("FFT du signal modulé filtré par un filtre passe haut")
    xlabel("Fréquence")
    ylabel("Amplitude")

    % Affichage de la réponse impulsionnelle
    nexttile(11)
    plot(h_passehaut)
    title("Réponse impulsionnelle du filtre passe haut")
    xlabel("Temps")
    ylabel("Amplitude")

    % Affichage de la réponse en fréquence
    affichage_H_passehaut = abs(H_passehaut/Fe);
    affichage_H_passehaut = affichage_H_passehaut(1:Fe/2+1);

    nexttile(12)
    plot(frequences,affichage_H_passehaut)
    title("Réponse en fréquence du filtre passe haut (Hhaut)")
    xlabel("Fréquence")
    ylabel("Amplitude")
    
    % FFT du signal d'origine et réponse en fréquences du filtre passe haut
    nexttile(4)
    semilogy(frequences,affichage_FFT_modulation_bruitee), hold on
    semilogy(frequences,affichage_H_passehaut)
    title("FFT du signal d'origine et Hhaut (échelle logarithmique)")
    xlabel("Fréquence")
    ylabel("Amplitude")
    legend("FFT du signal d'origine","Réponse en fréquence du filtre passe haut")
    hold off
  
    
    %% 5.3 : On a un retard qui correspond à l'ordre du filtre
    
    %% 5.5 Détection d'énergie
    
    echantillons_taille_Ns = (reshape(modulation_passe_bas, Ns, N * nb_bits))';
    somme_echantillons_taille_Ns = sum(echantillons_taille_Ns.^2,2);
    K = mean(somme_echantillons_taille_Ns);
    information_binaire_demodule = somme_echantillons_taille_Ns > K;
end

