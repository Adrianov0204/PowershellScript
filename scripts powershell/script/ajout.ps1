$local = [ADSI]"WinNT://."
$nom = Read-Host -Prompt "Saisir un nom"
$description = Read-Host -Prompt "Saisir une description"
$fullName = Read-Host -Prompt "Saisir un nom complet"

$compte = [ADSI]"WinNT://./$nom"
if (!$compte.path) {
    $utilisateur = $local.create("user", $nom)
    $utilisateur.InvokeSet("FullNames", $fullName)
    $utilisateur.InvokeSet("Description", $description)
    $utilisateur.commitChanges()
    Write-Host "$nom ajouté"
}
else {
    Write-Host "$nom existe déjà"
}
