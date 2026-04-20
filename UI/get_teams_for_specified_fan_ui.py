import streamlit as st

from fetch_data import fetch_data


def get_teams_for_specified_fan_ui():
    st.header("Get Teams for Specified Fan")

    default_app_user_id = st.session_state.get("app_user_id", "")
    app_user_id = st.text_input(
        "Enter Fan AppUserID",
        value=str(default_app_user_id) if default_app_user_id else "",
    )

    if st.button("Fetch Teams", key="fetch_teams_for_specified_fan"):
        if not app_user_id.strip():
            st.warning("Please enter an AppUserID.")
            return

        df = fetch_data(
            f"teams/for-fan/{app_user_id.strip()}",
        )

        if df is None:
            return

        if not df.empty:
            st.subheader(f"Teams for fan AppUserID {app_user_id}:")
            st.dataframe(df, use_container_width=True, hide_index=True)
        else:
            st.info(
                f"No teams were found for fan AppUserID {app_user_id}. "
                "Please check the ID and try again."
            )
