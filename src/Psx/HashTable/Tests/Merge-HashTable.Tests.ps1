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

Describe 'Merge-HashTable' {
   InModuleScope Psx {

      Context 'When HashTables are given by arguments' {
         It 'Merges HashTables.' {
            $hashTables = @( @{FirstName = 'Tony' }, @{LastName = 'Stark' }, @{DisplayName = 'Tony Stark' }, @{Alias = 'Iron Man' } )

            $mergedHashTable = Merge-HashTable -HashTable $hashTables

            $mergedHashTable | Should -BeOfType [HashTable]
            $expectedResult = @{Alias = 'Iron Man' ; DisplayName = 'Tony Stark' ; FirstName = 'Tony' ; LastName = 'Stark' }
            Compare-HashTable -ReferenceHashTable $expectedResult -DifferenceHashTable $mergedHashTable | Should -BeNullOrEmpty
         }
         It 'Does not overwrite merged properties by default.' {
            $hashTables = @( @{FirstName = 'Tony' }, @{FirstName = 'Peter' }, @{FirstName = 'Natacha' }, @{Alias = 'Iron Man' } )

            $mergedHashTable = Merge-HashTable -HashTable $hashTables

            $mergedHashTable | Should -BeOfType [HashTable]
            $expectedResult = @{Alias = 'Iron Man' ; FirstName = 'Tony' }
            Compare-HashTable -ReferenceHashTable $expectedResult -DifferenceHashTable $mergedHashTable -Verbose | Should -BeNullOrEmpty
         }
      }

      Context 'When HashTables are given by pipeline' {
         It 'Merges HashTables.' {
            $hashTables = @( @{FirstName = 'Tony' }, @{LastName = 'Stark' }, @{DisplayName = 'Tony Stark' }, @{Alias = 'Iron Man' } )

            $mergedHashTable = $hashTables | Merge-HashTable

            $mergedHashTable | Should -BeOfType [HashTable]
            $expectedResult = @{Alias = 'Iron Man' ; DisplayName = 'Tony Stark' ; FirstName = 'Tony' ; LastName = 'Stark' }
            Compare-HashTable -ReferenceHashTable $expectedResult -DifferenceHashTable $mergedHashTable | Should -BeNullOrEmpty
         }
         It 'Returns an empty HashTable if there are no HashTables to merge.' {
            $hashTables = @()

            $mergedHashTable = $hashTables | Merge-HashTable

            $mergedHashTable | Should -BeOfType [HashTable]
            $expectedResult = @{ }
            Compare-HashTable -ReferenceHashTable $expectedResult -DifferenceHashTable $mergedHashTable | Should -BeNullOrEmpty
         }
         It 'Does not overwrite merged properties by default.' {
            $hashTables = @( @{FirstName = 'Tony' }, @{FirstName = 'Peter' }, @{FirstName = 'Natacha' }, @{Alias = 'Iron Man' } )

            $mergedHashTable = $hashTables | Merge-HashTable

            $mergedHashTable | Should -BeOfType [HashTable]
            $expectedResult = @{Alias = 'Iron Man' ; FirstName = 'Tony' }
            Compare-HashTable -ReferenceHashTable $expectedResult -DifferenceHashTable $mergedHashTable | Should -BeNullOrEmpty
         }
         It 'Overwrites merged properties if forced to.' {
            $hashTables = @( @{FirstName = 'Tony' }, @{FirstName = 'Natacha' }, @{FirstName = 'Peter' }, @{Alias = 'Spider Man' } )

            $mergedHashTable = $hashTables | Merge-HashTable -Force

            $mergedHashTable | Should -BeOfType [HashTable]
            $expectedResult = @{Alias = 'Spider Man' ; FirstName = 'Peter' }
            Compare-HashTable -ReferenceHashTable $expectedResult -DifferenceHashTable $mergedHashTable | Should -BeNullOrEmpty
         }
         It 'Overwrites merged properties if forced to unless properties are excluded.' {
            $hashTables = @( @{Path = 'fn' ; FirstName = 'Tony' }, @{Path = 'ln' ; LastName = 'Stark' }, @{Path = 'dn' ; DisplayName = 'Tony Stark' }, @{Path = 'an' ; Alias = 'Iron Man' } )

            $mergedHashTable = $hashTables | Merge-HashTable -Exclude 'Path' -Force

            $mergedHashTable | Should -BeOfType [HashTable]
            $expectedResult = @{Alias = 'Iron Man' ; DisplayName = 'Tony Stark' ; FirstName = 'Tony' ; LastName = 'Stark' ; Path = 'fn' }
            Compare-HashTable -ReferenceHashTable $expectedResult -DifferenceHashTable $mergedHashTable | Should -BeNullOrEmpty
         }
         It 'Is verbose about every overwritten property.' {
            Mock -CommandName Write-Verbose
            $hashTables = @( @{FirstName = 'Tony' }, @{FirstName = 'Natacha' }, @{FirstName = 'Peter' }, @{Alias = 'Spider Man' } )

            $hashTables | Merge-HashTable -Force -Verbose

            Assert-MockCalled -Scope It -CommandName Write-Verbose -ParameterFilter { $Message -eq 'Property ''FirstName'' has been overwritten because it has been defined multiple times.' } -Exactly 2
            Assert-MockCalled -Scope It -CommandName Write-Verbose -Exactly 2
         }
      }

   }
}
