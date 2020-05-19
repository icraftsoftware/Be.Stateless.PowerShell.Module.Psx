#region Copyright & License

# Copyright © 2012 - 2020 François Chabot
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#endregion

Set-StrictMode -Version Latest

<#
.SYNOPSIS
    Given a command name or alias, lists its matching command name and all its aliases.
.DESCRIPTION
    This command will throw if the current process is not a 32 bit process and will silently complete otherwise.
.PARAMETER Command
    The command name or alias for which the command and all its aliases will be returned.
.EXAMPLE
    PS> Get-CommandAlias ls
.EXAMPLE
    PS> Get-CommandAlias Get-ChildItem
.NOTES
    © 2020 be.stateless.
#>
function Get-CommandAlias {
    [CmdletBinding()]
    [OutputType([System.Management.Automation.CommandInfo])]
    param(
        [Parameter(Mandatory = $true, HelpMessage = 'Command or Alias Name.')]
        [string]
        $Name
    )

    Get-Command -Name $Name | ForEach-Object -Process {
        if ($_.CommandType -eq 'Alias') { $_.Definition } else { $_.Name }
    } | ForEach-Object -Process {
        Get-Command -Name $_
        Get-Alias -Definition $_ -ErrorAction SilentlyContinue | Sort-Object
    }
}

<#
 # Main
 #>

Set-Alias aka Get-CommandAlias -Option AllScope -Scope 'Global' -Force
