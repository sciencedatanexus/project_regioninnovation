
mindmap
  root((Innovative Region))
    Output
    ::icon(fas fa-lightbulb)
      Potential Collaborators
      Relevant Scientific Information
      Business Insights \& Opportunities
    Big Data
    ::icon(fas fa-layer-group)
      Publications, Patent Data, Research Links
      GIS Information, Locations, Organisations
    Search Analysis
    ::icon(fas fa-search)
      AI
        Search Engine
        Matching Algorithm

---
config:
  layout: dagre
  look: handDrawn
  theme: nforest
---
flowchart TD
    A((("Are you looking to
    tap into the untapped
    potential of
    regional areas?")))--> Q
    Q(Open Data) -->|Publications, Patent Data, Research Links, GIS Information, People, Locations, Organisations| B(AI)
    B --> | Search Engine, Matching Algorithm| C((Innovative region))
    C -->D(Potential Collaborators)
    C -->E(Relevant Scientific Information)
    C -->F(Business/Development Insights and Opportunities)
