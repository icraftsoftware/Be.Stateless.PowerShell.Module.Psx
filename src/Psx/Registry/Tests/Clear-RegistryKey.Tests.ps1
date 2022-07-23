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

Describe 'Clear-RegistryKey' {
   InModuleScope Psx {

      Context 'When keys do not exist.' {
         It 'Does nothing.' {
            Test-Path -Path 'TestRegistry:\Key1' | Should -BeFalse
            { Clear-RegistryKey -Key 'TestRegistry:\Key1\Key1.1' } | Should -Not -Throw
         }
      }

      Context 'When keys and ancestors exist and are empty.' {
         BeforeAll {
            New-Item -Path TestRegistry:\ -Name 'Key2a\Key2.1\Key2.2\Key2.3' -Force | Out-Null
            New-Item -Path TestRegistry:\ -Name 'Key2b\Key2.1\Key2.2\Key2.3' -Force | Out-Null
         }
         It 'Deletes the key but not its ancestors.' {
            Test-Path -Path 'TestRegistry:\Key2a\Key2.1\Key2.2\Key2.3' | Should -BeTrue
            { Clear-RegistryKey -Key 'TestRegistry:\Key2a\Key2.1\Key2.2\Key2.3' } | Should -Not -Throw
            Test-Path -Path 'TestRegistry:\Key2a\Key2.1\Key2.2\Key2.3' | Should -BeFalse
            Test-Path -Path 'TestRegistry:\Key2a\Key2.1\Key2.2' | Should -BeTrue
            Test-Path -Path 'TestRegistry:\Key2a\Key2.1' | Should -BeTrue
         }
         It 'Recursively deletes the key and its empty ancestors but not the root.' {
            Test-Path -Path 'TestRegistry:\Key2b\Key2.1\Key2.2\Key2.3' | Should -BeTrue
            { Clear-RegistryKey -Key 'TestRegistry:\Key2b\Key2.1\Key2.2\Key2.3' -Recurse } | Should -Not -Throw
            Test-Path -Path 'TestRegistry:\Key2b\Key2.1\Key2.2\Key2.3' | Should -BeFalse
            Test-Path -Path 'TestRegistry:\Key2b\Key2.1\Key2.2' | Should -BeFalse
            Test-Path -Path 'TestRegistry:\Key2b\Key2.1' | Should -BeFalse
            Test-Path -Path 'TestRegistry:\Key2b' | Should -BeTrue
         }
      }

      Context 'When keys and ancestors exist and are not empty.' {
         BeforeAll {
            New-Item -Path TestRegistry:\ -Name 'Key3a\Key3.1\Key3.2' -Force | Out-Null
            New-ItemProperty -Path 'TestRegistry:\Key3a\Key3.1\Key3.2' -Name 'InstallPath' -Value 'C:\Program Files\MyApplication' | Out-Null

            New-Item -Path TestRegistry:\ -Name 'Key3b\Key3.1\Key3.2\Key3.3' -Force | Out-Null
            New-ItemProperty -Path 'TestRegistry:\Key3b\Key3.1' -Name 'InstallPath' -Value 'C:\Program Files\MyApplication' | Out-Null
         }
         It 'Does not delete a non-empty key.' {
            Test-RegistryEntry -Key 'TestRegistry:\Key3a\Key3.1\Key3.2' -Entry 'InstallPath' | Should -BeTrue
            { Clear-RegistryKey -Key 'TestRegistry:\Key3a\Key3.1\Key3.2' } | Should -Not -Throw
            Test-RegistryEntry -Key 'TestRegistry:\Key3a\Key3.1\Key3.2' -Entry 'InstallPath' | Should -BeTrue
         }
         It 'Recursively deletes the empty key and ancestors but stops at first non-empty ancestor.' {
            Test-Path -Path 'TestRegistry:\Key3b\Key3.1\Key3.2\Key3.3' | Should -BeTrue
            Test-RegistryEntry -Key 'TestRegistry:\Key3b\Key3.1' -Entry 'InstallPath' | Should -BeTrue
            { Clear-RegistryKey -Key 'TestRegistry:\Key3b\Key3.1\Key3.2\Key3.3' -Recurse } | Should -Not -Throw
            Test-Path -Path 'TestRegistry:\Key3b\Key3.1\Key3.2\Key3.3' | Should -BeFalse
            Test-Path -Path 'TestRegistry:\Key3b\Key3.1\Key3.2' | Should -BeFalse
            Test-Path -Path 'TestRegistry:\Key3b\Key3.1' | Should -BeTrue
         }
      }

   }
}