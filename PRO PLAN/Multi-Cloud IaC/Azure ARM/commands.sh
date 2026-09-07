az group create --name arm-demo-rg --location centralindia



# Validating the template
az deployment group validate --resource-group arm-demo-rg \
--template-file template.json --parameters storageAccountName=arm-demo-99770066



# Deploy
az deployment group create --resource-group arm-demo-rg \
--template-file template.json --parameters storageAccountName=arm-demo-99770066



# Redeploy
az deployment group create --resource-group arm-demo-rg \
--template-file template.json --parameters storageAccountName=arm-demo-99770066


# Delete the resource group
az group delete --name arm-demo-rg 
