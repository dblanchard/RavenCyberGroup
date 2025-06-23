This project supports pen testing executives' home networks.

It is comprised of a collection of Raspberry Pis, one for each remote location and one the remotes all phone home to setting up command and control via Tailscale.

The collective noun for ravens is an "unkindness", "conspiracy", "treachery", or "rave." The latter three all have their own baggage, so this flock is an unkindness.

The C2 host is raven0 ([raven0 C2 setup](#raven0 C2 setup)
), each of the others is raven_n_ ([remote raven setup](#remote raven setup)). Each remote needs to be added to the target network, which is an acknowledged shortcut of the initial attack vectors, e.g. phishing attack. This is for two reasons:
* Legal considerations
* Time considerations

While IPs assigned by ISP's seldom rotate, they do in fact rotate. If your statement of work and accompanying authorization is for specific ranges of IPs, and one of the target networks get a new IP lease, you may end up targeting an IP range you aren't authorized for.

Phishing is the dominant vector for real-world breach initiation, and it is included in all RCG's engagements unless explicitly prohibited in the SoW or authorization. However, phishing does have a non-zero failure rate and even if the target opens the phish and clicks through, technical issues can prevent success. Joining a raven to each network allows pen test data collection and analysis to begin immediately while phishing and other work moves forward in parallel.

## raven0 C2 setup
## remote raven setup