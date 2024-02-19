$CSVFile = "C:\computers.csv"
$CSVData = Import-CSV -Path $CSVFile -Delimiter ";" -Encoding UTF8

Foreach ($Computer in $CSVData) {
    $ComputerDescription = $Computer.description
    $ComputerNom = $Computer.Nom
    $ComputerPath = $Computer.Path

  # VÃ©rifier la prÃ©sence de l'utilisateur dans l'AD
    if (Get-ADComputer -Filter {Name -eq $ComputerNom})
    {
        Write-Warning "$ComputerNom existe dÃ©jÃ  dans l'AD"
    }
    else
    {
        
        New-ADComputer  -Name $ComputerNom `
                        -Description $ComputerDescription `
                        -Path $ComputerPath `
                    
                    

        Write-Output "CrÃ©ation de l'utilisateur : $ComputerNom ajouté"
    }
}