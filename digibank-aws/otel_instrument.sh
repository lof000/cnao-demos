
kubectl scale deployment digital-bank-front -n digibank --replicas=0
kubectl scale deployment digital-bank-credit-deployment -n digibank --replicas=0

kubectl scale deployment digital-bank-backends-atm-java-deployment -n digibank-backends --replicas=0
kubectl scale deployment digital-bank-backends-visa-java-deployment -n digibank-backends --replicas=0
kubectl scale deployment digital-bank-backends-atm-node-deployment -n digibank-backends --replicas=0
kubectl scale deployment digital-bank-backends-visa-node-deployment -n digibank-backends --replicas=0

sleep 10

kubectl scale deployment digital-bank-front -n digibank --replicas=1
kubectl scale deployment digital-bank-credit-deployment -n digibank --replicas=1

kubectl scale deployment digital-bank-backends-atm-java-deployment -n digibank-backends --replicas=1
kubectl scale deployment digital-bank-backends-visa-java-deployment -n digibank-backends --replicas=1
kubectl scale deployment digital-bank-backends-atm-node-deployment -n digibank-backends --replicas=1
kubectl scale deployment digital-bank-backends-visa-node-deployment -n digibank-backends --replicas=1


