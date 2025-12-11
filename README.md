Powershell Tree prints json nicely in a tree structure. You can pass in transformations which map a given property's value into the desired format. That's about it.

Usage:

```
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
```

```
$transforms = @{
    'size' = New-FileSizeTransform
    'totalSize' = New-FileSizeTransform
    'freeSpace' = New-FileSizeTransform
}
```

```
Show-JsonTree -JsonData $fileSizes -Transform $transforms
```

```
FileSystem
├─ totalSize: 1.0 GB
├─ freeSpace: 5.0 GB
└─ files
   ├─ small.txt
   │  └─ size: 512 B
   ├─ medium.doc
   │  └─ size: 2.0 MB
   └─ large.zip
      └─ size: 1.0 GB
```
