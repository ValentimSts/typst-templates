#import "@local/cv:0.1.0": *

#show: cv.with(
  name: "Your Name",
  // Known kinds get an icon and a link: github, linkedin, email, phone,
  // website, location. Remove the ones you do not use.
  contacts: (
    github: "username",
    linkedin: "username",
    email: "name@example.com",
    phone: "+351 900 000 000",
  ),
)

= Summary

One or two sentences on who you are and what you focus on.

= Work Experience

#entry(
  title: [Role],
  subtitle: [Company],
  location: [City, Country],
  meta: [Jan 2025 -- Present],
)[What you did, with what, and what came of it.]

= Projects

#entry(
  title: [Project],
  meta: link("https://github.com/username/project")[GitHub],
)[What it is and what it is built with.]

= Education

#entry(
  title: [Degree],
  subtitle: [University],
  location: [City, Country],
  meta: [Sep 2021 -- Jul 2024],
)[
  - A distinction.
]

= Skills

#skills((
  "Programming": ("Python", "TypeScript"),
  "Tools": ("Git", "Docker"),
))

= Languages

#languages((
  English: [Native],
))
