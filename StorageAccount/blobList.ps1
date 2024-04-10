# Description: List all blobs in all containers in a storage account
$accountName = "<YourAccountName>"
$accountKey = "<YourAccountKey>"

# Get the storage context
$context = New-AzStorageContext -StorageAccountName $accountName -StorageAccountKey $accountKey

# Get the list of containers
$containers = Get-AzStorageContainer -Context $context

# Loop through all containers
$containers | ForEach-Object {
    Write-Host "Container:" $_.Name
    $blobs = Get-AzStorageBlob -Container $_.Name -Context $context
    $blobs | ForEach-Object {
        Write-Host "Blob Name:" $_.Name "Size:" $_.Length "bytes"
    }
}
