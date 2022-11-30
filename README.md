# Docker prometheus on alpine

Prometheus build in Alpine 3.16

## Install

### Step 1: Change configs

Change configuration in ``config/prometheus.yml`` for your targets.

Create .env with target version or remove sample:

``mv .env_sample .env``

### Step 2: Build configuration

Install make in your host machine.

Build configuraion with command ``make build``.

## Step 3: Configure and manage

Use ``make help`` for display all supported commands.
