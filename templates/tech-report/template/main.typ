#import "@local/tech-report:0.1.0": *

// Marks are defined per document: a gray card ("fill", the default) or a
// hairline frame ("outline"). Marks with a `register` get a generated list
// after the contents; the `description` feeds the key on the document
// control page.
#let mark-specs = (
  decision: (
    label: "Open decision",
    register: "Open decisions",
    description: [A recommended default the team still has to confirm, with the owner named.],
  ),
  risk: (
    label: "Risk",
    description: [A known weakness, with its likelihood and impact.],
  ),
  note: (
    label: "Note",
    style: "outline",
    description: [Context that helps the reader but changes no decision.],
  ),
)
#let (decision, risk, note) = marks(mark-specs)

#show: report.with(
  title: "Project Atlas",
  subtitle: "Target architecture and migration plan",
  doc-type: "Architecture design",
  doc-id: "ATL-ARCH-001",
  version: "0.1",
  status: "Draft",
  date: datetime(year: 2026, month: 1, day: 15),
  classification: "Internal",
  organisation: "Example Org",
  logo: placeholder-logo, // your own: path("logo.svg")
  authors: (
    (
      name: "Jane Doe",
      role: "Platform Engineer",
      email: "jane.doe@example.com",
    ),
  ),
  owner: "Platform team",
  reviewers: ("Security architecture",),
  distribution: ("Platform team", "Security architecture"),
  handling: [Internal. Do not distribute outside the project team.],
  notice: [Working draft for review. Sections marked as open decisions are not agreed.],
  history: (
    (
      version: "0.1",
      date: datetime(year: 2026, month: 1, day: 15),
      author: "Jane Doe",
      change: [First draft.],
    ),
  ),
  marks: mark-specs,
  // Abbreviations: the first use of each one the text uses twice reads
  // "full name (ABBR)", and those entries are listed after the contents.
  glossary: (
    API: "application programming interface",
    CI: "continuous integration",
    SLA: "service level agreement",
  ),
)

= Executive summary <sec-summary>

#lorem(80)

The target design is described in @sec-target and its open questions are
listed in @sec-decisions. Every service publishes an API with an SLA, and the
API gateway reports against that SLA.

#note[
  Section numbers in references are live: they follow the headings if
  sections move.
]

= Target architecture <sec-target>

== Shape and principles

#lorem(60)

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    table.header([Layer], [Today], [Target]),
    [Compute], [Shared virtual machines], [One private cluster per environment],
    [Identity], [Shared service accounts], [Workload identity per app],
    [Delivery], [Manual deployments], [GitOps from reviewed pull requests],
  ),
  caption: [Today and the target, by layer],
)

#decision(id: "D2", title: [Ingress controller], mention: true)[
  Recommended default: the managed gateway. Full entry in @sec-decisions.
]

== Example configuration

```yaml
apiVersion: example/v1
kind: App
metadata:
  name: atlas
spec:
  owner: platform-team
```

#risk[
  The shared database server remains a single point of failure until the
  migration completes.
]

= Open decisions <sec-decisions>

#decision(id: "D1", title: [Compute platform])[
  Options: managed Kubernetes or a container platform. Recommended default:
  managed Kubernetes. Owner: platform team.
]

#decision(id: "D2", title: [Ingress controller])[
  Options: a managed gateway or a self-run proxy. Recommended default: the
  managed gateway. Owner: platform team.
]

#show: appendix

= Definitions

/ GitOps: Delivery where a Git repository is the source of truth for what
  runs.
/ Workload identity: An identity issued to a running workload instead of a
  stored secret.
