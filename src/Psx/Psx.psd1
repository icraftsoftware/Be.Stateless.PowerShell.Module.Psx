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

@{
   RootModule            = 'Psx.psm1'
   ModuleVersion         = '2.1.0.0'
   GUID                  = '217de01f-f2e1-460a-99a4-b8895d0dd071'
   Author                = 'François Chabot'
   CompanyName           = 'be.stateless'
   Copyright             = '(c) 2012 - 2022 be.stateless. All rights reserved.'
   Description           = 'Useful PowerShell functions and commands.'
   ProcessorArchitecture = 'None'
   PowerShellVersion     = '5.0'
   NestedModules         = @()
   RequiredModules       = @()

   AliasesToExport       = @('aka')
   CmdletsToExport       = @()
   FunctionsToExport     = @(
      # ActionPreference.ps1
      'Resolve-ActionPreference',
      # Alias.ps1
      'Get-CommandAlias',
      # Bitness.ps1
      'Assert-32bitProcess',
      'Assert-64bitProcess',
      'Test-32bitArchitecture',
      'Test-32bitProcess',
      'Test-64bitArchitecture',
      'Test-64bitProcess',
      # HashTable.ps1
      'Compare-HashTable',
      'Merge-HashTable',
      # Object.ps1
      'Use-Object',
      # Pipeline.ps1
      'Test-Any',
      'Test-None',
      # ScriptBlock.ps1
      'Convert-ScriptBlockParametersToDynamicParameters',
      'Invoke-ScriptBlock',
      # Uac.ps1
      'Assert-Elevated',
      'Test-Elevated'
   )
   VariablesToExport     = @()
   PrivateData           = @{
      PSData = @{
         Tags       = @('be.stateless.be', 'icraftsoftware', 'Alias', 'HashTable', 'Pipeline', 'PowerShell', 'Utilities', 'UAC')
         LicenseUri = 'https://github.com/icraftsoftware/Be.Stateless.PowerShell.Module.Psx/blob/master/LICENSE'
         ProjectUri = 'https://github.com/icraftsoftware/Be.Stateless.PowerShell.Module.Psx'
         # ReleaseNotes = ''
      }
   }
}
