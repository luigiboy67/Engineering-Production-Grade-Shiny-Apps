# the sooner you start with a robust framework the better, and the longer you wait the harder it gets to convert your application to a production-ready one
# The choice of tools and how the team is structured is crucial for a successful application.
# Breaking things is a natural process of software engineering, notably when working on a piece of code during a long period.
# Be informed that the codebase is broken: this is the role of tests combined with CI.
# Be able to identify changes between versions, and potentially, get back in time to a previous codebase: this is the role of version control.
# A large codebase implies that the safe way to work is to split the app into pieces.
# Extract your core “non-reactive” functions, which we will also call the “business logic”, and include them in external files
# Split your app into shiny modules
# The person in charge of the development will have a complete view of the entire project and manage the team so that all developers implement features that fit together.
# Developers will focus on small features