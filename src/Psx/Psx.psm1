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

# dotsource nested scrips, see https://powershellexplained.com/2017-01-21-powershell-module-continious-delivery-pipeline/#psm1-module
. $PSScriptRoot\ActionPreference\ActionPreference.ps1
. $PSScriptRoot\Alias\Alias.ps1
. $PSScriptRoot\Bitness\Bitness.ps1
. $PSScriptRoot\HashTable\HashTable.ps1
. $PSScriptRoot\Object\Object.ps1
. $PSScriptRoot\Pipeline\Pipeline.ps1
. $PSScriptRoot\ScriptBlock\ScriptBlock.ps1
. $PSScriptRoot\Uac\Uac.ps1
