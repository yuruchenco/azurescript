# Description: This script lists all the files in the file share
$accountName = "<YourAccountName>"
$accountKey = "<YourAccountKey>"

# Recursive function to get the list of files in the file share
function ListFiles($shareName, $dirPath, $context, $share_count) {
    $items = $null
    try {
        if ($share_count -eq 0) {
            $items = Get-AzStorageFile -ShareName $shareName -Context $context -ErrorAction SilentlyContinue
            $share_count++       } else {
            $items = Get-AzStorageFile -ShareName $shareName -Context $context -Path $dirPath | Get-AzStorageFile
        }
    } catch {
        return
    }
    $i =0
    $items | ForEach-Object {
        if ($_.GetType().Name -eq "AzureStorageFileDirectory") {
            ListFiles $shareName $_.ShareDirectoryClient.Path $context $share_count            
        } else {
            Write-Host "Path:" $dirPath "File Name:" $_.Name "Size:" $_.FileProperties.ContentLength "bytes"
        }
        $i++
    }

}

# Get the list of containers
$context = New-AzStorageContext -StorageAccountName $accountName -StorageAccountKey $accountKey

# Get the list of file shares
$fileShares = Get-AzStorageShare -Context $context | Select-Object -ExpandProperty Name -Unique

# Loop through all file shares
$count=0
$fileShares | ForEach-Object {
    $count=0
    Write-Host "ShareName:" $_
    ListFiles $_ "" $context $count
}
