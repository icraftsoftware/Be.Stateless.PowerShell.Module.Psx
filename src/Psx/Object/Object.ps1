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
   Use and dispose of an object that supports IDisposable.
.DESCRIPTION
   Like the C# using statement, dispose an object after usage that supports IDisposable.
.PARAMETER Object
   The object to use and to be disposed of afterwards.
.PARAMETER Process
   The script block that exercises the object to be disposed of afterwards.
.EXAMPLE
   Using-Object ($streamWriter = New-Object System.IO.StreamWriter("some-file.txt")) {
      $streamWriter.WriteLine('some content.')
   }
.NOTES
   Notice that, unlike in its original source mentioned below, the function is called 'Use-Object', which does
   rely on an approved PowerShell verb, and not 'Using-Object', which does not. See
   https://davewyatt.wordpress.com/2014/04/11/using-object-powershell-version-of-cs-using-statement/
#>
function Use-Object {
   [CmdletBinding()]
   [OutputType([void])]
   param (
      [Parameter(Mandatory = $true)]
      [AllowEmptyString()]
      [AllowEmptyCollection()]
      [AllowNull()]
      [System.IDisposable]
      $Object,

      [Parameter(Mandatory = $true)]
      [scriptblock]
      $Process
   )
   Resolve-ActionPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
   try {
      . $Process
   } finally {
      if ($null -ne $Object) {
         $Object.Dispose()
      }
   }
}
