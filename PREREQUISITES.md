# Prerequisites use case 4
```bash
# add repo
helm repo add hashicorp https://helm.releases.hashicorp.com

# install vault
helm install vault hashicorp/vault \
    --namespace=vault \
    --create-namespace \
    --set='server.dev.enabled=true' \
    --set='injector.enabled=true'

# ssh into vault pod
kubectl --namespace=vault exec -it pod/vault-0 -- sh

# add vault policy
cat <<EOF > /home/vault/app-policy.hcl
path "secret*" {
  capabilities = ["read"]
}
EOF
vault policy write app /home/vault/app-policy.hcl

# add kubernetes config
vault auth enable kubernetes
vault write auth/kubernetes/config \
    token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
    kubernetes_host=https://${KUBERNETES_PORT_443_TCP_ADDR}:443 \
    kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

# configure service account
vault write auth/kubernetes/role/use-cases \
    bound_service_account_names=usecase-v4-sa \
    bound_service_account_namespaces=vault,usecase-v4 \
    policies=app \
    ttl=1h

# add password
vault kv put secret/database DATABASE_PASSWORD=foobarbazpass
```
