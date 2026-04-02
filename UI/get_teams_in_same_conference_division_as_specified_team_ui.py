import streamlit as st

from fetch_data import fetch_data


def get_teams_in_same_conference_division_as_specified_team_ui():
    st.header("Get Teams in Same Conference and Division as Specified Team")

    team_name = st.text_input("Enter Team Name")

    if st.button("Fetch Teams", key="fetch_same_conference_division"):
        if not team_name.strip():
            st.warning("Please enter a team name.")
            return

        df = fetch_data(
            f"teams/same-conference-division/{team_name.strip()}",
        )

        if df is None:
            return

        if not df.empty:
            st.subheader(f"Teams in the same conference and division as {team_name}:")
            st.dataframe(df, use_container_width=True, hide_index=True)
        else:
            st.info(
                f"No teams found in the same conference and division as {team_name}. "
                "Please check the team name and try again."
            )
