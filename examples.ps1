# Show various JSON scenarios with Show-JsonTree
Import-Module .\tree.psm1 -Force

Write-Output "=== Example 1: Single Object with Name ==="
$singleWithName = '{"name": "MyFile", "size": 1024, "type": "document", "readonly": true}'
Show-JsonTree -JsonData $singleWithName

Write-Output "=== Example 2: Single Object without Name ==="
$singleWithoutName = '{"size": 2048, "type": "folder", "permissions": "rwx", "hidden": false}'
Show-JsonTree -JsonData $singleWithoutName

Write-Output "=== Example 3: Array of Simple Objects ==="
$arraySimple = '[
    {"name": "File1", "size": 512},
    {"name": "File2", "size": 1024},
    {"name": "File3", "size": 2048}
]'
Show-JsonTree -JsonData $arraySimple

Write-Output "=== Example 4: Single Complex Object with Nested Properties ==="
$complexSingle = '{
    "name": "ProjectFolder",
    "type": "directory",
    "metadata": {
        "created": "2023-01-01",
        "modified": "2023-12-10",
        "owner": "user123"
    },
    "files": [
        {"name": "readme.txt", "size": 256},
        {"name": "config.json", "size": 512}
    ],
    "tags": ["important", "project", "active"]
}'
Show-JsonTree -JsonData $complexSingle

Write-Output "=== Example 5: Array of Complex Objects ==="
$arrayComplex = '[
    {
        "name": "Server1",
        "status": "running",
        "config": {"port": 8080, "ssl": true}
    },
    {
        "name": "Server2", 
        "status": "stopped",
        "config": {"port": 3000, "ssl": false}
    }
]'
Show-JsonTree -JsonData $arrayComplex

Write-Output "=== Example 6: Single Object with Arrays Only ==="
$arraysOnly = '{
    "servers": ["web1", "web2", "web3"],
    "databases": ["db1", "db2"],
    "environments": ["dev", "staging", "prod"]
}'
Show-JsonTree -JsonData $arraysOnly

Write-Output "=== Example 7: Empty Arrays and Null Values ==="
$withNulls = '{
    "name": "TestItem",
    "description": null,
    "tags": [],
    "metadata": {},
    "active": true
}'
Show-JsonTree -JsonData $withNulls

Write-Output "=== Example 8: Deeply Nested Single Object ==="
$deepNested = '{
    "name": "DeepStructure",
    "level1": {
        "level2": {
            "level3": {
                "value": "deep value",
                "items": ["a", "b", "c"]
            }
        }
    }
}'
Show-JsonTree -JsonData $deepNested

Write-Output "=== Example 9: File Sizes with Transformation ==="
$fileSizes = '{
    "name": "FileSystem",
    "files": [
        {"name": "small.txt", "size": 512},
        {"name": "medium.doc", "size": 2048576},
        {"name": "large.zip", "size": 1073741824}
    ],
    "totalSize": 1075792896,
    "freeSpace": 5368709120
}'
$sizeTransform = @{
    'size' = New-FileSizeTransform
    'totalSize' = New-FileSizeTransform
    'freeSpace' = New-FileSizeTransform
}
Show-JsonTree -JsonData $fileSizes -Transform $sizeTransform
