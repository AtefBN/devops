"""
Script to generate new project gh teams used for authentication and authorization process
during errata create/update actions.
PS: You'll also need to add a list of the team ids to the errata back-end specifically in security.py
"""

import requests
import esgvoc.api as ev

# Configuration
GITHUB_API_URL = "https://api.github.com"
ORG_NAME = "ES-DOC-INSTITUTIONAL"  # Replace with your GitHub organization name
ACCESS_TOKEN = "xxxxx"  # Replace with your GitHub personal access token

# Headers for GitHub API
headers = {
    "Authorization": f"Bearer {ACCESS_TOKEN}",
    "Accept": "application/vnd.github+json",
    "X-GitHub-Api-Version": "2022-11-28",
}
def create_github_team(org, team_data):
    """
    Create a team under a GitHub organization.
    :param org: GitHub organization name
    :param team_data: Dictionary containing team name, description, and privacy
    :return: Response from GitHub API
    """
    url = f"{GITHUB_API_URL}/orgs/{org}/teams"
    payload = {
        "name": team_data["name"],
        "description": team_data.get("description", ""),
        "privacy": team_data.get("privacy", "secret"),
    }
    response = requests.post(url, headers=headers, json=payload)
    return response


def generate_teams_from_esgvoc():
    """
    Use the ESGVOC library to list institution_id values for projects CMIP7 and CORDEX-CMIP6.
    Parse the output and generate the TEAMS_TO_CREATE list.
    """

    projects = ["cmip7", "cmip6plus", "cordex-cmip6"]
    teams = []

    for project_id in projects:
        collection_id = ev.find_collections_in_project(expression='institution', project_id=project_id)[0][0]
        institution_ids = fetch_team_id(ev.get_all_terms_in_collection(project_id=project_id,
                                                                       collection_id=collection_id))
        for inst_id in institution_ids:
            teams.append({
                "name": f"{project_id}-{inst_id}",
                "description": f"Team for {project_id} and institution ID: {inst_id}",
                "privacy": "closed"
            })
    return teams


def fetch_team_id(output):
    institution_ids = []
    for org in output:
        institution_ids.append(org.id)
    return institution_ids
# Generate TEAMS_TO_CREATE from ESGVOC
TEAMS_TO_CREATE = generate_teams_from_esgvoc()


def main():
    for team in TEAMS_TO_CREATE:
        print(f"Creating team: {team['name']}...")
        response = create_github_team(ORG_NAME, team)
        if response.status_code == 201:
            print(f"  ✅ Successfully created team: {team['name']}")
        else:
            print(f"  ❌ Failed to create team: {team['name']}")
            print(f"     Status Code: {response.status_code}")
            print(f"     Response: {response.text}")


if __name__ == "__main__":
    main()
