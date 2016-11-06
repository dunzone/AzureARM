# login to azure 
Login-AzureRMAccount


# To create storage account you need resource group so first create a new resource group or find an existing one.

# Find the existing resource group
Get-AzureRMResourceGroup

# To create new resource group
New-AzureRmResourceGroup -Name "DunlabsRGPS" -Location "Central US"

# To create storage account
New-AzureRmStorageAccount -Name "dunlabs123" -Type Standard_LRS -ResourceGroupName "DunlabsRGPS" -Location "Central US"

# Find the storage account
Get-AzureRmStorageAccount | select ResourceGroupName,Location


# Find storage key,Storages key are bound to resource groups
Get-AzureRmStorageAccountKey -ResourceGroupName "DunlabsRGPS" -Name "dunlabs123"

# To regenerate the storage key
New-AzureRmStorageAccountKey -ResourceGroupName "DunlabsRGPS" -Name "dunlabs123" -KeyName key2


################## CREATE BLOBS #################


# To Create Blob storage first need to create a context 

$keys=Get-AzureRmStorageAccountKey -ResourceGroupName "DunlabsRGPS" -Name "dunlabs123"
$Context=New-AzureStorageContext -StorageAccountName "dunlabs123" -StorageAccountKey $keys[0].Value


## 1 - Create container

# Create container then give permission ,container name should be in lowercase
New-AzureStorageContainer -Context $Context -Name "mycontainer" -Permission Container


# Find the storage container
Get-AzureStorageContainer -Context $Context

# To upload the file to the container
Set-AzureStorageBlobContent -Context $Context -Container "mycontainer" -File c:\temp\testblobfile.txt

# Get the content of the container
Get-AzureStorageBlob -Context $context -Container "mycontainer"

# download the content form the conatianer

$blob=(Get-AzureStorageBlob -Context $context -Container "mycontainer").Name
Get-AzureStorageBlobContent -Context $context -Container "mycontainer" -Blob $blob -Destination c:\temp\

#Remove the blob file 
Remove-AzureStorageBlob -Context $context -Container "mycontainer" -Blob $blob
                                                                                                                                                                                                                                          
# 1-AZcopy https://azure.microsoft.com/en-gb/documentation/articles/storage-use-azcopy/
# 2-Azure storage Explorer http://storageexplorer.com/


## 2 - create table

New-AzureStorageTable -Name "mytable" -Context $Context

Get-AzureStorageTable -Name "mytable" -Context $Context

Remove-AzureStorageTable -Name "mytable" -Context $Context

## 3 -create Queue



New-AzureStorageQueue -Name "myqueue" -Context $Context

Get-AzureStorageQueue -Name "myqueue" -Context $Context

Remove-AzureStorageQueue -Name "myqueue" -Context $Context


## 4- Create File share

#create a share
$share= New-AzureStorageShare -name "myshare" -Context $Context

#create directory in share
New-AzureStorageDirectory -Share $share -Path "mydirectory"

#upload file to directory
Set-AzureStorageFileContent -Share $share -Path "mydirectory" -Source c:\temp\testblobfile.txt

#remove the share
Remove-AzureStorageShare -name "myshare" -Context $Context
