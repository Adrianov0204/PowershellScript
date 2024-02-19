$CSVFile = "C:\script\techniciens.csv"
$CSVData = Import-CSV -Path $CSVFile -Delimiter ";" -Encoding UTF8
       
Foreach($Utilisateur in $CSVData){

    $UtilisateurPrenom = $Utilisateur.Prenom
    $UtilisateurNom = $Utilisateur.Nom
    $UtilisateurLogin = ($UtilisateurPrenom).Substring(0,1) + "." + $UtilisateurNom
    $UtilisateurMotDePasse = "eleve123."
    $UtilisateurFonction = $Utilisateur.Fonction
    $UtilisateurEmail = "$UtilisateurPrenom.$UtilisateurNom@sisr.fr"

      Write-Output "nom de l'utilisateur:  ($UtilisateurNom $UtilisateurPrenom $UtilisateurLogin $UtilisateurEmail $UtilisateurMotDePasse $UtilisateurFonction)"
      }