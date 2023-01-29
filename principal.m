clear all; close all; clc;
%% Données du problème modélisé

N = 300; % Nombre de bits par seconde, contenus dans l'information binaire
Fe = 48000; % Fréquence d'échantillonage
SNR_dB = 50; % Bruit

nb_bits = 300;

F0 = 6000; % Fréquence associée aux zéros
Fc = 4000; % Fréquence de coupure
F1 = 2000; % Fréquence associée aux uns

F0_V21 = 1180; % Fréquence associée aux zéros
Fc_V21 = 1080; % Fréquence de coupure
F1_V21 = 980; % Fréquence associée aux uns

% Définition des deux variables aléatoires
psi_0 = rand*2*pi;
psi_1 = rand*2*pi;

% Choisissez la démodulation que vous souhaitez utiliser :
% 0 : demodulation par filtrage
% 1 : demodulation V21 synchronisation idéale
% 2 : demodulation V21 erreur de synchronisation 

demodulation_choisie = 0;


%% 2 - Information binaire à transmettre
% Génération d'une suite de N bits aléatoire
information_binaire = randi(2,1,nb_bits) - 1;


%% 3 - Modulation
if demodulation_choisie == 0 
    modulation = modulateur(information_binaire, F0, F1, psi_0, psi_1);
else 
    modulation = modulateur(information_binaire, F0_V21, F1_V21,psi_0, psi_1);
end

%% 4 - Canal de transmission à bruit additif, blanc Gaussien

modulation_bruitee = ajout_bruit(modulation, SNR_dB);

%% 5 - Démodulation
switch demodulation_choisie
    case 0
        %% 5.1 - Démodulation par filtrage
        disp('Ok')
        information_binaire_demodule = demodulateur_filtrage(modulation_bruitee, 201, Fc);
    case 1
        %% 5.2 - Démodulation V21 avec synchronisation idéale
        information_binaire_demodule = demodulateur_V21_synch_ideale(modulation_bruitee, psi_0, psi_1);
    case 2
        %% 5.3 - Démodulation V21 avec erreur de synchronisation
        information_binaire_demodule = demodulateur_V21_erreur_synch(modulation_bruitee);
    otherwise
        disp('Choix incorrect');
end


erreur_binaire = (nb_bits - sum(information_binaire_demodule' == information_binaire)) / nb_bits;

disp('Erreur binaire :')
disp(erreur_binaire);











