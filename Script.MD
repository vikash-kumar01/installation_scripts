# MySql DB Configuration

### Create ConfigMap for MySql DB name
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

### Since its a Db so need to expose using clusterIp

```
kubectl expose pod  mysql-pod --port=3306 --target-port=3306
```

# PHP ADMIN Configurations

### CREATE Configmap for phpadmin | Pass Cluster IP of MySql Pod and MySql Port 3306

```
kubectl create configmap phpadmin-config --from-literal=PMA_HOST=10.104.130.101 --from-literal=PMA_PORT=3306
```
### To store the phpadmin credentials we will create secrets

```
kubectl create secret generic phpadmin-secret --from-literal=PMA_USER=root --from-literal=PMA_PASSWORD=rootpassword
```
### Now need to run a phpadmin pod using these values 

```
kubectl run phpadmin-pod --image=phpadmin --dry-run=client -o yaml > phpadmin-pod.yaml
```
### And below is the output 

```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: phpadmin-pod
  name: phpadmin-pod
spec:
  containers:
  - image: phpmyadmin
    name: phpadmin-pod
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
    run: phpadmin-pod
  name: phpadmin-pod
spec:
  containers:
  - image: phpmyadmin
    name: phpadmin-pod
    envFrom:
    - configMapRef:
        name: phpadmin-config
    - secretRef:
        name: phpadmin-secret
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```
### Now Apply 

```
kubectl apply -f phpadmin-pod.yaml
```

### Since its a Db so need to expose using NodePort

```
kubectl expose pod  phpadmin-pod --type=NodePort --port=8099 --target-port=80 --name=phpadmin-svc
```

# # PHP APP Configurations

```
kubectl run php-app --image=vikashashoke/phpapp
```

### EXPOSING 

```
kubectl expose pod php-app --type=NodePort --port=8088 --target-port=80 --name=phpapp-svc
```
