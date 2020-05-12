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
   Compare two HashTables and returns an array of differences.
.DESCRIPTION
   The Compare-HashTable function computes differences between two HashTables. Results are returned as an array of
   objects with the properties: "Key" (the name of the key for which there is a difference), "SideIndicator" (one of
   "<=", "!=" or "=>"), "ReferenceValue" an "DifferenceValue" (resp. the Reference and Difference value associated
   with the Key).
.PARAMETER ReferenceHashTable
   The HashTable used as a reference for comparison.
.PARAMETER DifferenceHashTable
   The HashTable that is compared to the reference HashTable.
.EXAMPLE
   Compare-HashTable @{ a = 1 ; b = 2 ; c = 3 } @{ b = 2 ; c = 4 ; e = 5}
   Returns a difference for ("3 <="), c (3 "!=" 4) and e ("=>" 5).
.EXAMPLE
   $ReferenceHashTable = @{ a = 1 ; b = 2 ; c = 3 ; f = $null ; g = 6 }
   $DifferenceHashTable = @{ b = 2 ; c = 4 ; e = 5 ; f = $null ; g = $null }
   Compare-HashTable $ReferenceHashTable $DifferenceHashTable
   Returns a difference for a ("3 <="), c (3 "!=" 4), e ("=>" 5) and g (6 "<=").
.NOTES
   See https://gist.github.com/dbroeglin/c6ce3e4639979fa250cf
#>
function Compare-HashTable {
   [CmdletBinding()]
   [OutputType([PSCustomObject[]])]
   param (
      [Parameter(Mandatory = $true)]
      [HashTable]
      $ReferenceHashTable,

      [Parameter(Mandatory = $true)]
      [HashTable]
      $DifferenceHashTable,

      [Parameter(Mandatory = $false, DontShow)]
      [string]
      $Prefix = ''
   )
   Resolve-ActionPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
   $ReferenceHashTable.Keys + $DifferenceHashTable.Keys | Sort-Object -Unique -PipelineVariable key | ForEach-Object -Process {
      $propertyName = if ($Prefix) { "$Prefix.$key" } else { $key }
      if ($ReferenceHashTable.ContainsKey($key) -and !$DifferenceHashTable.ContainsKey($key)) {
         [PSCustomObject]@{Key = $propertyName ; ReferenceValue = $ReferenceHashTable.$key ; SideIndicator = '<' ; DifferenceValue = $null } | Tee-Object -Variable difference
         Write-Verbose -Message $difference
      } elseif (!$ReferenceHashTable.ContainsKey($key) -and $DifferenceHashTable.ContainsKey($key)) {
         [PSCustomObject]@{Key = $propertyName ; ReferenceValue = $null ; SideIndicator = '>' ; DifferenceValue = $DifferenceHashTable.$key } | Tee-Object -Variable difference
         Write-Verbose -Message $difference
      } else {
         $referenceValue, $differenceValue = $ReferenceHashTable.$key, $DifferenceHashTable.$key
         if ($referenceValue -ne $differenceValue) {
            [PSCustomObject]@{Key = $propertyName ; ReferenceValue = $referenceValue ; SideIndicator = '<>' ; DifferenceValue = $differenceValue } | Tee-Object -Variable difference
            Write-Verbose -Message $difference
         }
      }
   }
}

<#
.SYNOPSIS
   Returns a new HashTable which is the merging of the input hash tables.
.DESCRIPTION
   Properties are not overwritten during the merge operation unless forced. Even when forced it is possible to
   provide a list of properties not to overwrite.
.EXAMPLE
.NOTES
   © 2022 be.stateless.
#>
function Merge-HashTable {
   [CmdletBinding()]
   [OutputType([HashTable])]
   param(
      [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
      [HashTable[]]
      $HashTable,

      [Parameter(Mandatory = $false)]
      [string[]]
      $Exclude = @(),

      [Parameter(Mandatory = $false)]
      [switch]
      $Force
   )
   begin {
      Resolve-ActionPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
      $result = @{ }
   }
   process {
      $HashTable | ForEach-Object -Process { $_ } -PipelineVariable currentHashTable | Select-Object -ExpandProperty Keys -PipelineVariable key | ForEach-Object -Process {
         $propertyExists = $result.ContainsKey($key)
         if (-not $propertyExists -or ($Force -and $key -notin $Exclude) ) {
            $result.$key = $currentHashTable.$key
            if ($propertyExists) {
               Write-Verbose -Message "Property '$key' has been overwritten because it has been defined multiple times."
            }
         }
      }
   }
   end {
      $result
   }
}
