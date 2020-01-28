```yaml
id: OP-0002
title: Secure Channels
status: Draft
```

# Secure Channels

This document specifies a protocol for two entities to establish and use
secure communication channels that prevents eavesdropping, tampering, and
forgery of messages en-route.

We assume that any message in this protocol could take a complex route that
may involve multiple transport connections which, in turn, may use various
transport protocols.

We also assume that the two communicating machines may not be online at the
same time and messages may be cached along the route and delivered at a
later time.

## References

1. <span id="reference-1"></span>Canetti, R. and Krawczyk, H.,
Analysis of Key-Exchange Protocols and Their Use for Building Secure Channels.
https://ia.cr/2001/040
