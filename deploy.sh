# 1. Create cluster
# 2. Destine kubectl to the cluster
# 3. Run following commands:
export RELAY_KEY=***-***-***-****-****
export RELAY_SECRET=****

helm repo add webhookrelay https://charts.webhookrelay.com
# docker login must be already executed 
kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=/home/zuber/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson

kubectl create -f secrets/backend.yaml

helm upgrade --install webhookrelay-operator webhookrelay/webhookrelay-operator --set credentials.key=$RELAY_KEY --set credentials.secret=$RELAY_SECRET

helm upgrade --install keel keel/keel --set helmProvider.enabled="false" --set service.enabled="true" --set service.type="ClusterIP"

kubectl create -f cd/prod/cd.yaml
kubectl create -f deployments/prod/app.yaml

kubectl exec --stdin --tty sunpay-frontend-dev-deployment-7fbb5ff955-npqhm -- /bin/bash
