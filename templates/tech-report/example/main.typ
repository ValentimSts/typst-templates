#import "@local/tech-report:0.1.0": *

// Every component of the template, filled with placeholder text, for
// checking the look after a change. From templates/tech-report:
//   typst watch example/main.typ

// Varied placeholder phrases, so titles and table cells differ.
#let words = (
  lorem(450)
    .split(" ")
    .map(w => w.replace(regex("[^A-Za-z]"), ""))
    .filter(w => w != "")
)
#let phrase(start, n) = {
  let s = words.slice(start, start + n).join(" ")
  upper(s.first()) + s.slice(s.first().len())
}

#let mark-specs = (
  decision: (
    label: "Open decision",
    register: "Open decisions",
    description: [#lorem(14)],
  ),
  risk: (
    label: "Risk",
    register: "Risks",
    description: [#lorem(10)],
  ),
  assumption: (label: "Assumption", style: "outline", description: [#lorem(9)]),
  note: (label: "Note", style: "outline", description: [#lorem(8)]),
  precedent: (
    label: "Precedent",
    style: "outline",
    description: [#lorem(11)],
  ),
  action: (label: "Action", description: [#lorem(7)]),
)
#let (decision, risk, assumption, note, precedent, action) = marks(mark-specs)

#show: report.with(
  title: "Lorem Ipsum Platform",
  subtitle: "Dolor sit amet, consectetur adipiscing elit",
  doc-type: "Architecture design",
  doc-id: "LIP-ARCH-001",
  version: "0.3",
  status: "Draft",
  date: datetime(year: 2026, month: 10, day: 8),
  classification: "Internal",
  organisation: "Lorem Ipsum Ltd",
  logo: placeholder-logo,
  authors: (
    (
      name: "Jane Doe",
      role: "Platform Engineer",
      email: "jane.doe@example.com",
    ),
    (
      name: "John Roe",
      role: "Security Architect",
      email: "john.roe@example.com",
    ),
  ),
  owner: "Platform team",
  reviewers: ("Security architecture", "Enterprise architecture"),
  approvers: ("Head of platform",),
  distribution: ("Platform team", "Security architecture", "Operations"),
  handling: [#lorem(18)],
  notice: [#lorem(40)],
  history: (
    (
      version: "0.1",
      date: datetime(year: 2026, month: 9, day: 1),
      author: "Jane Doe",
      change: [#lorem(8)],
    ),
    (
      version: "0.2",
      date: datetime(year: 2026, month: 9, day: 22),
      author: "John Roe",
      change: [#lorem(14)],
    ),
    (
      version: "0.3",
      date: datetime(year: 2026, month: 10, day: 8),
      author: "Jane Doe",
      change: [#lorem(6)],
    ),
  ),
  keywords: ("lorem", "ipsum"),
  marks: mark-specs,
  list-of-figures: true,
  glossary: (
    API: "application programming interface",
    AKS: "Azure Kubernetes Service",
    CI: "continuous integration",
    RBAC: "role-based access control",
    SLA: "service level agreement",
    TLS: "Transport Layer Security",
    WAF: "web application firewall",
  ),
)

= Executive summary <sec-summary>

The platform runs on AKS behind a WAF. Every API call is authorised through
RBAC, and TLS protects traffic between services. CI publishes signed images;
AKS pulls them by digest, and the WAF blocks requests that fail validation.
Each API has an SLA.

#lorem(110)

#lorem(70) The target design is in @sec-design, its open questions in
@sec-decisions, and the main risk is @R2.

#note[#lorem(30)]

#lorem(90)

= Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do <sec-context>

== Current state <sec-current>

@tab-areas compares each area today and in the target design. #lorem(90)

- #lorem(12)
- #lorem(18)
  - #lorem(10)
  - #lorem(8)
- #lorem(9)

+ #lorem(10)
+ #lorem(14)
+ #lorem(7)

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    table.header([Area], [Today], [Target]),
    ..range(5)
      .map(i => (
        phrase(i * 7, 2),
        phrase(i * 7 + 2, 9),
        phrase(i * 7 + 40, 12),
      ))
      .flatten(),
  ),
  caption: [#phrase(60, 6)],
) <tab-areas>

#assumption[#lorem(25)]

== Constraints

#lorem(70)#footnote[#lorem(15)] #lorem(30)#footnote[#lorem(9)]

/ Lorem: #lorem(12)
/ Ipsum dolor: #lorem(15)
/ Sit amet: #lorem(9)

#quote(block: true, attribution: [Lorem Ipsum])[#lorem(30)]

=== Regulatory

#lorem(60) More at
#link("https://example.com/lorem/ipsum/dolor/sit/amet")[example.com], or
in full: https://example.com/lorem/ipsum/dolor/sit/amet/consectetur.

#precedent[#lorem(20) https://example.com/precedent/lorem-ipsum]

= Target design <sec-design>

== Shape and principles

The overall shape is in @fig-shape. #lorem(100)

#figure(
  rect(width: 100%, height: 55mm, fill: luma(246), stroke: 0.5pt + luma(200))[
    #set align(center + horizon)
    #text(fill: luma(140))[Diagram placeholder]
  ],
  caption: [#phrase(80, 7)],
) <fig-shape>

#decision(id: "D2", title: phrase(12, 3), mention: true)[
  #lorem(20) Full entry in @sec-decisions.
]

== Components

=== Gateway

#lorem(80)

```yaml
apiVersion: lorem/v1
kind: Ipsum
metadata:
  name: dolor
spec:
  replicas: 2            # lorem ipsum dolor sit amet
  egress:
    - connector: sit-amet
      methods: [GET]
      paths: ["/consectetur/*"]
```

Inline code such as `lorem-ipsum` and `dolor.sit.amet` sits in running text.
#lorem(40)

==== Level four heading

#lorem(50)

=== Data

#lorem(70)

#figure(
  table(
    columns: (auto, 2fr, 3fr, 1fr),
    table.header([\#], [Item], [Description], [Status]),
    ..range(26)
      .map(i => (
        str(i + 1),
        phrase(i * 5, 3),
        phrase(i * 9 + 30, 10 + calc.rem(i, 5) * 3),
        if calc.even(i) [Open] else [Closed],
      ))
      .flatten(),
  ),
  caption: [#phrase(120, 5), a table long enough to cross a page],
)

#risk(id: "R2", title: phrase(140, 4), mention: true)[
  #lorem(18) Full entry in @sec-risks.
]

#action[#lorem(16)]

#note[
  #lorem(80)

  #lorem(90)

  - #lorem(10)
  - #lorem(12)

  #lorem(60)
]

= Open decisions <sec-decisions>

#lorem(40)

#for i in range(1, 6) {
  decision(id: "D" + str(i), title: phrase(i * 11, 3))[
    *Options.* #lorem(20)

    *Recommended default.* #lorem(15)

    *Owner to confirm.* #phrase(i * 13, 2) team.
  ]
}

= Risks <sec-risks>

#lorem(35)

#for i in range(1, 5) {
  risk(id: "R" + str(i), title: phrase(i * 17 + 120, 4))[
    #lorem(30)

    *Mitigation.* #lorem(18)
  ]
}

#show: appendix

= Definitions

#table(
  columns: (auto, 1fr),
  table.header([Term], [Meaning]),
  ..range(12)
    .map(i => (strong(phrase(i * 3 + 200, 2)), phrase(i * 8 + 220, 14)))
    .flatten(),
)

= References

- #lorem(8) https://example.com/reference/one
- #lorem(10) https://example.com/reference/two/with/a/longer/path
- #lorem(6) https://example.com/reference/three
