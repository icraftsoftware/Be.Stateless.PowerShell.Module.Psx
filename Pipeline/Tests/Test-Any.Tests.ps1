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

Import-Module -Name $PSScriptRoot\..\Pipeline -Force

Describe 'Test-Any' {
    InModuleScope Pipeline {
        It 'Returns false for empty array.' {
            @() | Test-Any | Should -Be $false
        }
        It 'Returns false for nested empty array.' {
            @( @() ) | Test-Any | Should -Be $false
        }
        It 'Returns true for array of arrays, even empty.' {
            @( @() , @() ) | Test-Any | Should -Be $true
        }
        It 'Returns true for $null.' {
            $null | Test-Any | Should -Be $true
        }
        It 'Returns true for array with $null.' {
            @( $null , @() ) | Test-Any | Should -Be $true
        }
        It 'Works with arguments too.' {
            Test-Any -InputObject @( @() , @() ) | Should -Be $true
        }
    }
}
