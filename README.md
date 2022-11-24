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
### Example 1: Batches of 3 items
This example sents batches of 3 items down the PowerShell pipeline.

```PowerShell
0..9 |Create-Batch -Size 3 |ForEach-Object { "$_" }
0 1 2
3 4 5
6 7 8
9
```
### Example 2: Resize batches
This example removes the batches of 3 items and creates new batches of 4 items.

```PowerShell
0..9 |Create-Batch -Size 3 |Create-Batch |Create-Batch -Size 4 |ForEach-Object { "$_" }
0 1 2 3
4 5 6 7
8 9
```
### Example 3: Single batch
This creates a single batch (array) containing all the itams
The result of this statement is the same as: `Get-Process |Set-Content .\Process.txt`
But note that this appears (for yet unknown reason) **about twice as fast**.
See: [PowerShell issue `#18070`][1]

```PowerShell
Get-Process |Create-Batch |Set-Content .\Process.txt
```
## Inputs
A list of items

## Outputs
One or more arrays (`Object[]`) contain the input items

## Related Links
* 1: [#18070][1]

[1]: https://github.com/PowerShell/PowerShell/issues/18070 "#18070"
