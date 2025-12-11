# Show various JSON scenarios with Show-JsonTree
Import-Module .\tree.psm1 -Force

Write-Host "=== Example 1: Single Object with Name ===" -ForegroundColor Yellow
$singleWithName = '{"name": "MyFile", "size": 1024, "type": "document", "readonly": true}'
Show-JsonTree -JsonData $singleWithName

Write-Host "=== Example 2: Single Object without Name ===" -ForegroundColor Yellow
$singleWithoutName = '{"size": 2048, "type": "folder", "permissions": "rwx", "hidden": false}'
Show-JsonTree -JsonData $singleWithoutName

Write-Host "=== Example 3: Array of Simple Objects ===" -ForegroundColor Yellow
$arraySimple = '[
    {"name": "File1", "size": 512},
    {"name": "File2", "size": 1024},
    {"name": "File3", "size": 2048}
]'
Show-JsonTree -JsonData $arraySimple

Write-Host "=== Example 4: Single Complex Object with Nested Properties ===" -ForegroundColor Yellow
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

Write-Host "=== Example 5: Array of Complex Objects ===" -ForegroundColor Yellow
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

Write-Host "=== Example 6: Single Object with Arrays Only ===" -ForegroundColor Yellow
$arraysOnly = '{
    "servers": ["web1", "web2", "web3"],
    "databases": ["db1", "db2"],
    "environments": ["dev", "staging", "prod"]
}'
Show-JsonTree -JsonData $arraysOnly

Write-Host "=== Example 7: Empty Arrays and Null Values ===" -ForegroundColor Yellow
$withNulls = '{
    "name": "TestItem",
    "description": null,
    "tags": [],
    "metadata": {},
    "active": true
}'
Show-JsonTree -JsonData $withNulls

Write-Host "=== Example 8: Deeply Nested Single Object ===" -ForegroundColor Yellow
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
