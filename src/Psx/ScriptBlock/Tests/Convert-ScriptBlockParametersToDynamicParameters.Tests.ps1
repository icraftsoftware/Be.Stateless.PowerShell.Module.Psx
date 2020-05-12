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

Import-Module -Name $PSScriptRoot\..\..\Psx.psd1 -Force

Describe 'Convert-ScriptBlockParametersToDynamicParameters' {
   InModuleScope Psx {
      It 'Converts simple parameters.' {
         $sb = [scriptblock]::Create(@'
[CmdletBinding()]
param(
   [string]
   $Configuration = 'Debug'
)
'@)
         $dp = Convert-ScriptBlockParametersToDynamicParameters -ScriptBlock $sb

         $dp | Should -Not -BeNullOrEmpty
         $dp | Should -BeOfType [System.Management.Automation.RuntimeDefinedParameterDictionary]
         $dp.Count | Should -BeExactly 1
         $dp.Configuration | Should -BeOfType [System.Management.Automation.RuntimeDefinedParameter]
         $dp.Configuration.Attributes | Should -BeNullOrEmpty
         $dp.Configuration.ParameterType.UnderlyingSystemType | Should -BeExactly ([string].UnderlyingSystemType)
         $dp.Configuration.Value | Should -BeNullOrEmpty
      }
      It 'Converts ParameterAttribute.' {
         $sb = [scriptblock]::Create(@'
[CmdletBinding()]
param(
   [Parameter(Mandatory = $false, HelpMessage = 'File Layout Configuration')]
   [string]
   $Configuration = 'Debug'
)
'@)
         $dp = Convert-ScriptBlockParametersToDynamicParameters -ScriptBlock $sb

         $dp.Count | Should -BeExactly 1
         $dp.Configuration | Should -BeOfType [System.Management.Automation.RuntimeDefinedParameter]
         $dp.Configuration.Attributes | Should -Not -BeNullOrEmpty
         $dp.Configuration.Attributes.Count | Should -BeExactly 1
         $dp.Configuration.Attributes[0] | Should -BeOfType [System.Management.Automation.ParameterAttribute]
         $dp.Configuration.Attributes[0].Mandatory | Should -BeFalse
         $dp.Configuration.Attributes[0].HelpMessage | Should -BeExactly 'File Layout Configuration'
         $dp.Configuration.Value | Should -BeNullOrEmpty
      }
      It 'Converts ValidateSetAttribute.' {
         $sb = [scriptblock]::Create(@'
[CmdletBinding()]
param(
   [Parameter(Mandatory = $false, HelpMessage = 'File Layout Configuration')]
   [ValidateSet('Debug', 'Release', 'Package')]
   [string]
   $Configuration = 'Debug'
)
'@)
         $dp = Convert-ScriptBlockParametersToDynamicParameters -ScriptBlock $sb

         $dp.Count | Should -BeExactly 1
         $dp.Configuration | Should -BeOfType [System.Management.Automation.RuntimeDefinedParameter]
         $dp.Configuration.Attributes | Should -Not -BeNullOrEmpty
         $dp.Configuration.Attributes.Count | Should -BeExactly 2
         $dp.Configuration.Attributes[1] | Should -BeOfType [System.Management.Automation.ValidateSetAttribute]
         $dp.Configuration.Attributes[1].ValidValues | Should -Be @('Debug', 'Release', 'Package')
         $dp.Configuration.Value | Should -BeNullOrEmpty
      }
      It 'Converts switch paramater.' {
         $sb = [scriptblock]::Create(@'
[CmdletBinding()]
param(
   [switch]
   $IncludeTestArtifacts
)
'@)
         $dp = Convert-ScriptBlockParametersToDynamicParameters -ScriptBlock $sb

         $dp.Count | Should -BeExactly 1
         $dp.IncludeTestArtifacts | Should -BeOfType [System.Management.Automation.RuntimeDefinedParameter]
         $dp.IncludeTestArtifacts.ParameterType.UnderlyingSystemType | Should -BeExactly ([switch].UnderlyingSystemType)
         $dp.IncludeTestArtifacts.Value | Should -BeNullOrEmpty
      }
   }
}
