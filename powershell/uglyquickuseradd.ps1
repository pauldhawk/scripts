## set veriables ###


Function Set-sAMAccountName {
        "FirstInitialLastName"  {"{0}{1}" -f ($GivenName)[0],$SurName}
    }

Function Set-UPN {
        "FirstInitialLastName"  {"{0}{1}@{2}" -f ($GivenName)[0],$SurName,$Domain}
}

Function Set-DisplayName {
        "LastName, FirstName"   {"{0}, {1}" -f $SurName, $GivenName}
}	
	
Function Get-CSV-info{
		$CSV = Import-Csv :.\import.csv
		$i = 0
		ForEach ($Entry in $CSV){
			$User = New-Object System.Windows.Forms.ListViewItem($i)
			ForEach ($Col in ($lvCSV.Columns | ?{$_.Text -ne "ID"})){
                $Field = $Col.Text
                $SubItem = "$($Entry.$Field)"
                if($Field -eq 'FirstName'){$Script:GivenName = $SubItem}
                if($Field -eq 'LastName'){$Script:Surname = $SubItem}
                if($Field -eq 'Domain'){$Domain = $SubItem}
                if($Field -eq 'sAMAccountName' -AND $SubItem -eq ""){$SubItem = Set-sAMAccountName -Csv}
                if($Field -eq 'userPrincipalName' -AND $SubItem -eq ""){$SubItem = Set-UPN -Csv}
				if($Field -eq 'email'){$Email = $SubItem}
				if($Field -eq 'group'){$Group = $SubItem}
				
                
                $User.SubItems.Add($SubItem)
                }
			$lvCSV.Items.Add($User)
			$i++
		}
	}
}
	
		$lvCSV.Items | %{
			
			$Domain = $_.Subitems[1].Text
			$Path = $_.Subitems[2].Text
			$GivenName = $_.Subitems[3].Text
			$Surname = $_.Subitems[4].Text
			$OfficePhone = $_.Subitems[5].Text
			$Title = $_.Subitems[6].Text
			$Description = $_.Subitems[7].Text
			$Department = $_.Subitems[8].Text
			$Company = $_.Subitems[9].Text
			$Email = $_.Subitems[10].Text
	
			$Name = "$GivenName $Surname"

		   
	
		    if($_.Subitems[16].Text -eq $null){$sAMAccountName = Set-sAMAccountName}
		    else{$sAMAccountName = $_.Subitems[16].Text}

            if($_.Subitems[17].Text -eq $null){$userPrincipalName = Set-UPN}
            else{$userPrincipalName = $_.Subitems[17].Text}
		
            if($_.Subitems[18].Text -eq $null){$DisplayName = Set-DisplayName}
            else{$DisplayName = $_.Subitems[18].Text}

			$AccountPassword = $_.Subitems[15].Text | ConvertTo-SecureString -AsPlainText -Force
	
			$User = @{
			    Name = $Name
			    GivenName = $GivenName
			    Surname = $Surname
			    Path = $Path
			    samAccountName = $samAccountName
			    userPrincipalName = $userPrincipalName
			    DisplayName = $DisplayName
			    AccountPassword = $AccountPassword
			    ChangePasswordAtLogon = $False
			    Enabled = $Enabled
			    OfficePhone = $OfficePhone
			    Description = $Description
			    Title = $Title
			    Department = $Department
			    Email = $Email
			    }
			$SB.Text = "Creating new user $sAMAccountName"
            $ADError = $Null
			New-ADUser @User -ErrorVariable ADError
            if ($ADerror){$SB.Text = "[$sAMAccountName] $ADError"}
            else{$SB.Text = "$sAMAccountName created successfully."}
		}
	}
	
	