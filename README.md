# Create-Batch
Puts pipeline items into one or more batches

## Syntax
```JavaScript
Create-Batch
    [[-Size] <ulong>]
    [-InputObject] <Object>
    [<CommonParameters>]
```

## Description
This cmdlet puts the items in the pipeline into batches of a sertain ammount.

## Examples
### Example 1:
```PowerShell
0..9 |Create-Batch -Size 3 |ForEach-Object { "$_" }
0 1 2
3 4 5
6 7 8
9

This example sents batches of 3 items down the PowerShell pipeline.
```
### Example 2:
```PowerShell
0..9 |Create-Batch -Size 3 |Create-Batch |Create-Batch -Size 4 |ForEach-Object { "$_" }
0 1 2 3
4 5 6 7
8 9

This example removes the batches of 3 items and creates new batches of 4 items.
```
### Example 3:
```PowerShell
Get-Process |Create-Batch |Set-Content .\Process.txt

This creates a single batch (array) containing all the itams
The result of this statement is the same as: `Get-Process |Set-Content .\Process.txt`
But note that this appears (for yet unknown reason) **about twice as fast**.
See: https://github.com/PowerShell/PowerShell/issues/18070
```
## Parameter
#### <a id="-size">**`-Size <UInt64>`**</a>
```PowerShell
The size of the batches (arrays) to be created.
If the `-Size` parameter is omitted (or `0`) all current batches will be removed.
Note that only the top arrays (batches) will be flattened.
```

<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.UInt64">UInt64</a></td></tr>
<tr><td>Position:</td><td>0</td></tr>
<tr><td>Default value:</td><td><code>[UInt64]::MaxValue</code></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

#### <a id="-inputobject">**`-InputObject <Object>`**</a>
```PowerShell
The list of items to be put into batches (arrays)
```

<table>
<tr><td>Type:</td><td><a href="https://docs.microsoft.com/en-us/dotnet/api/System.Object">Object</a></td></tr>
<tr><td>Position:</td><td>1</td></tr>
<tr><td>Default value:</td><td></td></tr>
<tr><td>Accept pipeline input:</td><td>False</td></tr>
<tr><td>Accept wildcard characters:</td><td>False</td></tr>
</table>

## Inputs
A list of items

## Outputs
One or more arrays (`Object[]`) contain the input items

## Related Links
