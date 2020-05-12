#region Copyright & License

# Copyright © 2022 François Chabot
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

Describe 'Bug related to HashTable that appeared with PowerShell 7.0' {
   It 'Throws an exception due a bug present in PowerShell 7.0 related to HashTable.' {
      # this will throw in PowerShell 7.0, see https://github.com/PowerShell/PowerShell/issues/11094
      { @{FirstName = 'Tony' } | Select-Object -ExpandProperty Keys -ErrorAction Stop } | Should -Not -Throw
   }
}