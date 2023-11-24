# TASK_THREE  
# creating a script to automate a routinely executed task on azure cloud  

# Variables
cosmosDbInstanceName="cosmosinstance0001" 
databaseName="djangodb"
containerName="databasecontainer"
location="eastus"
resourceGroup="RG01"
partitionKey="/id"

# Set defaults for all following commands
az configure --defaults group=$resourceGroup
az configure --defaults location=$location 

printf "Creating a CosmosDB instance named '%s'...this can take long. I mean, really long.\n" $cosmosDbInstanceName
az cosmosdb create --name $cosmosDbInstanceName

# Create a database.
printf "Creating a database named '%s' in the instance '%s'\n" $databaseName $cosmosDbInstanceName
az cosmosdb sql database create --name $databaseName --account-name $cosmosDbInstanceName

# Create a container in the database
printf "Creating a container named '%s' in database '%s'.\n" $containerName $databaseName
az cosmosdb sql container create --name $containerName --partition-key-path $partitionKey --account-name $cosmosDbInstanceName --database-name $databaseName

# Get the primary connection string
printf "Getting primary connection string for instance '%s'.\n" $cosmosDbInstanceName
connectionString=$(az cosmosdb keys list --name $cosmosDbInstanceName --type connection-strings --query 'connectionStrings[0].connectionString' --output tsv)
printf "Use this connection string:\n\n%s\n\n" $connectionString
