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

Describe 'Set-RegistryEntry' {
   InModuleScope Psx {

      Context 'When neither key nor entry exist.' {
         It 'Throws.' {
            Test-RegistryEntry -Key 'TestRegistry:\Key1\SubKey' -Entry 'InstallPath' | Should -BeFalse
            # /!\ ErrorAction, see https://stackoverflow.com/a/49493910/1789441
            { Set-RegistryEntry -Key 'TestRegistry:\Key1\SubKey' -Entry 'InstallPath' -Value 'C:\Program Files\MyApplication' -ErrorAction Stop } | Should -Throw -ExpectedMessage "Cannot find path 'TestRegistry:\Key1\SubKey' because it does not exist."
            Test-RegistryEntry -Key 'TestRegistry:\Key1\SubKey' -Entry 'InstallPath' | Should -BeFalse
         }
         It 'It can force the creation of the key and entry.' {
            Test-RegistryEntry -Key 'TestRegistry:\Key1\SubKey' -Entry 'InstallPath' | Should -BeFalse
            { Set-RegistryEntry -Key 'TestRegistry:\Key1\SubKey' -Entry 'InstallPath' -Value 'C:\Program Files\MyApplication' -Force -ErrorAction Stop } | Should -Not -Throw
            Test-RegistryEntry -Key 'TestRegistry:\Key1\SubKey' -Entry 'InstallPath' | Should -BeTrue
         }
      }

      Context 'When key exists but entry does not.' {
         BeforeAll {
            New-Item -Path TestRegistry:\ -Name 'Key2\SubKey' -Force | Out-Null
         }
         It 'Creates the entry.' {
            Test-RegistryEntry -Key 'TestRegistry:\Key2\SubKey' -Entry 'InstallPath' | Should -BeFalse
            { Set-RegistryEntry -Key 'TestRegistry:\Key2\SubKey' -Entry 'InstallPath' -Value 'C:\Program Files\MyApplication' } | Should -Not -Throw
            Test-RegistryEntry -Key 'TestRegistry:\Key2\SubKey' -Entry 'InstallPath' | Should -BeTrue
         }
      }

      Context 'When both key and entry exist.' {
         BeforeAll {
            New-Item -Path TestRegistry:\ -Name 'Key3\SubKey' -Force | Out-Null
            New-ItemProperty -Path 'TestRegistry:\Key3\SubKey' -Name 'InstallPath' -Value 'old' | Out-Null
         }
         It 'It overwrites the entry.' {
            Test-RegistryEntry -Key 'TestRegistry:\Key3\SubKey' -Entry 'InstallPath' | Should -BeTrue
            { Set-RegistryEntry -Key 'TestRegistry:\Key3\SubKey' -Entry 'InstallPath' -Value 'new' } | Should -Not -Throw
            Test-RegistryEntry -Key 'TestRegistry:\Key3\SubKey' -Entry 'InstallPath' | Should -BeTrue
            Get-ItemPropertyValue -Path 'TestRegistry:\Key3\SubKey' -Name 'InstallPath' | Should -Be 'new'
         }
      }

   }
}