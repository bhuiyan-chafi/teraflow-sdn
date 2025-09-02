#!/usr/bin/env bash
set -euo pipefail

echo "Whitelisting IP ranges for VirtualBox 7+ ..."
printf "* 0.0.0.0/0 ::/0\n" | sudo tee /etc/vbox/networks.conf >/dev/null

# If an interface with the desired IP already exists, reuse it.
DESIRED_IP="10.0.2.1"
DESIRED_MASK="255.255.255.0"

existing_if="$(VBoxManage list -l hostonlyifs \
  | awk -v ip="$DESIRED_IP" '
      $1=="Name:"{name=$2}
      $1=="IPAddress:" && $2==ip {print name; exit}
    ')"

if [[ -n "$existing_if" ]]; then
  echo "Found existing host-only IF with IP ${DESIRED_IP}: ${existing_if}"
  ifname="$existing_if"
else
  echo "Creating a host-only network..."
  # Capture the interface name from the create output.
  create_out="$(sudo VBoxManage hostonlyif create 2>&1)"
  echo "$create_out"

  # Extract the name between single quotes.
  if [[ "$create_out" =~ \'([^\']+)\' ]]; then
    ifname="${BASH_REMATCH[1]}"
  else
    # Fallback: diff before/after if parsing ever changes
    echo "Could not parse interface name from output; aborting." >&2
    exit 1
  fi
fi

echo "Configuring ${ifname} with ${DESIRED_IP}/${DESIRED_MASK} ..."
sudo VBoxManage hostonlyif ipconfig "$ifname" --ip "$DESIRED_IP" --netmask "$DESIRED_MASK"

echo "Done. Host-only interface: ${ifname}"