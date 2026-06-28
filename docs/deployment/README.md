# Deployment

Every successful `CI` run for the `main` branch triggers the `CD` workflow and
deploys the tested revision to the Hetzner VM at `167.233.99.160`.

## One-time VM setup

Install Docker Engine, the Docker Compose plugin, `curl`, and `rsync`. Then
create the deployment directory and grant it to the deployment user:

```sh
sudo mkdir -p /opt/roborex-platform
sudo chown -R "$USER":"$USER" /opt/roborex-platform
mkdir -p /opt/roborex-platform/docker
```

Create `/opt/roborex-platform/docker/.env` from `docker/.env.example` and
replace every placeholder with a production secret. The deployment preserves
this file and never uploads the local `.env`.

The deployment user must be able to run Docker without `sudo`. Add it to the
Docker group if needed, then sign out and back in:

```sh
sudo usermod -aG docker "$USER"
```

## GitHub production secrets

In the repository, open **Settings → Environments → production** and add the
following secrets:

- `HETZNER_SSH_USER`: the VM deployment user.
- `HETZNER_SSH_PRIVATE_KEY`: its private SSH deployment key.
- `HETZNER_KNOWN_HOSTS`: the verified SSH host-key line for
  `167.233.99.160`.

Add the VM address as an environment **variable** (Settings → Environments →
production → Variables):

- `HETZNER_SSH_HOST`: the VM address, e.g. `167.233.99.160`.

Obtain the host-key line from a trusted connection to the VM and compare its
fingerprint before saving it:

```sh
ssh-keyscan -H 167.233.99.160
```

The matching public deployment key must be present in the VM user's
`~/.ssh/authorized_keys`.

## Deployment behavior

The workflow copies the repository with `rsync`, preserving `docker/.env`,
backups, and logs. It runs Docker Compose in `/opt/roborex-platform` and waits
for `http://127.0.0.1:8000/api/v1/health` to return successfully.

Deployment can also be started manually from **Actions → CD → Run workflow**.
