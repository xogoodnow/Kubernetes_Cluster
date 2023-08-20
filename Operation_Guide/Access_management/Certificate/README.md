# Key generation
#### Create a key for the user

```bash
openssl genrsa -out USERNAME.key 4096
```

# Generate a Certificate Signing Request
##### Using the following command craete a Certificate Signing Request
```bash
openssl req -new -key USERNAME.key -out USERNAME.csr -subj "/CN=USERNAME/"
```

##### Encode the CSR request to base64

```bash
echo "<CSR Request>" | base64  > USERNAME.csr
```

# Manage the CSR on k8s
##### Copy and paste the content of CSR to "Cert_Sign_Request.yaml" file and apply it
```bash
cat USERNAME.csr | base64 | tr -d "\n" > USERNAME.base64.csr
```

##### Check the CSR 
```bash
kubectl get csr
```

##### Approve the CSR which was issue
```bash
kubectl certificate approve USERNAME
```

# Edit the csr and extract the crt content
```bash
echo "VALUE of certicate on base64" | base64 --decode > USERNAME.crt
```
# Manage the files
##### Craete a directory for key and cert
```bash
mkdir /etc/kubernetes/users/USERNAME/
```
##### Move the key and cert file to the directory which you just created
```bash
mv USERNAME.key USERNAME.crt /etc/kubernetes/users/USERNAME/
```
# Permission management
##### Now you need to Create a role for this user. For this purpose, you can use the "USERNAME_Role.yaml" file
```bash
kubectl apply -f USERNAME_role.yaml
```

##### Now you need to bind the role to this user. For this purpose, you can use the "USERNAME_R_Binding.yaml" file
```bash
kubectl apply -f USERNAME_Role_Binding.yaml
```
