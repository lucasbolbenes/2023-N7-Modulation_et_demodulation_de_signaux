% Création de la figure
figure('Name', 'Recuperation image', 'NumberTitle','off', 'position', get(0,'ScreenSize'));
tiledlayout(2,3);

pictures = dir('./exemple_image/*.mat');
n = length(pictures);

ordre = [6, 1, 5, 4, 2, 3];
ordre_Anais = [6, 1, 5, 2, 4, 3];
for i = 1:n
    nom_fichier = ['./exemple_image/' pictures(ordre(i)).name];
    disp(['récupération ' nom_fichier])
    load(nom_fichier);

    information_binaire_recu = demodulateur_V21_erreur_synch(signal);
    image_retrouvee = reconstitution_image(information_binaire_recu);
    
    nexttile(i)
    imagesc(image_retrouvee, [0 255])
    title(nom_fichier)
end

