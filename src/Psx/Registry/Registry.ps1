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
   Deletes a registry key if it is empty and, if the Recurse switch is used, recursively deletes all its empty ancestor keys, up to but not including the root key.
.DESCRIPTION
   This command deletes a registry key if it is empty and, if the Recurse switch is used, recursively deletes all its empty ancestor keys, up to but not including the
   root key.
.PARAMETER Key
   The name or path of the key.
.PARAMETER Recurse
   Whether to delete this key's empty ancestors as well.
.EXAMPLE
   PS> Clear-RegistryKey -Key HKLM:\SOFTWARE\BizTalk.Factory\BizTalk.Deployment\InstalledManifests
.EXAMPLE
   PS> Clear-RegistryKey -Key HKLM:\SOFTWARE\BizTalk.Factory\BizTalk.Deployment\InstalledManifests -Recurse
.NOTES
   © 2022 be.stateless.
#>
function Clear-RegistryKey {
   [CmdletBinding()]
   [OutputType([void])]
   param(
      [Parameter(Mandatory = $true)]
      [string]
      $Key,

      [Parameter(Mandatory = $false)]
      [switch]
      $Recurse
   )
   Resolve-ActionPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
   # proceeds while this key's parent has a parent and this parent's parent is not the drive, i.e. while not a root path, e.g. HKLM:\SOFTWARE, nor a drive, e.g. HKLM:\
   if ((Test-Path -Path $Key) -and ($i = Get-Item -Path $Key).PSParentPath -and (Get-Item -Path $i.PSParentPath).Name -ne $i.PSDrive.Root) {
      if ((Get-ChildItem -Path $Key | Test-None) -and (Get-ItemProperty -Path $Key | Test-None)) {
         Write-Verbose -Message "Registry clearing removed empty key '$Key'."
         Remove-Item -Path $Key
         if ($Recurse) {
            Clear-RegistryKey -Key (Split-Path -Path $Key -Parent) -Recurse
         }
      } else {
         Write-Verbose -Message "Registry clearing skipped non empty key '$Key'."
      }
   }
}

<#
.SYNOPSIS
   Gets the value of one entry under a specified registry key.
.DESCRIPTION
   This command gets the current value of a given entry located under a given registry key. It does not fail like the Get-ItemPropertyValue command if the key or entry
   does not exist and returns $null instead.
.PARAMETER Key
   The name or path of the key.
.PARAMETER Entry
   The name of the entry.
.EXAMPLE
   PS> Get-RegistryEntry -Key HKLM:\SOFTWARE\BizTalk.Factory\BizTalk.Deployment\InstalledManifests -Entry $Manifest.Properties.Name
.NOTES
   © 2022 be.stateless.
#>
function Get-RegistryEntry {
   [CmdletBinding()]
   [OutputType([object])]
   param(
      [Parameter(Position = 0, Mandatory = $true)]
      [ValidateNotNullOrEmpty()]
      [string]
      $Key,

      [Parameter(Position = 1, Mandatory = $true)]
      [ValidateNotNullOrEmpty()]
      [string]
      $Entry
   )
   Resolve-ActionPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
   if (Test-RegistryEntry -Key $Key -Entry $Entry) {
      Get-ItemPropertyValue -Path $Key -Name $Entry
   }
}

<#
.SYNOPSIS
   Deletes an entry under a registry key.
.DESCRIPTION
   This command deletes an entry under a registry key.
.PARAMETER Key
   The name or path of the key.
.PARAMETER Entry
   The name of the entry.
.EXAMPLE
   PS> Remove-RegistryEntry -Key HKLM:\SOFTWARE\BizTalk.Factory\BizTalk.Deployment\InstalledManifests -Entry $Manifest.Properties.Name
.NOTES
   © 2022 be.stateless.
#>
function Remove-RegistryEntry {
   [CmdletBinding()]
   [OutputType([void])]
   param(
      [Parameter(Position = 0, Mandatory = $true)]
      [ValidateNotNullOrEmpty()]
      [string]
      $Key,

      [Parameter(Position = 1, Mandatory = $true)]
      [ValidateNotNullOrEmpty()]
      [string]
      $Entry
   )
   Resolve-ActionPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
   if (Test-RegistryEntry -Key $Key -Entry $Entry) {
      Remove-ItemProperty -Path $Key -Name $Entry
   }
}

<#
.SYNOPSIS
   Creates or changes the value of an entry under a registry key.
.DESCRIPTION
   This command creates or changes the value of an entry under a registry key. This commands can also create a new key if it does not exist and the Force switch is
   used.
.PARAMETER Key
   The name or path of the key to create or open.
.PARAMETER Entry
   The name of the entry.
.PARAMETER Value
   The data to be stored.
.PARAMETER PropertyType
   The registry data type to use when storing the data.  The acceptable values for this parameter are:
   - Binary: Specifies binary data in any form. Used for REG_BINARY values.
   - DWord: Specifies a 32-bit binary number. Used for REG_DWORD values.
   - QWord: Specifies a 64-bit binary number. Used for REG_QWORD values.
   - String: Specifies a null-terminated string. Used for REG_SZ values.
   - MultiString: Specifies an array of null-terminated strings terminated by two null characters. Used for REG_MULTI_SZ values.
   - ExpandString: Specifies a null-terminated string that contains unexpanded references to environment variables that are expanded when the value is retrieved.
     Used for REG_EXPAND_SZ values.
   - Unknown: Indicates an unsupported registry data type, such as REG_RESOURCE_LIST values.
.PARAMETER Force
   Whether to create a new registry key if it does not exist.
.EXAMPLE
   PS> Set-RegistryEntry -Key HKLM:\SOFTWARE\BizTalk.Factory\BizTalk.Deployment\InstalledManifests -Entry $Manifest.Properties.Name -Value $Manifest.Properties.Path
.EXAMPLE
   PS> Set-RegistryEntry -Key HKLM:\SOFTWARE\Key -Entry name -Value 12 -PropertyType DWord -Force
.NOTES
   © 2022 be.stateless.
#>
function Set-RegistryEntry {
   [CmdletBinding()]
   [OutputType([void])]
   param(
      [Parameter(Position = 0, Mandatory = $true)]
      [ValidateNotNullOrEmpty()]
      [string]
      $Key,

      [Parameter(Position = 1, Mandatory = $true)]
      [ValidateNotNullOrEmpty()]
      [string]
      $Entry,

      [Parameter(Position = 2, Mandatory = $true)]
      [ValidateNotNullOrEmpty()]
      [object]
      $Value,

      [Parameter(Position = 3, Mandatory = $false)]
      [ValidateNotNullOrEmpty()]
      [Microsoft.Win32.RegistryValueKind]
      $PropertyType,

      [Parameter(Mandatory = $false)]
      [switch]
      $Force
   )
   Resolve-ActionPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
   if (-not(Test-Path -Path $Key) -and $Force) {
      New-Item -Path $Key -Force | Out-Null
   }
   if (Test-RegistryEntry -Key $Key -Entry $Entry) {
      Set-ItemProperty -Path $Key -Name $Entry -Value $Value
   } else {
      New-ItemProperty -Path $Key -Name $Entry -Value $Value -PropertyType $PropertyType | Out-Null
   }
}


<#
.SYNOPSIS
   Determines if an entry under a registry key exists.
.DESCRIPTION
   This command determines if an entry under a registry key exists. It returns $True if the key exists and contains the entry. It returns $False otherwise.
.PARAMETER Key
   The name or path of the key.
.PARAMETER Entry
   The name of the entry.
.EXAMPLE
   PS> Test-RegistryEntry -Key HKLM:\SOFTWARE\BizTalk.Factory\BizTalk.Deployment\InstalledManifests -Entry $Manifest.Properties.Name
.NOTES
   © 2022 be.stateless.
#>
function Test-RegistryEntry {
   [CmdletBinding()]
   [OutputType([bool])]
   param(
      [Parameter(Position = 0, Mandatory = $true)]
      [ValidateNotNullOrEmpty()]
      [string]
      $Key,

      [Parameter(Position = 1, Mandatory = $true)]
      [ValidateNotNullOrEmpty()]
      [string]
      $Entry
   )
   Resolve-ActionPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
   [bool]((Test-Path -Path $Key) -and (Get-Item -Path $Key | Where-Object -Property Property -Contains $Entry))
}
