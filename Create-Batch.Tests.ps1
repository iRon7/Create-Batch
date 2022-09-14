#Requires -Modules @{ModuleName="Pester"; ModuleVersion="5.0.0"}

Set-StrictMode -Version Latest

$MyPath = [System.IO.FileInfo]$MyInvocation.MyCommand.Path
$AliasName = [System.IO.Path]::GetFileNameWithoutExtension($MyPath.Name) -Replace '\.Tests$'
$ScriptName = [System.IO.Path]::ChangeExtension($AliasName, 'ps1')
$ScriptPath = Join-Path $MyPath.DirectoryName $ScriptName

Set-Alias -Name $AliasName -Value $ScriptPath

Describe 'Batching' {

    Context 'Numbers' {

        It '-Size 2' {

            $Actual = 0..9 |Create-Batch -Size 2
            $Actual |ConvertTo-Json -Compress |Should -Be '[[0,1],[2,3],[4,5],[6,7],[8,9]]'

            $Actual.Count |Should -Be 5

            $Actual[0] -is [Object[]] |Should -BeTrue
            $Actual[0][0] -is [Int]   |Should -BeTrue
        }

        It '-Size 3' {

            $Actual = 0..9 |Create-Batch -Size 3
            $Actual |ConvertTo-Json -Compress |Should -Be '[[0,1,2],[3,4,5],[6,7,8],[9]]'

            $Actual.Count |Should -Be 4

            $Actual[0] -is [Object[]] |Should -BeTrue
            $Actual[0][0] -is [Int]   |Should -BeTrue
        }
    }

    Context 'PSCustomObject' {

        BeforeAll {

            $List = 1..5 |ForEach-Object { [pscustomobject]@{ id = $_; name = "name$_" } }
        }

        It '-Size 2' {

            $Actual = $List |Create-Batch -Size 2
            $Actual |ConvertTo-Json -Compress |
                Should -Be '[[{"id":1,"name":"name1"},{"id":2,"name":"name2"}],[{"id":3,"name":"name3"},{"id":4,"name":"name4"}],[{"id":5,"name":"name5"}]]'

            $Actual.Count |Should -Be 3

            $Actual[0] -is [Object[]]          |Should -BeTrue
            $Actual[0][0] -is [PSCustomObject] |Should -BeTrue
        }

        It '-Size 3' {

            $Actual = $List |Create-Batch -Size 3
            $Actual |ConvertTo-Json -Compress |
                Should -Be '[[{"id":1,"name":"name1"},{"id":2,"name":"name2"},{"id":3,"name":"name3"}],[{"id":4,"name":"name4"},{"id":5,"name":"name5"}]]'

            $Actual.Count |Should -Be 2

            $Actual[0] -is [Object[]]          |Should -BeTrue
            $Actual[0][0] -is [PSCustomObject] |Should -BeTrue
        }
    }
}

Describe 'Embedding' {

    Context 'Numbers' {

        It '-Size 2 / -Size 3' {

            $Actual = 0..9 |Create-Batch -Size 2 |Create-Batch 3
            $Actual |ConvertTo-Json -Compress |Should -Be '[[[0,1],[2,3],[4,5]],[[6,7],[8,9]]]'

            $Actual.Count |Should -Be 2
            $Actual[0].Count |Should -Be 3
            $Actual[0][0].Count |Should -Be 2
            $Actual[1][1][1] |Should -Be 9
        }
    }
}

Describe 'Unrolling' {

    Context 'Numbers' {

        It 'No -Size (0)' {

            $Actual = 0..9 |Create-Batch -Size 2 |Create-Batch
            $Actual |ConvertTo-Json -Compress |Should -Be '[0,1,2,3,4,5,6,7,8,9]'

            $Actual.Count |Should -Be 10
        }
    }
}

Describe 'Rebatching' {

    Context 'Numbers' {

        It '-Size 2 to -Size 3' {

            $Actual = 0..9 |Create-Batch -Size 2 |Create-Batch |Create-Batch -Size 3
            $Actual |ConvertTo-Json -Compress |Should -Be '[[0,1,2],[3,4,5],[6,7,8],[9]]'

            $Actual.Count |Should -Be 4

            $Actual[0] -is [Object[]] |Should -BeTrue
            $Actual[0][0] -is [Int]   |Should -BeTrue
        }
    }
}

Describe 'Performance' {

    Context 'Set-Content' {

        It 'is twice as fast' {

            $Normal = (Measure-Command {
                1..100000 |Set-Content .\test.txt
            }).TotalSeconds

            $Batched = (Measure-Command {
                1..100000 |Create-Batch 10000 |Set-Content .\test.txt
            }).TotalSeconds
            
            $Batched |Should -BeLessThan ($Normal / 2)
        }
    }
}