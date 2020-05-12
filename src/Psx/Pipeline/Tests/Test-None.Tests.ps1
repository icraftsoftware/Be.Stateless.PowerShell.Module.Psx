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

Describe 'Test-None' {
   InModuleScope Psx {

      Context 'When InputObject is given by argument' {
         It 'Returns true for empty array.' {
            Test-None -InputObject @() | Should -BeTrue
         }
         It 'Returns true for nested empty array.' {
            Test-None -InputObject @( @() ) | Should -BeTrue
         }
         It 'Returns true for array of empty arrays.' {
            Test-None -InputObject @( @() , @() ) | Should -BeTrue
         }
         It 'Returns true for null.' {
            Test-None -InputObject $null | Should -BeTrue
         }
         It 'Returns true for array with null.' {
            Test-None -InputObject @( $null ) | Should -BeTrue
         }
         It 'Returns true for array with null and nested empty array.' {
            Test-None -InputObject @( $null , @() ) | Should -BeTrue
         }
         It 'Returns false for one item.' {
            Test-None -InputObject 1 | Should -BeFalse
         }
         It 'Returns false for array with one item.' {
            Test-None -InputObject @( 1 ) | Should -BeFalse
         }
         It 'Returns false for array with one item and a nested empty array.' {
            Test-None -InputObject @( 1, @() ) | Should -BeFalse
         }
         It 'Returns false for array with one non empty nested array.' {
            Test-None -InputObject @( @( 1 ), @() ) | Should -BeFalse
         }
      }

      Context 'When InputObject is given by pipeline' {
         It 'Returns true for empty array.' {
            @() | Test-None | Should -BeTrue
         }
         It 'Returns true for nested empty array.' {
            @( @() ) | Test-None | Should -BeTrue
         }
         It 'Returns true for array of empty arrays.' {
            @( @() , @() ) | Test-None | Should -BeTrue
         }
         It 'Returns true for null.' {
            $null | Test-None | Should -BeTrue
         }
         It 'Returns true for array with null.' {
            @( $null ) | Test-None | Should -BeTrue
         }
         It 'Returns true for array with null and nested empty array.' {
            @( $null , @() ) | Test-None | Should -BeTrue
         }
         It 'Returns false for one item.' {
            1 | Test-None | Should -BeFalse
         }
         It 'Returns false for array with one item.' {
            @( 1 ) | Test-None | Should -BeFalse
         }
         It 'Returns false for array with one item and a nested empty array.' {
            @( 1, @() ) | Test-None | Should -BeFalse
         }
         It 'Returns false for array with one non empty nested array.' {
            @( @( 1 ), @() ) | Test-None | Should -BeFalse
         }
      }

   }
}
