#region Copyright & License

# Copyright © 2012 - 2022 François Chabot
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
   Ensures the current process is running in elevated mode.
.DESCRIPTION
   This command will throw if the current process is not running in elevated mode and will silently complete
   otherwise.
.EXAMPLE
   PS> Assert-Elevated
.EXAMPLE
   PS> Assert-Elevated -Verbose
   With the -Verbose switch, this command will confirm this process is running
   in elevated mode.
.NOTES
   © 2022 be.stateless.
#>
function Assert-Elevated {
   [CmdletBinding()]
   [OutputType([void])]
   param()

   Resolve-ActionPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
   if (-not(Test-Elevated)) {
      throw 'A process running in elevated mode is required to run this function!'
   }
   Write-Verbose -Message 'Process is running in elevated mode.'
}

<#
.SYNOPSIS
   Returns whether the current process is running in elevated mode.
.DESCRIPTION
   This command will return $true if the current process is running in elevated mode, or $false otherwise.
.EXAMPLE
   PS> Test-Elevated
.NOTES
   © 2022 be.stateless.
#>
function Test-Elevated {
   [CmdletBinding()]
   [OutputType([bool])]
   param()

   Resolve-ActionPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
   # only if OS is later than XP (i.e. from Vista upward), i.e. if ([System.Environment]::OSVersion.Version.Major -gt 5)
   $wid = [System.Security.Principal.WindowsIdentity]::GetCurrent()
   [bool]( ([Security.Principal.WindowsPrincipal] $wid).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator) )
}
