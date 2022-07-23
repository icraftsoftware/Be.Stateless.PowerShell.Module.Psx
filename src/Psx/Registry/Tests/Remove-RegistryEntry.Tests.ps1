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

Describe 'Remove-RegistryEntry' {
   InModuleScope Psx {

      Context 'When neither key nor entry exist.' {
         It 'Does nothing.' {
            Test-RegistryEntry -Key 'TestRegistry:\Key1' -Entry 'InstallPath' | Should -BeFalse
            { Remove-RegistryEntry -Key 'TestRegistry:\Key1' -Entry 'InstallPath' } | Should -Not -Throw
         }
      }

      Context 'When key exists but entry does not.' {
         BeforeAll {
            New-Item -Path TestRegistry:\ -Name 'Key2'
         }
         It 'Does nothing.' {
            Test-RegistryEntry -Key 'TestRegistry:\Key2' -Entry 'InstallPath' | Should -BeFalse
            { Remove-RegistryEntry -Key 'TestRegistry:\Key2' -Entry 'InstallPath' } | Should -Not -Throw
         }
      }

      Context 'When both key and entry exist.' {
         BeforeAll {
            New-Item -Path TestRegistry:\ -Name 'Key3'
            New-ItemProperty -Path 'TestRegistry:\Key3' -Name 'InstallPath' -Value 'C:\Program Files\MyApplication'
         }
         It 'Deletes the entry.' {
            Test-RegistryEntry -Key 'TestRegistry:\Key3' -Entry 'InstallPath' | Should -BeTrue
            { Remove-RegistryEntry -Key 'TestRegistry:\Key3' -Entry 'InstallPath' } | Should -Not -Throw
            Test-RegistryEntry -Key 'TestRegistry:\Key3' -Entry 'InstallPath' | Should -BeFalse
         }
      }

   }
}