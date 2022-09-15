# Create-Batch
Puts pipeline items into one or more batches
## [Syntax](#syntax)
```PowerShell
Create-Batch
    [-Size <UInt64>]
    [[-InputObject] <Object>]
    [<CommonParameters>]
```
## [Description](#description)
 This cmdlet puts the items in the pipeline into batches of a sertain ammount.

## [Examples](exampls)
### Example 1
```PowerShell
0..9 |Create-Batch -Size 3 |ForEach-Object { "$_" }
0 1 2
3 4 5
6 7 8
9
```
 This example sents batches of 3 items down the PowerShell pipeline.

### Example 2
```PowerShell
0..9 |Create-Batch -Size 3 |Create-Batch |Create-Batch -Size 4 |ForEach-Object { "$_" }
0 1 2 3
4 5 6 7
8 9
```
 This example removes the batches of 3 items and creates new batches of 4 items.

### Example 3
```PowerShell
Get-Process |Create-Batch |Set-Content .\Process.txt
```
This creates a single batch (array) containing all the items  
The result of this statement is the same as: `Get-Process |Set-Content .\Process.txt`  
But note that this appears (for yet unknown reason) **about twice as fast**  
even if you partual limit the memory usage by setting e.g. `-Size 10000`.  
See: https://github.com/PowerShell/PowerShell/issues/18070

## [Parameters](#parameters)
### `-Size`
 The size of the batches (arrays) to be created.  
If the `-Size` parameter is omitted (or `0`) all current batches will be removed.  
Note that only the top arrays (batches) will be flattened.

| <!--                    --> | <!-- --> |
| --------------------------- | -------- |
| Type:                       | [UInt64](https://docs.microsoft.com/en-us/dotnet/api/System.UInt64) |
| Position:                   | 1 |
| Default value:              | 18446744073709551615 |
| Accept pipeline input:      | false |
| Accept wildcard characters: | false |
### `-InputObject`
 The list of items to be put into batches (arrays)

| <!--                    --> | <!-- --> |
| --------------------------- | -------- |
| Type:                       | [Object](https://docs.microsoft.com/en-us/dotnet/api/System.Object) |
| Position:                   | 2 |
| Default value:              |  |
| Accept pipeline input:      | true (ByValue) |
| Accept wildcard characters: | false |
## [Inputs](#inputs)
### A list of items
## [Outputs](#outputs)
### One or more arrays (`Object[]`) contain the input items
## [Related Links](#related-links)
* [https://github.com/iRon7/Create-Batch](https://github.com/iRon7/Create-Batch)
