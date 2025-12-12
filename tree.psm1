function New-FileSizeTransform {
    <#
    .SYNOPSIS
    Creates a file size transformation scriptblock for use with Show-JsonTree.
    
    .DESCRIPTION
    Returns a scriptblock that can be used in the Transform parameter of Show-JsonTree
    to convert numeric byte values into human-readable file sizes (B, KB, MB, GB).
    
    .EXAMPLE
    $transforms = @{
        'size' = New-FileSizeTransform
        'fileSize' = New-FileSizeTransform
    }
    Show-JsonTree -JsonData $json -Transform $transforms
    #>
    return {
        param($value)
        if ($value -eq "Unknown" -or [string]::IsNullOrEmpty($value)) {
            return "Unknown"
        }
        try {
            $sizeInt = [int64]$value
            if ($sizeInt -lt 1KB) { return "$sizeInt B" }
            elseif ($sizeInt -lt 1MB) { return "{0:N1} KB" -f ($sizeInt / 1KB) }
            elseif ($sizeInt -lt 1GB) { return "{0:N1} MB" -f ($sizeInt / 1MB) }
            else { return "{0:N1} GB" -f ($sizeInt / 1GB) }
        } catch {
            return $value
        }
    }
}

function Write-TreeNode {
    param(
        [string]$Text,
        [string]$Prefix = "",
        [bool]$IsLast = $true
    )
    
    if ($IsLast) {
        $connector = "└─"
    }
    else {
        $connector = "├─"
    }
    Write-Output "$Prefix$connector $Text"
}

function Write-JsonObject {
    param(
        [object]$Object,
        [string]$Prefix = "",
        [bool]$IsLast = $true,
        [hashtable]$Transform = @{}
    )
    
    if ($null -eq $Object) {
        return
    }
    
    # Handle different object types
    if ($Object -is [System.Array] -or $Object -is [System.Object[]]) {
        # Handle arrays
        for ($i = 0; $i -lt $Object.Count; $i++) {
            $item = $Object[$i]
            $isLastItem = ($i -eq $Object.Count - 1)
            
            if ($item.PSObject.Properties['name']) {
                # Object has a name property
                Write-TreeNode "$($item.name)" -Prefix $Prefix -IsLast $isLastItem
            }
            else {
                # Object doesn't have a name, use index
                Write-TreeNode "[$i]" -Prefix $Prefix -IsLast $isLastItem
            }
            
            # Recursively process this item
            $newPrefix = if ($isLastItem) { "$Prefix   " } else { "$Prefix│  " }
            Write-JsonObjectProperties -Object $item -Prefix $newPrefix -Transform $Transform
        }
    }
    else {
        # Handle single objects
        if ($Object.PSObject.Properties['name']) {
            Write-TreeNode "$($Object.name)" -Prefix $Prefix -IsLast $IsLast
            $newPrefix = if ($IsLast) { "$Prefix   " } else { "$Prefix│  " }
            Write-JsonObjectProperties -Object $Object -Prefix $newPrefix -Transform $Transform
        }
        else {
            Write-JsonObjectProperties -Object $Object -Prefix $Prefix -Transform $Transform
        }
    }
}

function Write-JsonObjectProperties {
    param(
        [object]$Object,
        [string]$Prefix = "",
        [hashtable]$Transform = @{}
    )
    
    if ($null -eq $Object) {
        return
    }
    
    # Separate properties from collections
    $properties = $Object.PSObject.Properties | Where-Object { 
        $_.Name -ne 'name' -and 
        $_.Value -isnot [System.Array] -and 
        $_.Value -isnot [System.Object[]] -and
        $_.Value -isnot [PSCustomObject]
    }
    $collections = $Object.PSObject.Properties | Where-Object { 
        $_.Value -is [System.Array] -or 
        $_.Value -is [System.Object[]] -or
        $_.Value -is [PSCustomObject]
    }
    
    $totalItems = $properties.Count + $collections.Count
    $currentItem = 0
    
    # Display simple properties first
    foreach ($property in $properties) {
        $currentItem++
        $isLast = ($currentItem -eq $totalItems)
        $value = if ($null -eq $property.Value) { "null" } else { $property.Value.ToString() }
        
        # Apply transform if specified for this property
        if ($Transform.ContainsKey($property.Name) -and $Transform[$property.Name] -is [scriptblock]) {
            try {
                $value = & $Transform[$property.Name] $property.Value
            }
            catch {
                $value = "[Transform Error: $($_.Exception.Message)]"
            }
        }
        
        Write-TreeNode "$($property.Name): $value" -Prefix $Prefix -IsLast $isLast
    }
    
    # Then display collections
    foreach ($collection in $collections) {
        $currentItem++
        $isLast = ($currentItem -eq $totalItems)
        
        if ($null -ne $collection.Value) {
            if ($collection.Value -is [System.Array] -or $collection.Value -is [System.Object[]]) {
                if ($collection.Value.Count -gt 0) {
                    Write-TreeNode "$($collection.Name)" -Prefix $Prefix -IsLast $isLast
                    $newPrefix = if ($isLast) { "$Prefix   " } else { "$Prefix│  " }
                    Write-JsonObject -Object $collection.Value -Prefix $newPrefix -Transform $Transform
                }
            }
            elseif ($collection.Value -is [PSCustomObject]) {
                Write-TreeNode "$($collection.Name)" -Prefix $Prefix -IsLast $isLast
                $newPrefix = if ($isLast) { "$Prefix   " } else { "$Prefix│  " }
                Write-JsonObjectProperties -Object $collection.Value -Prefix $newPrefix -Transform $Transform
            }
        }
    }
}

function Show-JsonTree {
    param(
        [string]$JsonData,
        [hashtable]$Transform = @{}
    )
    
    $items = $JsonData | ConvertFrom-Json
    if (-not $items.Count) {
        $items = @($items)
    }
    
    for ($i = 0; $i -lt $items.Count; $i++) {
        $item = $items[$i]
        
        Write-Output ""

        if ($item.PSObject.Properties['name']) {
            Write-Output "$($item.name)"
            Write-JsonObjectProperties -Object $item -Transform $Transform
        }
        else {
            Write-Output "Item [$i]"
            Write-JsonObjectProperties -Object $item -Transform $Transform
        }
    }
    Write-Output ""
}

Export-ModuleMember -Function Show-JsonTree, New-FileSizeTransform

