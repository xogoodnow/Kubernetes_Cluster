# Create a specific namescpae (This part is not mandatory)
#### You can apply the "USERNAME_Namespace.yaml" manifest

```bash
kubectl apply -f USERNAME_Namespace.yaml
```
# Create a service accoun
#### You can apply the "USERNAME_Serviceaccount.yaml" manifest
```bash
kubectl apply -f USERNAME_Serviceaccount.yaml
```

# Create a cluster role
#### You can apply the "USERNAME_Cluster_Role.yaml" manifest
```bash
kubectl apply -f USERNAME_Cluster_Role.yaml
```

# Create a cluster role
#### You can apply the "USERNAME_Cluster_Role_Binding.yaml" manifest
```bash
kubectl apply -f USERNAME_Cluster_Role_Binding.yaml
```


# Create a secret
#### You can apply the "USERNAME_Secret.yaml" manifest
```bash
kubectl apply -f USERNAME_Secret.yaml
```


# Putting it to work
#### Using the following command extract and base64 decode the secret token
``` bash
kubectl get secrets  < SECRET_NAME >  -o=jsonpath='{.data.token}' -n < NAMESPACE > | base64 --decode > token.txt
```
#### Use can-i module to test the permissions of the service account
``` bash
kubectl auth can-i get pods --as=system:serviceaccount:<NAMESCPAE>:<SERVICEACCOUNT_NAME>
```

#### Use the token for API call
``` bash
curl -k  https://<K8S ENDPOINT>:6443/api/v1/namespaces -H "Authorization: Bearer <BASE64 DECODED TOKEN>"

```

