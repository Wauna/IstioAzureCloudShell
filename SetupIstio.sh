#!/bin/bash
ISTIO_VERSION="1.2.0"
EMAIL="ctheis@hycie.com"
GRAFANA_USER="grafana"
KIALI_USER="kiali"
SETUP_PWD="blablahblah" #used for granfa and kiali

cd istio-$ISTIO_VERSION

echo "Creating namespace..."
#  CREATE THE NAMESPACE
kubectl create namespace istio-system
kubectl apply -f ../default-limits.yaml --namespace=istio-system


echo "Creating grafana secret..."
###############################
# CREATE GRAFANA SECRET
###############################
  GRAFANA_USERNAME=$(echo -n $GRAFANA_USER | base64)
  GRAFANA_PASSPHRASE=$(echo -n $SETUP_PWD | base64)

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: grafana
  namespace: istio-system
  labels:
    app: grafana
type: Opaque
data:
  username: $GRAFANA_USERNAME
  passphrase: $GRAFANA_PASSPHRASE
EOF



#echo "Creating Kiali Secret..."
###############################
# CREATE KIALI SECRET
###############################

#KIALI_USERNAME=$(echo -n $KIALI_USER | base64)
#KIALI_PASSPHRASE=$(echo -n $SETUP_PWD | base64)

#cat <<EOF | kubectl apply -f -
#apiVersion: v1
#kind: Secret
#metadata:
#  name: kiali
#  namespace: istio-system
#  labels:
#    app: kiali
#type: Opaque
#data:
#  username: $KIALI_USERNAME
#  passphrase: $KIALI_PASSPHRASE
#EOF

  


#Install CRD's
#helm delete istio-init --purge
#helm install install/kubernetes/helm/istio-init --name istio-init --namespace istio-system
echo "Installing CRDs...."
for i in install/kubernetes/helm/istio-init/files/crd*yaml; do kubectl apply -f $i; done

#INSTALL ISTIO
#helm delete istio --purge
echo "Installing Istio..."


helm install install/kubernetes/helm/istio --name istio --namespace istio-system \
  --set global.controlPlaneSecurityEnabled=true \
  --set mixer.adapters.useAdapterCRDs=false \
  --set mixer.policy.autoscaleEnabled=false \
  --set mixer.policy.replicaCount=1 \
  --set pilot.autoscaleEnabled=false \
  --set pilot.replicaCount=1 \
  --set pilot.resources.limits.memory=256Mi \
  --set grafana.enabled=true \
  --set grafana.security.enabled=true \
  --set tracing.enabled=false \
  --set kiali.enabled=true \
  --set gateways.istio-ingressgateway.sds.enabled=true \
  --set gateways.istio-ingressgateway.sds.resources.limits.memory=256Mi \
  --set gateways.istio-ingressgateway.autoscaleEnabled=false \
  --set gateways.istio-ingressgateway.replicaCount=1 \
  --set gateways.istio-ingressgateway.resources.limits.memory=256Mi \
  --set gateways.istio-ingressgateway.resources.limits.cpu=200m \
  --set global.k8sIngress.enabled=true \
  --set global.k8sIngress.enableHttps=true \
  --set global.k8sIngress.gatewayName=ingressgateway \
  --set certmanager.enabled=true \
  --set certmanager.email="ctheis@hycite.com" \
  --values install/kubernetes/helm/istio/values-istio-demo-auth.yaml 
  
 # LOW RESOURCE INSTALLTION
  helm upgrade istio install/kubernetes/helm/istio \
  --set global.controlPlaneSecurityEnabled=true \
  --set mixer.adapters.useAdapterCRDs=false \
  --set mixer.policy.autoscaleEnabled=false \
  --set mixer.policy.replicaCount=1 \
  --set pilot.autoscaleEnabled=false \
  --set pilot.replicaCount=1 \
  --set pilot.resources.request.memory=128Mi \
  --set pilot.resources.limits.memory=256Mi \
  --set grafana.enabled=true \
  --set grafana.security.enabled=true \
  --set tracing.enabled=false \
  --set kiali.enabled=true \
  --set gateways.istio-ingressgateway.sds.enabled=true \
  --set gateways.istio-ingressgateway.sds.resources.request.memory=128Mi \
  --set gateways.istio-ingressgateway.sds.resources.limits.memory=256Mi \
  --set gateways.istio-ingressgateway.autoscaleEnabled=false \
  --set gateways.istio-ingressgateway.replicaCount=1 \
  --set gateways.istio-ingressgateway.resources.request.memory=128Mi \
  --set gateways.istio-ingressgateway.resources.limits.memory=256Mi \
  --set gateways.istio-ingressgateway.resources.limits.cpu=200m \
  --set global.k8sIngress.enabled=true \
  --set global.k8sIngress.enableHttps=true \
  --set global.k8sIngress.gatewayName=ingressgateway \
  --set certmanager.enabled=true \
  --set certmanager.email="ctheis@hycite.com" \
  --values install/kubernetes/helm/istio/values-istio-demo-auth.yaml 
cd ..