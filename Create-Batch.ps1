[CmdletBinding()]
param (
    [ULong]$Size,
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]$InputObject
)
begin {
    $Batch = [Collections.Generic.List[object]]::new()
}
process {
    ForEach ($Item in $_) {
        if ($Size -and $Batch.get_Count() -ge $Size) {
            ,$Batch
            $Batch = [Collections.Generic.List[object]]::new()
        }
        $Batch.Add($Item)
    }
}
End {
    if ($Batch.get_Count()) { ,$Batch }
}
