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
.Synopsis
    Resolve "Action Preferences" from the caller's scope.
.DESCRIPTION
    Script module functions do not automatically inherit their caller's action preferences, but they can be obtained
    through the $PSCmdlet variable in Advanced Functions. This function is a helper function for any script module
    Advanced Function: by passing in the values of $PSCmdlet and $ExecutionContext.SessionState,
    Resolve-ActionPreference will propagate the caller's action preferences locally.
.PARAMETER Cmdlet
    The $PSCmdlet object from a script module Advanced Function.
.PARAMETER SessionState
    The $ExecutionContext.SessionState object from a script module Advanced Function. This is how the
    Resolve-ActionPreference function sets action preference variables in its callers' scope, even if that caller
    is in a different script module.
.PARAMETER Actions
    Optional array of action parameter names to retrieve from the caller's scope. Default is to retrieve
    all the following action preferences: Confirm, ErrorAction, InformationAction, Verbose, WarningAction, WhatIf.
.EXAMPLE
    Resolve-ActionPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    Imports the default PowerShell preference variables from the caller into the local scope.
.EXAMPLE
    Resolve-ActionPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -Actions ErrorAction, InformationAction

    Resolve only the ErrorAction and InformationAction preference variables into the local scope.
.INPUTS
    None. This function does not consume pipeline input.
.OUTPUTS
    None. This function does not produce pipeline output.
.LINK
    about_Preference_Variables
.LINK
    see https://gallery.technet.microsoft.com/Inherit-Preference-82343b9d
    see https://powershell.org/2014/01/getting-your-script-module-functions-to-inherit-preference-variables-from-the-caller/
.NOTES
    © 2020 be.stateless.
#>
function Resolve-ActionPreference {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_.GetType().FullName -eq 'System.Management.Automation.PSScriptCmdlet' })]
        [System.Management.Automation.PSCmdlet]
        $Cmdlet,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.SessionState]
        $SessionState,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Confirm', 'ErrorAction', 'InformationAction', 'Verbose', 'WarningAction', 'WhatIf')]
        [string[]]
        $Actions = @('Confirm', 'ErrorAction', 'InformationAction', 'Verbose', 'WarningAction', 'WhatIf')
    )
    $Actions | ForEach-Object -Process {
        if (-not $Cmdlet.MyInvocation.BoundParameters.ContainsKey($_)) {
            $actionPreference = $Cmdlet.SessionState.PSVariable.Get($preferenceVariables.$_)
            if ($SessionState -eq $ExecutionContext.SessionState) {
                Set-Variable -Scope 1 -Name $actionPreference.Name -Value $actionPreference.Value -Force -Confirm:$false -WhatIf:$false
            } else {
                $SessionState.PSVariable.Set($actionPreference.Name, $actionPreference.Value)
            }
        }
    }
}

$script:preferenceVariables = @{
    'Confirm'           = 'ConfirmPreference'
    'ErrorAction'       = 'ErrorActionPreference'
    'InformationAction' = 'InformationPreference'
    'Verbose'           = 'VerbosePreference'
    'WarningAction'     = 'WarningPreference'
    'WhatIf'            = 'WhatIfPreference'
}