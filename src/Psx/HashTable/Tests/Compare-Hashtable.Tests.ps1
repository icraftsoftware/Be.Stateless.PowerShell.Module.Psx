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

Describe 'Compare-Hashtable' {
   InModuleScope Psx {

      Context 'When both are empty' {
         It 'Returns nothing.' {
            $left, $right = @{ }, @{ }
            Compare-HashTable -ReferenceHashTable $left -DifferenceHashTable $right | Should -BeNullOrEmpty
         }
      }

      Context 'When both have one identical entry' {
         It 'Returns nothing.' {
            $left, $right = @{ a = 'x' }, @{ a = 'x' }
            Compare-HashTable $left $right | Should -BeNullOrEmpty
         }
      }

      Context 'When reference contains a key with a null value' {
         It 'Returns ''a: <''.' {
            $left, $right = @{ a = $null }, @{ }

            [object[]]$result = Compare-HashTable $left $right

            $result.Length | Should -Be 1
            $result.Key | Should -Be 'a'
            $result.ReferenceValue | Should -BeNullOrEmpty
            $result.SideIndicator | Should -Be '<'
            $result.DifferenceValue | Should -BeNullOrEmpty
         }
      }

      Context 'When difference contains a key with a null value' {
         It 'Returns ''a: >''.' {
            $left, $right = @{ }, @{ a = $null }

            [object[]]$result = Compare-HashTable $left $right

            $result.Length | Should -Be 1
            $result.Key | Should -Be 'a'
            $result.ReferenceValue | Should -BeNullOrEmpty
            $result.SideIndicator | Should -Be '>'
            $result.DifferenceValue | Should -BeNullOrEmpty
         }
      }

      Context 'When both contain various stuff' {
         BeforeAll {
            $left = @{ a = 1 ; b = 2 ; c = 3 ; f = $null ; g = 6 ; k = $null }
            $right = @{ b = 2 ; c = 4 ; e = 5 ; f = $null ; g = $null ; k = 7 }
            $results = Compare-HashTable $left $right
         }
         It 'Contains 5 differences.' {
            $results.Length | Should -Be 5
         }
         It 'Returns ''a: 1 <''.' {
            $result = $results | Where-Object { $_.Key -eq 'a' }
            $result.ReferenceValue | Should -Be 1
            $result.SideIndicator | Should -Be '<'
            $result.DifferenceValue | Should -BeNullOrEmpty
         }
         It 'Returns ''c: 3 <> 4''.' {
            $result = $results | Where-Object { $_.Key -eq 'c' }
            $result.ReferenceValue | Should -Be 3
            $result.SideIndicator | Should -Be '<>'
            $result.DifferenceValue | Should -Be 4
         }
         It 'Returns ''e: > 5.''' {
            $result = $results | Where-Object { $_.Key -eq 'e' }
            $result.ReferenceValue | Should -BeNullOrEmpty
            $result.SideIndicator | Should -Be '>'
            $result.DifferenceValue | Should -Be 5
         }
         It 'Returns ''g: 6 <>''.' {
            $result = $results | Where-Object { $_.Key -eq 'g' }
            $result.ReferenceValue | Should -Be 6
            $result.SideIndicator | Should -Be '<>'
            $result.DifferenceValue | Should -BeNullOrEmpty
         }
         It 'Returns ''k: <> 7''.' {
            $result = $results | Where-Object { $_.Key -eq 'k' }
            $result.ReferenceValue | Should -BeNullOrEmpty
            $result.SideIndicator | Should -Be '<>'
            $result.DifferenceValue | Should -Be 7
         }
      }

   }
}