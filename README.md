# An Unkindness of Ravens
![License](https://img.shields.io/github/license/dblanchard/RavenCyberGroup?color=blue)
![Issues](https://img.shields.io/github/issues/dblanchard/RavenCyberGroup)
![Last Commit](https://img.shields.io/github/last-commit/dblanchard/RavenCyberGroup)
![Language](https://img.shields.io/github/languages/top/dblanchard/RavenCyberGroup)

The collective noun for ravens is an _unkindness_, _conspiracy_, _treachery_, or _rave_. The latter three all have their own baggage, so this flock is an **unkindness**.

This project supports penetration testing of executives' home networks. See [special legal considerations for testing home networks]()

It is comprised of a collection of Raspberry Pis, called ravens (see [disclaimer](#disclaimer)). I deploy one raven at each remote location and have one at the office hosting command and control (C2) for the remotes to phone home to via [Tailscale](https://tailscale.com).

## Architecture Overview

- `raven0` is the C2 host ([see raven0 setup](#raven0-c2-setup))
- `raven***n***` are the remote agents ([see remote setup](#remote-raven-setup))
- Each remote must be manually added to the target network (a shortcut past initial access methods like phishing)

### Why skip initial access?

The C2 host is raven0 ([raven0 C2 setup](#raven0-c2-setup)), each of the others is raven***n***, where *n* is assigned automatically by ([remote raven setup](#remote-raven-setup)). Each remote needs to be added to the target network, which I acknowledged shortcuts the initial attack vectors, e.g. phishing attack. This is for two reasons:
* Legal considerations: inserting a pre-approved device is cleaner and safer
* Time considerations: data collection and pivoting start immediately while the phishing campaign runs in parallel

While IPs assigned by ISPs seldom rotate, it would wreck you for them rotate on you leaving you targeting network you aren't authorized for. If your statement of work and accompanying authorization is for specific ranges of IPs, and one of the target networks get a new IP lease, you won't have any way of knowing the issue.

Phishing is the dominant vector for real-world breach initiation, and it is included in all RCG's engagements unless explicitly prohibited in the SoW or authorization. However, phishing does have a non-zero failure rate and even if the target opens the phish and clicks through, technical issues can prevent success. Joining a raven to each network allows pen test data collection and analysis to begin immediately while phishing and other work moves forward in parallel.

---

# Disclaimer
Pen testing is inherintly risky; know the bounds of your SoW and authorization and know your personal limits.
This project has only been tested using the following hardware: 
* [Raspberry Pi 5 with 8GB RAM](https://www.amazon.com/dp/B0DMLHFQQN/?coliid=IL9W9CCWJSS7V&colid=36ZTS9WRSIRJ4&psc=0&ref_=list_c_wl_lv_ov_lig_dp_it)
* [Anker 45W USB C Charger Block](https://www.amazon.com/dp/B0CQ4P2T8H/?coliid=I3KKL8CWOO163B&colid=36ZTS9WRSIRJ4&psc=1&ref_=list_c_wl_lv_ov_lig_dp_it)
* [Samsung PM9A1a 512GB NVMe SSD M.2](https://www.amazon.com/dp/B0DXM82L47/?coliid=I3L2MTH6D5EUMV&colid=36ZTS9WRSIRJ4&psc=1&ref_=list_c_wl_lv_ov_lig_dp_it)
* [Argon NEO 5 M.2 NVME Case with Built-in Fan](https://www.amazon.com/dp/B0CRH8V95R/?coliid=INL9L1KGOF2J2&colid=36ZTS9WRSIRJ4&psc=1&ref_=list_c_wl_lv_ov_lig_dp_it)
* [ALFA AWUS036AXML Wi-Fi Adapter](https://www.amazon.com/dp/B0BY8GMW32/?coliid=IKGQFI7U3TEHW&colid=36ZTS9WRSIRJ4&psc=1&ref_=list_c_wl_lv_ov_lig_dp_it)
* [CONMDEX 1ft USB 3.1 Gen 2 USB C Charger Cable](https://www.amazon.com/dp/B0CLXZHC5R/?coliid=IGOHIJITKYW5J&colid=36ZTS9WRSIRJ4&psc=1&ref_=list_c_wl_lv_ov_lig_dp_it)
* [M3 Command Strips](https://www.amazon.com/dp/B07P32RHQ4/?coliid=I1FER4FSGP80C3&colid=36ZTS9WRSIRJ4&psc=1&ref_=list_c_wl_lv_ov_lig_dp_it) - used for mounting RPis to walls as needed. Stick to the plastic part of the bottom of the NEO cases, not the aluminum, for better adhesion when the case gets warm.

In all, the hardware ran me about US$310/raven in mid-2025.

---

# Setup
## All Raspberry Pis
Run the [QA script](#???link to script)

## raven0 C2 setup
After running the [QA script](#all-raspberry-pis), run the [raven0 C2 setup](https://github.com/dblanchard/RavenCyberGroup/tree/main/raven0%20C2%20setup)] script.

## remote raven setup
After running the [QA script](#all-raspberry-pis), run the [remote raven setup](https://github.com/dblanchard/RavenCyberGroup/tree/main/remote%20raven%20setup)] script.

---

## ⚠️ IP Lease Warning

ISP-assigned IPs can rotate unexpectedly. If your scope of authorization includes only specific IP ranges and a target receives a new lease, you risk testing **unauthorized targets**.

---

## ✅ Phishing Is Still in Scope

Phishing is the dominant real-world initial access vector. It is **included in all Raven Cyber Group engagements** unless explicitly prohibited in the statement of work (SoW).

But phishing has a non-zero failure rate. Even if the target clicks through, technical issues may block payload execution. That’s why **deploying ravens upfront** accelerates visibility and persistence while other attack chains proceed.

# Special Legal Considerations for Testing Home Networks
Your SoW and your authorization must both be approved and signed by the owner/operator of the home network or their counsel. Approval by corporate counsel is insufficient unless the home network is operated by the company. See my [sample SoW](???) and [sample authorization](???), provided only for reference, not as legal advice.

As stated earlier, care must be given to not stray from the approved target network if the IP leaes changes.
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

    Burn RPi OS to SSD (not tested with SD cards)

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

