$CSVFile = "ou.csv"
$CSVData = Import-CSV -Path $CSVFile -Delimiter ";" -Encoding UTF8

Foreach ($OU in $CSVData) {
    $NomOU = $OU.NomOU
    $CheminOU = $OU.CheminOU

    # Vérifier la présence de l'OU dans l'AD
    if (Get-ADOrganizationalUnit -Filter {Name -eq $NomOU} -SearchBase $CheminOU) {
        Write-Warning "L'OU $NomOU existe déjà dans l'AD"
    } else {
        New-ADOrganizationalUnit -Name $NomOU -Path $CheminOU -ProtectedFromAccidentalDeletion:$true -PassThru
        Write-Output "Création de l'OU : $NomOU"
    }
}
