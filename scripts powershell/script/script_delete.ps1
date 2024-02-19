$CSVFile = "C:\script\techniciens.csv"
$CSVData = Import-CSV -Path $CSVFile -Delimiter ";" -Encoding UTF8

Foreach($Utilisateur in $CSVData){

    $UtilisateurPrenom = $Utilisateur.Prenom
    $UtilisateurNom = $Utilisateur.Nom
    $UtilisateurLogin = ($UtilisateurPrenom).Substring(0,1) + "." + $UtilisateurNom
    $UtilisateurFonction = $Utilisateur.Fonction 
    
    Remove-ADUser -Identity $UtilisateurLogin -Confirm:$false
    Write-Output "utilisateurs suprimmés : $UtilisateurLogin ($UtilisateurNom $UtilisateurPrenom)" 
 }
    Remove-ADOrganizationalUnit -Identity "OU=Production,DC=sisr,DC=local" -Confirm:$false 
