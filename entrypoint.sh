#!/bin/bash
set -euo pipefail

# 如果没有传入必要参数，则提示并退出
if [ -z "${CB_HOST:-}" ]; then
  echo "No CB_HOST provided. This image only runs export when parameters are passed."
  exit 0
fi

echo "Configuring rclone..."
mkdir -p ~/.config/rclone
cat <<EOF > ~/.config/rclone/rclone.conf
[r2]
type = s3
provider = Cloudflare
access_key_id = ${R2_ACCESS_KEY_ID}
secret_access_key = ${R2_SECRET_ACCESS_KEY}
endpoint = ${R2_ENDPOINT}
acl = private
EOF

mkdir -p "${EXPORT_DIR}"

echo "Exporting NDJSON from Couchbase Capella..."
cbexport json \
  --cluster couchbases://${CB_HOST} \
  --bucket ${CB_BUCKET} \
  --username ${CB_USER} \
  --password ${CB_PASSWORD} \
  --format lines \
  --output "${EXPORT_DIR}/${EXPORT_FILE}" \
  --include-key include_key_id \
  --scope-field ${SCOPE_FIELD} \
  --cacert /certs/capella.pem \
  --threads 4

echo "Splitting NDJSON by collection..."
mkdir -p "${EXPORT_DIR}/collections"

while IFS= read -r line; do
  collection=$(echo "$line" | jq -r ".${SCOPE_FIELD} | split(\"/\") | .[1]")
  echo "$line" >> "${EXPORT_DIR}/collections/${collection}.json"
done < "${EXPORT_DIR}/${EXPORT_FILE}"

echo "Creating archive..."
cd "${EXPORT_DIR}/collections"
tar -czf "/backup/${ARCHIVE_NAME}" *.json

echo "Uploading to R2..."
rclone copy "/backup/${ARCHIVE_NAME}" r2:${R2_BUCKET}/ \
  --s3-no-check-bucket --checksum -q

echo "Done."
