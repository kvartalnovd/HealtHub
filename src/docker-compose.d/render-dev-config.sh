#!/bin/bash 

DIR_SCRIPT=`dirname "$(readlink -f "$0")"`

TEMPLATES_PATH="$DIR_SCRIPT"/templates.dev.configs
OUTPUT_CONFIGS_PATH="$DIR_SCRIPT"/debug.d
VAULT_PATH_SECRET="apps/data/HealthHub/dev"

if [[ "$ldap_login" = "" ]]; then
    read -p "ldap_login: " ldap_login
fi

if [[ "$ldap_password" = "" ]]; then
    read -s -p "ldap_password: " ldap_password
fi

mkdir -p "$OUTPUT_CONFIGS_PATH"

vault_token=$(curl -s --request POST --data '{"password": "'"$ldap_password"'"}' https://vault.corp.healthub.ru/v1/auth/ldap/login/"$ldap_login" | jq -r '."auth"."client_token"')
secrets=`curl -s -H "X-Vault-Token: $vault_token" -X GET https://vault.corp.healthub.ru/v1/"$VAULT_PATH_SECRET" | jq .data.data`
for k in $(echo "$secrets" | jq -r ' keys | to_entries[] | "\(.value)"')
do
    v="$(echo "$secrets" | jq -r ".\"$k\"")"
    eval export VAULT_"$k"="'$v'"
done

ALL_ENV=`env | awk -F '=' '{print "$"$1}' ORS=' '`

for filepath in $TEMPLATES_PATH/*; do
  filename=`basename $filepath`
  envsubst "$ALL_ENV" < $filepath > $OUTPUT_CONFIGS_PATH/config-${filename%.*}-dev.${filename##*.}
done
