# IstioAzureCloudShell
Sets up your Azure Cloud Shell to use the istio client or command line (istioctl).

# SETUP:
1. Clone this file to your cloud shell. 
2. Execute the script . install-istio.sh
3. Type "istioctl" to confirm it works.
4. Run SetupIstio.sh
5. Confirm the services were setup (note the External IP)
    kubectl get svc -n istio-system --output wide
6. Confirm the pods were setup. (this can take a minute)
    kubectl get pods -n istio-system