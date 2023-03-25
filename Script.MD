# Create ConfigMap for MySql DB name

```
kubectl create configmap db-config --from-literal=MYSQL_DATABASE=sqldb
```

### To store the db credentials we will create secrets

```
kubectl create secret generic db-secret --from-literal=MYSQL_ROOT_PASSWORD=rootpassword
```

### Now need to run a mysql pod using these values 

```
kubectl run mysql-pod --image=mysql --dry-run=client -o yaml > mysql-pod.yaml
```
### And below is the output 

```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: mysql-pod
  name: mysql-pod
spec:
  containers:
  - image: mysql
    name: mysql-pod
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

### After Modifications with Configmap and Secrets YAML file will look like

```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: mysql-pod
  name: mysql-pod
spec:
  containers:
  - image: mysql
    name: mysql-pod
    envFrom:
    - configMapRef: 
        name: db-config
    - secretRef:
        name: db-secret
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```
### Now Apply 

```
kubectl apply -f mysql-pod.yaml
```
