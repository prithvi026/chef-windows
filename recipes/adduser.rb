#
# Cookbook:: user
# Recipe:: adduser
#
# Copyright:: 2021, The Authors, All Rights Reserved.

script = <<-EOH
$dsam = 'System.DirectoryServices.AccountManagement'
$user = 'cent'
$rtn = [reflection.assembly]::LoadWithPartialName($dsam)
$context = New-Object 'System.DirectoryServices.AccountManagement.PrincipalContext'('machine', 'localhost')
$gp = 'System.DirectoryServices.AccountManagement.GroupPrincipal' -as [type]
$find = $gp::FindByIdentity($context, 'Administrators')
return ($find.Members | where SamAccountName -eq $user).Length -gt 0
EOH

group "administrators" do

  members ['EXAMPLE\cent']
  only_if {
    result = powershell_out(script)
    result.stdout.chop == "False"
  }
 action [:modify]
  append true
end