import streamlit as st

from fetch_data import fetch_data


def get_teams_by_conference_division_ui():
    st.header("Get Teams by Conference and Division")

    conference = st.text_input("Enter Conference (AFC or NFC)")
    division = st.text_input("Enter Division (East, North, South, West)")

    if st.button("Fetch Teams", key="fetch_by_conference_division"):
        input_params = {}
        if conference.strip():
            input_params["conference_name"] = conference.strip()
        if division.strip():
            input_params["division_name"] = division.strip()

        df = fetch_data("teams/by-conference-division", input_params)

        if df is None:
            return

        if not df.empty:
            st.subheader(f"Teams in conference {conference}, division {division}:")
            st.dataframe(df, use_container_width=True, hide_index=True)
        else:
            st.info(
                f"No teams found in conference {conference}, division {division}. "
                "Please check the inputs and try again."
            )
