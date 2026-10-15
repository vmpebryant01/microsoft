# Version and branch policy

Author: Paul Bryant

`main` contains the current offline-tested examples. It is not a claim that every report works on every product release. The [compatibility index](COMPATIBILITY.md) records the intended product family, source, and live validation status for each report.

Azure Cloud services evolve continuously, so the repository records the Resource Graph query API version and source schema rather than assigning an Azure Cloud product-version branch. Azure Local and on-premises SDN have release families. When a report needs different code or a different schema for a major family, create a branch from the last relevant commit and name it `release/<product>-<family>`, for example `release/azure-local-24h2` or `release/sdn-arc-2506`.

Do not create a release branch by copying identical, unvalidated code. A branch should contain the actual release-specific change, a version note, and offline tests for that change. Mark live validation separately. This policy also applies to later Microsoft product families added to the repository.

No release-specific branches or production-support claims have been made for this collection yet. The current scripts remain on `main` until there is a verified reason for a version split.
