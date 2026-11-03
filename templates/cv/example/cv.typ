#import "@local/cv:0.1.0": *

// Every component with made-up data, for checking the look after a change.
// From templates/cv:
//   typst watch example/cv.typ

#show: cv.with(
  name: "Jane Doe",
  contacts: (
    github: "janedoe",
    linkedin: "jane-doe",
    email: "jane.doe@example.com",
    phone: "+351 900 000 000",
  ),
)

= Summary

Security engineer with a background in #lorem(30)

= Work Experience

#entry(
  title: [Security Engineer for Example Corp],
  subtitle: [Lorem Consulting],
  meta: [Nov 2025 -- Present],
)[#lorem(48)]

#entry(
  title: [Research Intern],
  subtitle: [Ipsum Research Institute],
  meta: [Jan 2025 -- Jul 2025],
)[#lorem(40)]

= Projects

#entry(
  title: [Lorem Ipsum Detection System],
  meta: [_Master's thesis_ #h(0.4em) *19/20 final grade*],
)[#lorem(30) It reaches *99.7%* accuracy while handling *1,250+ ops/sec*.]

#entry(
  title: [Dolor],
  meta: link("https://github.com/janedoe/dolor")[GitHub],
)[#lorem(25)]

= Education

#entry(
  title: [Master's Degree in Lorem Ipsum],
  subtitle: [Dolor University],
  location: [Lisbon, Portugal],
  meta: [Sep 2023 -- Oct 2025],
)[
  - Graduated with honours.
  - Awarded a thesis scholarship.
]

#entry(
  title: [Exchange Programme],
  subtitle: [Sit Amet University],
  location: [Darmstadt, Germany],
  meta: [Oct 2024 -- Mar 2025],
)[]

= Skills

#skills((
  "Security": (
    "Malware analysis",
    "Reverse engineering",
    "Static and dynamic analysis",
    "Ghidra",
    "Burp Suite",
  ),
  "Cloud & DevSecOps": ("Azure", "Kubernetes", "Docker", "Terraform", "CI/CD"),
  "Programming": ("Python", "Java", "C", "Rust", "TypeScript", "SQL"),
))

= Languages

#languages((
  Portuguese: [Native],
  English: [C2 Proficiency],
  Japanese: [A1],
))
