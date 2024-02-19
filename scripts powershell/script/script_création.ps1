$CSVFile = "C:\script\techniciens.csv"
$CSVData = Import-CSV -Path $CSVFile -Delimiter ";" -Encoding UTF8
        New-ADOrganizationalUnit -Name "Production" -Path "DC=sisr,DC=local"
        Set-ADOrganizationalUnit -Identity "OU=Production,DC=sisr,DC=local" -ProtectedFromAccidentalDeletion:$false -PassThru

Foreach($Utilisateur in $CSVData){

    $UtilisateurPrenom = $Utilisateur.Prenom
    $UtilisateurNom = $Utilisateur.Nom
    $UtilisateurLogin = ($UtilisateurPrenom).Substring(0,1) + "." + $UtilisateurNom
    $UtilisateurMotDePasse = "eleve123."
    $UtilisateurFonction = $Utilisateur.Fonction
    $UtilisateurEmail = "$UtilisateurPrenom.$UtilisateurNom@sisr.fr"
    

       
     # Vérifier la présence de l'utilisateur dans l'AD
    if (Get-ADUser -Filter {SamAccountName -eq $UtilisateurLogin})
    {
        Write-Warning "L'identifiant $UtilisateurLogin existe déjà dans l'AD"
    }
    else
    {
        
        New-ADUser  -Name "$UtilisateurNom $UtilisateurPrenom" `
                    -DisplayName "$UtilisateurNom $UtilisateurPrenom" `
                    -GivenName $UtilisateurPrenom `
                    -Surname $UtilisateurNom `
                    -SamAccountName $UtilisateurLogin `
                    -UserPrincipalName "$UtilisateurLogin@sisr.local" `
                    -EmailAddress $UtilisateurEmail `
                    -Title $UtilisateurFonction `
                    -Path "OU=Production,DC=sisr,DC=LOCAL" `
                    -AccountPassword(ConvertTo-SecureString $UtilisateurMotDePasse -AsPlainText -Force) `
                    -ChangePasswordAtLogon $true `
                    -Enabled $true

        Write-Output "Création de l'utilisateur : $UtilisateurLogin ($UtilisateurNom $UtilisateurPrenom)"
    }
} 
