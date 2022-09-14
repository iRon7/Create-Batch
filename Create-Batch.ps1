<#PSScriptInfo
.VERSION 0.0.3
.GUID 19631007-47e4-48d8-a452-84ebbd21d917
.AUTHOR iRon
.COMPANYNAME
.COPYRIGHT
.TAGS Batch Chunck Array Performance
.LICENSE https://github.com/iRon7/Create-Batch/LICENSE
.PROJECTURI https://github.com/iRon7/Create-Batch
.ICON
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES
.PRIVATEDATA
#>

<#
.SYNOPSIS
Puts pipeline items into batches

.DESCRIPTION
This cmdlet puts the items in the pipeline into batches of a sertain ammount.

.INPUTS
A list of items

.OUTPUTS
One or more arrays (`Object[]`) contain the input items

.PARAMETER InputObject
    The list of items to be put into batches (arrays)

.PARAMETER Size
    The size of the batches (arrays) to be created.
    If the `-Size` parameter is omitted (or `0`) all current batches will be removed.
    Note that only the top arrays (batches) will be flattened.

.EXAMPLE
    0..9 |Create-Batch -Size 3 |ForEach-Object { "$_" }
    0 1 2
    3 4 5
    6 7 8
    9

    This example sents batches of 3 items down the PowerShell pipeline.

.EXAMPLE
    0..9 |Create-Batch -Size 3 |Create-Batch |Create-Batch -Size 4 |ForEach-Object { "$_" }
    0 1 2 3
    4 5 6 7
    8 9

    This example removes the batches of 3 items and creates new batches of 4 items.

.EXAMPLE
    Get-Process |Create-Batch -Size 100 |Set-Content .\Process.txt

    Note this appears (for yet unknown reason) to be faster then just
    `Get-Process |Set-Content .\Process.txt`
    See: https://github.com/PowerShell/PowerShell/issues/18070

.LINK
    https://github.com/iRon7/Create-Batch
#>

[CmdletBinding()]
param (
    [ULong]$Size,
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]$InputObject
)
begin {
    $Batch = [Collections.Generic.List[object]]::new() # is faster as [Collections.ObjectModel.Collection[psobject]]
}
process {
    if ($Size) {
        if ($Batch.get_Count() -ge $Size) {
            ,@($Batch)
            $Batch = [Collections.Generic.List[object]]::new()
        }
        $Batch.Add($_)
    }
    else { # if no size is provided, any top array will be unrolled (remove batches)
        $_
    }
}
End {
    if ($Batch.get_Count()) {
        ,@($Batch)
    }
}
