$CSVFile = "C:\Users\Administrator\Documents\userADDS\nuser.csv"
$CSVData = Import-CSV -Path $CSVFile -Delimiter ";" -Encoding UTF8

Foreach($Utilisateur in $CSVData){

    	$UtilisateurPrenom = $Utilisateur.Prenom
    	$UtilisateurNom = $Utilisateur.Nom
    	$UtilisateurLogin = ($UtilisateurPrenom).Substring(0,1) + "." + $UtilisateurNom
    	$UtilisateurEmail = "$UtilisateurLogin@adrien.fr"
    	$UtilisateurMotDePasse = "Adr!en@2022"
    	$UtilisateurFonction = $Utilisateur.Fonction
	$Name = $Utilisateur.Prenom + $Utilisateur.Nom
	$UPath = "OU=" + $UtilisateurFonction +",OU=SERVICES,DC=adrien,DC=lan" 
	$Initial = ($UtilisateurPrenom).Substring(0,1) + ($UtilisateurNom).Substring(0,1)
	$Group = "GRP_"+ $UtilisateurFonction
	$gPath = "CN="+$Name+","+$UPath
    # Vérifier la présence de l'utilisateur dans l'AD
    if (Get-ADUser -Filter {SamAccountName -eq $UtilisateurLogin})
    {
        Write-Warning "L'identifiant $UtilisateurLogin existe déjà dans l'AD"
    }
    else
    {
        New-ADUser	-Name $Name `
                    	-DisplayName $UtilisateurNom`
                    	-GivenName $UtilisateurPrenom `
                    	-Surname $UtilisateurNom `
                    	-SamAccountName $UtilisateurLogin `
                    	-UserPrincipalName "$UtilisateurLogin@adrien.fr" `
                    	-EmailAddress $UtilisateurEmail `
                    	-Title $UtilisateurFonction `
			-Initials $Initial `
                    	-Path $UPath `
                    	-AccountPassword(ConvertTo-SecureString $UtilisateurMotDePasse -AsPlainText -Force) `
			-ChangePasswordAtLogon $true `
                    	-Enabled $true
        Write-Output "Creation de l'utilisateur : $UtilisateurLogin ($UtilisateurNom $UtilisateurPrenom)"
		
		Add-ADGroupMember -Identity $Group -Members $gPath
		Write-Host "Added $Name to $Group" -ForeGroundColor Green

		
    }
}
