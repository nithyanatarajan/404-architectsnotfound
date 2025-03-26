import matplotlib.pyplot as plt
from matplotlib.lines import Line2D
import networkx as nx

# Create a directed graph
G = nx.DiGraph()

# Nodes (services)
services = {
    "InterviewLogger": "InterviewLogger (ATS)",
    "Chatbot": "Recruiter Chatbot",
    "Recruiter": "Recruiter",
    "Scheduler": "scheduler-service",
    "Matcher": "matcher-service",
    "Calendar": "calendar-adapter-service",
    "LeavePlanner": "leave-planner-service",
    "MyMindComputeProfile": "myMindComputeProfile-service",
    "Notifier": "notifier-service",
    "Dashboard": "recruiter-dashboard-service",
    "Reporting": "reporting-service"
}

# Add nodes
for key, label in services.items():
    G.add_node(key, label=label)

# Add communication edges with types
edges = [
    ("Recruiter", "Chatbot", "API"),
    ("Chatbot", "Matcher", "API"),
    ("Matcher", "MyMindComputeProfile", "API"),
    ("Matcher", "LeavePlanner", "API"),
    ("Matcher", "Scheduler", "API"),
    ("Scheduler", "Calendar", "API"),
    ("Calendar", "Scheduler", "Event"),
    ("Scheduler", "Notifier", "Event"),
    ("Scheduler", "InterviewLogger", "API"),
    ("InterviewLogger", "Reporting", "Event"),
    ("Scheduler", "Reporting", "Event"),
    ("Scheduler", "Dashboard", "Event"),
    ("Notifier", "Recruiter", "Event"),
    ("Notifier", "Chatbot", "Event"),
]

# Define layout
pos = nx.spring_layout(G, seed=42)

# Draw nodes
plt.figure(figsize=(16, 12))
nx.draw_networkx_nodes(G, pos, node_size=3000, node_color='lightblue')

# Draw labels
nx.draw_networkx_labels(G, pos, labels=services, font_size=10)

# Draw edges with styles based on communication type
api_edges = [(u, v) for u, v, d in edges if d == "API"]
event_edges = [(u, v) for u, v, d in edges if d == "Event"]

nx.draw_networkx_edges(G, pos, edgelist=api_edges, width=2, edge_color='green', style='solid', connectionstyle='arc3,rad=0.2')
nx.draw_networkx_edges(G, pos, edgelist=event_edges, width=2, edge_color='orange', style='dashed', connectionstyle='arc3,rad=-0.2')

# Add custom legend
legend_elements = [
    Line2D([0], [0], color='green', lw=2, label='API (Sync)'),
    Line2D([0], [0], color='orange', lw=2, linestyle='--', label='Event (Async)')
]
plt.legend(handles=legend_elements, loc="upper left")

# Final formatting
plt.title("System Communication Diagram: API vs Event Channels")
plt.axis("off")
plt.tight_layout()
plt.show()
