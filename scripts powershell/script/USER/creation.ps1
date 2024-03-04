$CSVFile = "techniciens.csv"
$CSVData = Import-CSV -Path $CSVFile -Delimiter ";" -Encoding UTF8
Set-ADOrganizationalUnit -Identity "OU=Utilisateurs,DC=capital,DC=local" -ProtectedFromAccidentalDeletion:$true -PassThru

foreach ($Utilisateur in $CSVData) {
    $UtilisateurPrenom = $Utilisateur.Prenom
    $UtilisateurNom = $Utilisateur.Nom
    $UtilisateurLogin = $UtilisateurPrenom.Substring(0,1).ToLower() + $UtilisateurNom.ToLower()
    $UtilisateurMotDePasse = "eleve123."
    $UtilisateurFonction = $Utilisateur.Fonction
    $UtilisateurService = $Utilisateur.Service
    $UtilisateurDescription = $Utilisateur.Description
    $UtilisateurEmail = "$UtilisateurPrenom.$UtilisateurNom@grpmedilab.fr"
    $UtilisateurGroup = $Utilisateur.Group
    $UtilisateurDateIN = Get-Date  # Date actuelle
    $UtilisateurDateOUT = $Utilisateur.DateOUT  # Date d'expiration du compte à partir du CSV
    $UtilisateurPHONE = $Utilisateur.PHONE  # Numéro de téléphone à partir du CSV
    
    # Vérifier la présence de l'utilisateur dans l'AD
    if (Get-ADUser -Filter {SamAccountName -eq $UtilisateurLogin}) {
        Write-Warning "L'identifiant $UtilisateurLogin existe déjà dans l'AD"
    } else {
        New-ADUser  -Name $UtilisateurNom `
                    -DisplayName "$UtilisateurNom $UtilisateurPrenom" `
                    -GivenName $UtilisateurPrenom `
                    -Surname $UtilisateurNom `
                    -SamAccountName $UtilisateurLogin `
                    -UserPrincipalName "$UtilisateurLogin@capital.local" `
                    -EmailAddress $UtilisateurEmail `
                    -description $UtilisateurDescription `
                    -Title $UtilisateurFonction `
                    -Department $UtilisateurService `
                    -Path "OU=$UtilisateurGroup,OU=Utilisateurs,DC=capital,DC=local" `
                    -AccountPassword (ConvertTo-SecureString $UtilisateurMotDePasse -AsPlainText -Force) `
                    -ChangePasswordAtLogon $true `
                    -Enabled $false `
                    -OfficePhone $UtilisateurPHONE `
                    -AccountExpirationDate $UtilisateurDateOUT `
        
        Add-AdGroupMember -Identity $UtilisateurGroup -Members $UtilisateurLogin

        Write-Output "Création de l'utilisateur : $UtilisateurLogin ($UtilisateurNom $UtilisateurPrenom)"
    }
}
