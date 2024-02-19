$CSVFile = "group.csv"
$CSVData = Import-CSV -Path $CSVFile -Delimiter ";" -Encoding UTF8

foreach ($Group in $CSVData) {
    $GroupDescription = $Group.description
    $GroupNom = $Group.Nom
    $GroupPath = $Group.Path
    $GroupScope = $Group.Scope

    # Vérifier la présence du groupe dans l'AD
    if (Get-ADGroup -Filter {Name -eq $GroupNom}) {
        Write-Warning "$GroupNom existe déjà dans l'AD"
    }
    else {
        # Vérifier si le chemin spécifié existe dans l'Active Directory
        if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$GroupPath'")) {
            Write-Warning "Le chemin spécifié $GroupPath n'existe pas dans l'Active Directory."
            continue
        }

        New-ADGroup -Name $GroupNom `
                    -Description $GroupDescription `
                    -Path $GroupPath `
                    -GroupScope $GroupScope `
                    -GroupCategory Security # Spécifier que le groupe est de type sécurité

        Write-Output "$GroupNom ajouté"
    }
}
