# Importer le module Active Directory
Import-Module ActiveDirectory

# Vérifier si le domaine existe déjà
$domainExists = Get-ADDomain | Where-Object { $_.NetBIOSName -eq 'pourlesvieux' }
if (!$domainExists) {
    # Créer un nouveau domaine
    Install-ADDSForest -DomainName "pourlesvieux.local" -DomainMode Win2016 -InstallDns -Force
}

# Chemin du fichier CSV
$fichierCSV = "C:\Utilisateur_ads.csv"

# Lire le fichier CSV
$utilisateurs = Import-Csv $fichierCSV

# Tableau pour stocker les établissements uniques
$etablissements = @()

# Lire le fichier CSV ligne par ligne
$utilisateurs | ForEach-Object {
    # Ajouter l'établissement de chaque ligne à la liste
    $etablissements += $_.etablissement
}

# Fonction pour créer les sous-OUs par défaut
function CreerOUsParDefaut {
    param (
        [string]$ParentOU
    )

    # Vérifier si l'OU "Users" existe, sinon la créer
    $ouUsersExiste = Get-ADOrganizationalUnit -Filter {Name -eq 'Users'} -SearchBase $ParentOU -ErrorAction SilentlyContinue
    if (-not $ouUsersExiste) {
        New-ADOrganizationalUnit -Name "Users" -Path $ParentOU
        Write-Host "L'OU 'Users' a été créée dans $ParentOU"
        break
    } 

    # Faire de même pour les OUs "Groups" et "Computers"
    $ouGroupsExiste = Get-ADOrganizationalUnit -Filter {Name -eq 'Groups'} -SearchBase $ParentOU -ErrorAction SilentlyContinue
    if (-not $ouGroupsExiste) {
        New-ADOrganizationalUnit -Name "Groups" -Path $ParentOU
        Write-Host "L'OU 'Groups' a été créée dans $ParentOU"
        break
    }

    $ouComputersExiste = Get-ADOrganizationalUnit -Filter {Name -eq 'Computers'} -SearchBase $ParentOU -ErrorAction SilentlyContinue
    if (-not $ouComputersExiste) {
        New-ADOrganizationalUnit -Name "Computers" -Path $ParentOU
        Write-Host "L'OU 'Computers' a été créée dans $ParentOU"
        break
    }
}

# Parcourir chaque établissement dans la liste
foreach ($etablissement in $etablissements) {
    $cheminOU = "OU=$etablissement,DC=pourlesvieux,DC=local"
    $ouExiste = Get-ADOrganizationalUnit -Filter {Name -eq $etablissement} -ErrorAction SilentlyContinue

    if (-not $ouExiste) {
        # Créer une nouvelle OU pour l'établissement
        $nouvelleOU = New-ADOrganizationalUnit -Name $etablissement -Path "DC=pourlesvieux,DC=local"
        # Créer les sous-OUs par défaut à l'intérieur de la nouvelle OU d'établissement
        CreerOUsParDefaut -ParentOU $nouvelleOU.DistinguishedName
    } else {
        # Si l'établissement existe déjà, vérifiez et créez les sous-OUs manquantes
        CreerOUsParDefaut -ParentOU $ouExiste.DistinguishedName
    }
}





# Fonction pour créer les utilisateurs
function CreerUtilisateurs {
    param (
        [string]$ParentOU,
        [string]$Nom,
        [string]$Prenom
    )

    $nomUtilisateur = $Nom.Substring(0,1) + $Prenom
    $cheminOU = "OU=Users,$ParentOU"
    $utilisateurExiste = Get-ADUser -Filter {SamAccountName -eq $nomUtilisateur} -ErrorAction SilentlyContinue

    if (-not $utilisateurExiste) {
        $password = ConvertTo-SecureString "Azerty06!" -AsPlainText -Force
        New-ADUser -SamAccountName $nomUtilisateur -UserPrincipalName "$nomUtilisateur@pourlesvieux.local" -Name "$Prenom $Nom" -GivenName $Prenom -Surname $Nom -AccountPassword $password -Enabled $true -Path $cheminOU
        Write-Host "L'utilisateur $Prenom $Nom a été créé dans $ParentOU"
    } else {
        Write-Host "L'utilisateur $Prenom $Nom existe déjà dans $ParentOU"
    }
}

# Créer les utilisateurs
foreach ($utilisateur in $utilisateurs) {
    $nom = $utilisateur.Nom
    $prenom = $utilisateur.Prenom
    $etablissement = $utilisateur.Etablissement

    # Récupérer le chemin de l'OU correspondant à l'établissement
    $cheminOU = "OU=$etablissement,DC=pourlesvieux,DC=local"
    
    # Créer l'utilisateur dans l'OU correspondant à l'établissement
    CreerUtilisateurs -ParentOU $cheminOU -Nom $nom -Prenom $prenom
}