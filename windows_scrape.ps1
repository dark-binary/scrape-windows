Get-LocalGroupMember Administrators | Out-File admins.txt
Get-LocalGroupMember Users | Out-File users.txt

#Removing Groups from users.txt
(Get-Content '.\users.txt') -notmatch 'Group' | Set-Content '.\users.txt'

#Removing default "Administrator" from admins.txt
(Get-Content '.\admins.txt') -notmatch 'Administrator' | Set-Content '.\admins.txt'

#Removing first two rows from both files
(Get-Content '.\users.txt') -cmatch '\\' | Set-Content '.\users.txt'
(Get-Content '.\admins.txt') -cmatch '\\' | Set-Content '.\admins.txt'

#Removing First segment until user account name
Select-String .\users.txt -Pattern '\\.*' -AllMatches | % { $_.Matches } | % { $_.Value } | Out-File users_temp.txt
Select-String .\admins.txt -Pattern '\\.*' -AllMatches | % { $_.Matches } | % { $_.Value } | Out-File admins_temp.txt

#Removing last segment after user account name
((Get-Content .\users_temp.txt -Raw) -replace 'Local',' ') | Set-Content '.\users_temp.txt'
((Get-Content .\admins_temp.txt -Raw) -replace 'Local',' ') | Set-Content '.\admins_temp.txt'

#Removing blank spaces in both files
Get-Content .\admins_temp.txt | where {$_} | foreach { $_.TrimEnd()} | Out-File admins_main.txt
Get-Content .\users_temp.txt | where {$_} | foreach { $_.TrimEnd()} | Out-File users_main.txt

#Compares two files and picks the odd one out
Compare-Object -ReferenceObject $(Get-Content .\admins_main.txt | Sort-Object -Unique) -DifferenceObject $(Get-Content .\users_main.txt | Sort-Object -Unique) | Where-Object {$PSItem.SideIndicator -eq '=>'} | Select-Object -ExpandProperty inputobject | Out-File nonadmins_main.txt


#initialize count
$users_count = 0
$admins_count = 0
$nonadmins_count = 0

#calculate count
Get-Content .\users_main.txt |%{ $users_count++ }
Get-Content .\admins_main.txt |%{ $admins_count++ }
Get-Content .\nonadmins_main.txt |%{ $nonadmins_count++ }

#variables for storing text
$users = Get-Content .\users_main.txt
$admins = Get-Content .\admins_main.txt
$nonadmins = Get-Content .\nonadmins_main.txt

#variables for writing to output file
$separator = "-----------------------------------------------"
$no_of_users = "Total number of users: "
$list_of__users = "List of all users: "
$no_of_admin_users = "Number of Admin users: "
$list_of_admin_users = "List of Admin users: "
$no_of_nonadmin_users = "Number of Non-Admin users: "
$list_of_nonadmin_users = "List of Non-Admin users: "
$title = "Scrape for Windows: "
$empty_line = "  "

$title | Set-Content output.txt
$separator | Add-Content output.txt
$empty_line | Add-Content output.txt
$no_of_users | Add-Content output.txt
$users_count | Add-Content output.txt
$empty_line | Add-Content output.txt
$list_of__users | Add-Content output.txt
$users | Add-Content output.txt
$empty_line | Add-Content output.txt
$separator | Add-Content output.txt
$empty_line | Add-Content output.txt
$no_of_admin_users | Add-Content output.txt
$admins_count | Add-Content output.txt
$empty_line | Add-Content output.txt
$list_of_admin_users | Add-Content output.txt
$admins | Add-Content output.txt
$empty_line | Add-Content output.txt
$separator | Add-Content output.txt
$empty_line | Add-Content output.txt
$no_of_nonadmin_users | Add-Content output.txt
$nonadmins_count | Add-Content output.txt
$empty_line | Add-Content output.txt
$list_of_nonadmin_users | Add-Content output.txt
$nonadmins | Add-Content output.txt
$empty_line | Add-Content output.txt
$separator | Add-Content output.txt

#Removing unwanted files
Remove-Item .\admins.txt, .\users.txt, .\admins_temp.txt, .\users_temp.txt, .\users_main.txt, .\admins_main.txt, .\nonadmins_main.txt
