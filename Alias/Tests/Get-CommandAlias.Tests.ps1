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

Import-Module -Name $PSScriptRoot\..\Alias -Force

Describe 'Get-CommandAlias' {
    InModuleScope Alias {
        It 'Returns itself and aka alias.' {
            $expected = @(Get-Command -Name Get-CommandAlias) + @(Get-Alias -Definition Get-CommandAlias)

            $actual = Get-CommandAlias -Name Get-CommandAlias

            Compare-Object -ReferenceObject $expected -DifferenceObject $actual | Should -BeNullOrEmpty
        }
        It 'Returns itself and aka alias wen invoked via alias too.' {
            $expected = @(Get-Command -Name Get-CommandAlias) + @(Get-Alias -Definition Get-CommandAlias)

            $actual = aka -Name aka

            Compare-Object -ReferenceObject $expected -DifferenceObject $actual | Should -BeNullOrEmpty
        }
        It 'Throws for an unknown command or alias.' {
            { Get-CommandAlias -Name Get-Unknown -ErrorAction Stop } | Should -Throw 'The term ''Get-Unknown'' is not recognized as the name of a cmdlet, function, script file, or operable program.'
        }
    }
}
