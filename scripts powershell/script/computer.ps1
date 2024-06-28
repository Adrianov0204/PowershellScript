# Import the Active Directory module
Import-Module ActiveDirectory

# Retrieve all computer objects in the domain
$computers = Get-ADComputer -Filter *

# Count the number of computer objects
$computerCount = $computers.Count

# Output the number of computers
Write-Output "Number of computers in the domain: $computerCount"
