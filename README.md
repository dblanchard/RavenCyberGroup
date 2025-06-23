This project supports pen testing executives' home networks.

It is comprised of a collection of Raspberry Pis, one for each remote location and one the remotes all phone home to setting up command and control via Tailscale.

The collective noun for ravens is an "unkindness", "conspiracy", "treachery", or "rave." The latter three all have their own baggage, so this flock is an unkindness.

The C2 host is raven0 ([raven0 C2 setup](#raven0-c2-setup)), each of the others is raven*n*, where *n* is assigned automatically by ([remote raven setup](#remote-raven-setup)). Each remote needs to be added to the target network, which is an acknowledged shortcut of the initial attack vectors, e.g. phishing attack. This is for two reasons:
* Legal considerations
* Time considerations

While IPs assigned by ISP's seldom rotate, they do in fact rotate. If your statement of work and accompanying authorization is for specific ranges of IPs, and one of the target networks get a new IP lease, you may end up targeting an IP range you aren't authorized for.

Phishing is the dominant vector for real-world breach initiation, and it is included in all RCG's engagements unless explicitly prohibited in the SoW or authorization. However, phishing does have a non-zero failure rate and even if the target opens the phish and clicks through, technical issues can prevent success. Joining a raven to each network allows pen test data collection and analysis to begin immediately while phishing and other work moves forward in parallel.

# Setup
## All Raspberry Pis
Run the [QA script](#???link to script)

## raven0 C2 setup
After running the [QA script](#all-raspberry-pis), run the [ script](#???link to script)]

## remote raven setup
After running the [QA script](#all-raspberry-pis), run the [ script](#???link to script)]



# An Unkindness of Ravens

This project supports penetration testing of executives' home networks.

It is comprised of a collection of Raspberry Pis — one for each remote location and one acting as command and control (C2) that the remotes all phone home to via [Tailscale](https://tailscale.com).

The collective noun for ravens is an _unkindness_, _conspiracy_, _treachery_, or _rave_. The latter three all have their own baggage, so this flock is an **unkindness**.

---

## Architecture Overview

- `raven0` is the **C2 host** ([see raven0 setup](#raven0-c2-setup))
- `raven_n` are the **remote agents** ([see remote setup](#remote-raven-setup))
- Each remote must be manually added to the target network (a shortcut past initial access methods like phishing)

### Why skip initial access?

This approach is deliberate for two reasons:
- **Legal considerations** — inserting a device is often cleaner and pre-approved
- **Time efficiency** — you can start data collection and pivoting while phishing attempts run in parallel

---

## ⚠️ IP Lease Warning

ISP-assigned IPs can rotate unexpectedly. If your scope of authorization includes only specific IP ranges and a target receives a new lease, you risk testing **unauthorized targets**.

---

## ✅ Phishing Is Still in Scope

Phishing is the dominant real-world initial access vector. It is **included in all Raven Cyber Group engagements** unless explicitly prohibited in the statement of work (SoW).

But phishing has a non-zero failure rate. Even if the target clicks through, technical issues may block payload execution. That’s why **deploying ravens upfront** accelerates visibility and persistence while other attack chains proceed.

---

## 🧠 Project Setup

- 📁 `/raven0 C2 setup` — setup instructions and configs for the command and control Pi
- 📁 `/remote raven setup` — deployment script and hardening for remote units
- 📁 `/shared/` — common files used by both C2 and agents

---

## raven0 C2 setup

> [Add your setup instructions here or link to the relevant markdown]

---

## remote raven setup

> [Add your setup instructions here or link to the relevant markdown]



# An Unkindness of Ravens

![License](https://img.shields.io/github/license/dblanchard/RavenCyberGroup?color=blue)
![Issues](https://img.shields.io/github/issues/dblanchard/RavenCyberGroup)
![Last Commit](https://img.shields.io/github/last-commit/dblanchard/RavenCyberGroup)
![Language](https://img.shields.io/github/languages/top/dblanchard/RavenCyberGroup)

This project supports penetration testing of executives' home networks via a network of Raspberry Pis deployed to each target location. Each unit automatically connects to a central command and control (C2) node using [Tailscale](https://tailscale.com).

> The collective noun for ravens is an **unkindness** — fitting, focused, and quietly ominous.

---

## 🧱 Architecture Overview

- `raven0`: Command and control Pi — deployed to your red team or SOC location
- `raven_n`: Remote Pis — deployed to client environments
- All nodes connect to a private Tailscale tailnet and use mutual authentication

---

## ⚠️ Operational Considerations

- **Legal:** Remote units must be explicitly authorized in the SoW
- **IP drift:** Target networks may change IP; be sure to monitor tailnet identity, not IP alone
- **Phishing:** Still used for access attempts but parallel to raven deployment

---

## 📁 Project Structure

```bash
An Unkindness of Ravens/
├── raven0 C2 setup/         # Configuration for central C2 node
├── remote raven setup/      # Setup, hardening, and check-in scripts for deployed units
├── shared/                  # Shared scripts and utilities
├── LICENSE
└── README.md



raven0 C2 setup

This directory contains the bootstrapping tools and configuration for the central C2 Pi:
Components:

    tailscale-setup.sh: Authenticates to your tailnet with a tagged auth key

    c2-dashboard.py: Optional Flask or CLI interface to track connected units

    health-checks/: Scripts to alert if a unit goes offline

Setup Steps:

    Burn RPi OS to SD card

    Configure tailscale-setup.sh with an auth key

    Run initial boot script and verify connectivity

    See raven0 C2 setup/ for full details.

🛰️ remote raven setup

This directory contains tools and automation to set up and harden each deployed unit.
Components:

    setup.sh: Prepares networking, installs tailscale, hardens SSH, disables unnecessary services

    check-in.sh: Scheduled task to report presence to the C2 node

    tags.json: Used for labeling and routing by the C2

Setup Steps:

    Flash image with baked config (or deploy setup script to SD manually)

    Boot, auto-join tailnet, and register to the C2 via ntfy or webhook

    Test remote command ability

    See remote raven setup/ for full details.

🤝 Contributing

All contributions are welcome — forks, pull requests, or ideas. Open an issue if you'd like to suggest a feature or collaborate.
📜 License

This project is licensed under the MIT License.
© 2025 Duane Blanchard. Attribution required, commercial use permitted.



🔮 Coming Soon

    Integration with Shodan, VirusTotal, and custom threat feeds

    Live Grafana dashboards from collected data

    Remote Pi health self-tests and reboot triggers

