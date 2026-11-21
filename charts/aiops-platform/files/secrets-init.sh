#!/bin/sh
# Pre-install/pre-upgrade hook of charts/aiops-platform (templates/secrets/hook.yaml).
# Ensures the platform Secret and derives the two Secrets the subcharts and
# the gateway policy read by literal name. Idempotent; never echoes a value.
#
# Environment (set by the Job):
#   NAMESPACE          release namespace
#   PLATFORM_SECRET    secrets.name (aiops-platform-secrets)
#   SOURCE_SECRET      secrets.existingSecret, empty when unset
#   GENERATE           secrets.generate ("true"/"false")
#   KEYCLOAK_SECRET    the Secret holding KEYCLOAK_CLIENT_SECRET
#   WRITE_LITELLM_ENV  litellm.enabled ("true"/"false")
set -eu

rand() {
  # $1 characters from [A-Za-z0-9].
  head -c 96 /dev/urandom | base64 | tr -dc 'A-Za-z0-9' | head -c "$1"
}

# The single source of truth for what the platform Secret holds: the create
# path and the backfill path below both drive off this list, so a key added
# here cannot be missed by one of the two.
KEYS="AUTH_SECRET KEYCLOAK_CLIENT_SECRET AUTOMATION_CLIENT_SECRET \
KEYCLOAK_ADMIN_PASSWORD LITELLM_MASTER_KEY LITELLM_SALT_KEY \
DATABASE_USER DATABASE_PASSWORD HF_TOKEN NGC_API_KEY LANGFLOW_SUPERUSER_PASSWORD"

key_value() {
  # key_value <key>: the value to use when the key is (re)generated.
  case "$1" in
    AUTH_SECRET) rand 48 ;;
    KEYCLOAK_CLIENT_SECRET) rand 32 ;;
    AUTOMATION_CLIENT_SECRET) rand 32 ;;
    KEYCLOAK_ADMIN_PASSWORD) rand 24 ;;
    LITELLM_MASTER_KEY) echo "sk-$(rand 40)" ;;
    LITELLM_SALT_KEY) echo "sk-salt-$(rand 32)" ;;
    DATABASE_USER) echo postgres ;;
    DATABASE_PASSWORD) rand 24 ;;
    HF_TOKEN) echo "" ;;
    NGC_API_KEY) echo "" ;;
    LANGFLOW_SUPERUSER_PASSWORD) rand 32 ;;
  esac
}

read_key() {
  # read_key <secret> <key>: the decoded value, empty when missing.
  kubectl -n "$NAMESPACE" get secret "$1" -o "jsonpath={.data.$2}" 2>/dev/null | base64 -d || true
}

apply_secret() {
  # apply_secret <name> <--from-literal args...>
  name=$1; shift
  kubectl -n "$NAMESPACE" create secret generic "$name" "$@" --dry-run=client -o yaml \
    | kubectl apply -f - >/dev/null
  echo "ensured secret $NAMESPACE/$name"
}

if [ -n "$SOURCE_SECRET" ]; then
  # Copy the operator's Secret under the fixed name the subcharts reference.
  kubectl -n "$NAMESPACE" get secret "$SOURCE_SECRET" -o json \
    | jq --arg name "$PLATFORM_SECRET" '{apiVersion, kind, type, data, metadata: {name: $name, namespace: .metadata.namespace}}' \
    | kubectl apply -f - >/dev/null
  echo "copied secret $SOURCE_SECRET into $PLATFORM_SECRET"
elif ! kubectl -n "$NAMESPACE" get secret "$PLATFORM_SECRET" >/dev/null 2>&1; then
  if [ "$GENERATE" != "true" ]; then
    echo "secret $NAMESPACE/$PLATFORM_SECRET is missing and secrets.generate is false" >&2
    exit 1
  fi
  set --
  for key in $KEYS; do
    set -- "$@" --from-literal="$key=$(key_value "$key")"
  done
  kubectl -n "$NAMESPACE" create secret generic "$PLATFORM_SECRET" "$@" >/dev/null
  echo "generated secret $NAMESPACE/$PLATFORM_SECRET"
else
  # An upgrade of a chart that generates a new key never widens the
  # existing Secret on its own; patch in only the keys that are missing,
  # with the same values the create path above would have generated.
  echo "secret $NAMESPACE/$PLATFORM_SECRET exists, checking for missing keys"
  for key in $KEYS; do
    if [ -z "$(read_key "$PLATFORM_SECRET" "$key")" ]; then
      value=$(key_value "$key")
      kubectl -n "$NAMESPACE" patch secret "$PLATFORM_SECRET" --type merge \
        -p "{\"stringData\":{\"$key\":\"$value\"}}" >/dev/null
      echo "patched secret $NAMESPACE/$PLATFORM_SECRET key $key"
    fi
  done
fi

client_secret=$(read_key "$KEYCLOAK_SECRET" KEYCLOAK_CLIENT_SECRET)
if [ -z "$client_secret" ]; then
  echo "secret $NAMESPACE/$KEYCLOAK_SECRET has no KEYCLOAK_CLIENT_SECRET" >&2
  exit 1
fi
apply_secret aiops-gateway-oidc --from-literal=client-secret="$client_secret"

if [ "$WRITE_LITELLM_ENV" = "true" ]; then
  salt=$(read_key "$PLATFORM_SECRET" LITELLM_SALT_KEY)
  if [ -z "$salt" ]; then
    echo "secret $NAMESPACE/$PLATFORM_SECRET has no LITELLM_SALT_KEY" >&2
    exit 1
  fi
  apply_secret aiops-litellm-env --from-literal=LITELLM_SALT_KEY="$salt"
fi
